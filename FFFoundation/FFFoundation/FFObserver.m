//
//  FFObserver.m
//  FFFoundation
//
//  Created by Florian Friedrich on 14.10.13.
//  Copyright 2013 Florian Friedrich
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <FFFoundation/FFObserver.h>
#import <FFFoundation/FFFoundation-Swift.h>
#import <objc/runtime.h>

@interface NSObject (FFObserver)

@property (nonatomic, readonly) BOOL hasObservers;
@property (nonatomic, strong, readonly) NSMutableArray *ffobservers;

- (void)addFFObserver:(FFObserver *)observer;
- (void)removeFFObserver:(FFObserver *)observer;

@end

#define FF_CONTEXT (__bridge void *)(self)
static NSKeyValueObservingOptions const FFObserverOptions = (NSKeyValueObservingOptionOld |
                                                             NSKeyValueObservingOptionNew);

@interface FFObserver ()

@property (nonatomic) BOOL didRemoveAsObserver;

@end

@implementation FFObserver

#pragma mark - Class Methods
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                             queue:(NSOperationQueue *)queue
                             block:(FFObserverBlock)block {
    return [[self alloc] initWithObject:object keyPath:keyPath queue:queue block:block];
}

+ (instancetype)observerWithObject:(id)object
                           keyPaths:(NSArray *)keyPaths
                             queue:(NSOperationQueue *)queue
                             block:(FFObserverBlock)block {
    return [[self alloc] initWithObject:object keyPaths:keyPaths queue:queue block:block];
}

+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                          selector:(SEL)selector
                             queue:(NSOperationQueue *)queue {
    return [[self alloc] initWithObject:object keyPath:keyPath target:target selector:selector queue:queue];
}

+ (instancetype)observerWithObject:(id)object
                          keyPaths:(NSArray *)keyPaths
                            target:(id)target
                          selector:(SEL)selector
                             queue:(NSOperationQueue *)queue {
    return [[self alloc] initWithObject:object keyPaths:keyPaths target:target selector:selector queue:queue];
}

#pragma mark - Initializers
- (instancetype)initWithObject:(id)object
                      keyPaths:(NSArray *)keyPaths
                         queue:(NSOperationQueue *)queue
                         block:(FFObserverBlock)block {
    NSParameterAssert(object);
    NSParameterAssert(keyPaths);
    self = [super init];
    if (self) {
        _observedObject = object;
        _keyPaths = keyPaths;
        _block = block;
        self.queue = queue;
        [self.keyPaths enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL *stop) {
            [object addObserver:self forKeyPath:keyPath options:FFObserverOptions context:FF_CONTEXT];
        }];
        [object addFFObserver:self];
    }
    return self;
}

- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                         queue:(NSOperationQueue *)queue
                         block:(FFObserverBlock)block {
    NSParameterAssert(keyPath);
    return [self initWithObject:object keyPaths:@[keyPath] queue:queue block:block];
}

- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                        target:(id)target
                      selector:(SEL)selector
                         queue:(NSOperationQueue *)queue {
    NSParameterAssert(keyPath);
    return [self initWithObject:object keyPaths:@[keyPath] target:target selector:selector queue:queue];
}

- (instancetype)initWithObject:(id)object
                      keyPaths:(NSArray *)keyPaths
                        target:(id)target
                      selector:(SEL)selector
                         queue:(NSOperationQueue *)queue {
    NSParameterAssert(target);
    NSParameterAssert(selector);
    FFObserverBlock tempBlock = ^(FFObserver *observer, id object, NSString *keyPath, NSDictionary *changeDictionary) {};
    self = [self initWithObject:object keyPaths:keyPaths queue:queue block:tempBlock];
    if (self) {
        // Define the missing vars
        _target = target;
        _selector = selector;
        
        // Set block
        __weak __typeof(self) welf = self;
        _block = ^(FFObserver *observer, id object, NSString *keyPath, NSDictionary *changeDictionary) {
            __strong __typeof(welf) sself = welf;
            // If target responds to selector
            if ([sself.target respondsToSelector:sself.selector]) {
                // Create NSMethodSignature from selector
                NSMethodSignature *signature = [sself.target methodSignatureForSelector:sself.selector];
                if (signature) { // If it really exists
                    // Create invocation from method signature
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    // Set target and selector
                    invocation.target = sself.target;
                    invocation.selector = sself.selector;
                    NSUInteger args = signature.numberOfArguments; // Get number of arguments
                    // If target wants change dictionary -> add it as argument
                    if (args == 3) { [invocation setArgument:&changeDictionary atIndex:2]; }
                    [invocation invoke]; // Invoke the invocation
                }
            }
        };
    }
    return self;
}

- (nullable instancetype)init {
    return nil;
}

#pragma mark - Deallocation
- (void)dealloc {
    if (self.observedObject != nil) {
        [self removeObserverFromObservedObject:self.observedObject];
    }
}

#pragma mark - Properties
- (NSString *)keyPath {
    return (self.keyPaths.count == 1) ? [self.keyPaths firstObject] : nil;
}

- (void)setQueue:(NSOperationQueue *)queue {
    if (_queue != queue) {
        _queue = queue ?: [NSOperationQueue mainQueue];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == FF_CONTEXT) {
        __weak __typeof(self) welf = self;
        [self.queue addOperationWithBlockAndWaitIfNotCurrentQueue:^{
            __strong __typeof(welf) sself = welf;
            if (sself.block != nil) {
                sself.block(sself, object, keyPath, change);
            }
        }];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)removeObserverFromObservedObject:(id)observedObject {
    if (self.observedObject != nil) {
        NSAssert(self.observedObject == observedObject,
                 @"Wrong object passed into %@", NSStringFromSelector(_cmd));
    }
    if (self.didRemoveAsObserver == NO) {
        [self.keyPaths enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL *stop) {
           [observedObject removeObserver:self forKeyPath:keyPath context:FF_CONTEXT];
        }];
        [observedObject removeFFObserver:self];
        self.didRemoveAsObserver = YES;
    }
}

@end

#pragma mark - Categories
@implementation FFObserver (FFDeprecatedMethods)

+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                             block:(FFObserverBlock)block
                             queue:(NSOperationQueue *)queue {
    return [self observerWithObject:object keyPath:keyPath queue:queue block:block];
}

+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                          selector:(SEL)selector {
    return [[self alloc] initWithObject:object keyPath:keyPath target:target selector:selector];
}

- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                         block:(FFObserverBlock)block
                         queue:(NSOperationQueue *)queue {
    return [self initWithObject:object keyPath:keyPath queue:queue block:block];
}

- (instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath target:(id)target selector:(SEL)selector {
    return [self initWithObject:object keyPath:keyPath target:target selector:selector queue:nil];
}

- (void)removeObserverFromObservingObject {
    [self removeObserverFromObservedObject:self.observedObject];
}

@end

@implementation NSObject (FFObservable)

- (NSMutableArray *)ffobservers {
    NSMutableArray *mutableObservers = objc_getAssociatedObject(self, _cmd);
    if (!mutableObservers) {
        mutableObservers = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, mutableObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mutableObservers;
}

- (BOOL)hasObservers {
    return objc_getAssociatedObject(self, @selector(ffobservers)) != nil;
}

- (void)addFFObserver:(FFObserver *)observer {
    [self.ffobservers addObject:observer];
}

- (void)removeFFObserver:(FFObserver *)observer {
    [self.ffobservers removeObject:observer];
}

- (void)ff_tearDownObservers {
    if (!self.hasObservers) return;
    
    NSArray *observers = [NSArray arrayWithArray:self.ffobservers];
    [observers enumerateObjectsUsingBlock:^(FFObserver *observer, NSUInteger idx, BOOL *stop) {
        [observer removeObserverFromObservedObject:self];
    }];
    [self.ffobservers removeAllObjects];
}

+ (void)load {
    static dispatch_once_t FF_KVOSwizzlingToken;
    dispatch_once(&FF_KVOSwizzlingToken, ^{
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(ff_dealloc);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)ff_dealloc {
    [self ff_tearDownObservers];
    [self ff_dealloc];
}

@end
