//
//  FFObserver.h
//
//  Created by Florian Friedrich on 14.10.13.
//  Copyright (c) 2013 Florian Friedrich. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

@import Foundation;

@class FFObserver;
/**
 *  The block which will be called whenever a change is observed.
 *
 *  @param observer         The observer which observed the change.
 *  @param object           The object which changed.
 *  @param keyPath          The keyPath which changed.
 *  @param changeDictionary The change dictionary.
 *  @see NSObject#observeValueForKeyPath:ofObject:change:context:
 */
typedef void (^FFObserverBlock)(FFObserver *observer, id object, NSString *keyPath, NSDictionary *changeDictionary);

/**
 *  Handles KVO with ease.
 */
@interface FFObserver : NSObject

#pragma mark - Properties
/**
 *  The block which will be called whenever a change is observed.
 *  Notice: This block is always set, even with target/selector initialization.
 */
@property (nonatomic, copy, readonly) FFObserverBlock block;
/**
 *  The target for the selector.
 *  Only set if the observer was created with the corresponding initializer / class method.
 */
@property (nonatomic, weak, readonly) id target;
/**
 *  The selector which will be called on the target.
 *  Only set if the observer was created with the corresponding initializer / class method.
 */
@property (nonatomic, assign, readonly) SEL selector;

/**
 *  The observed object.
 */
@property (nonatomic, weak, readonly) id observedObject;
/**
 *  The observed keypaths.
 */
@property (nonatomic, copy, readonly) NSArray *keyPaths;
/**
 *  The observed keypath. Nil if multiple keypaths are observed.
 */
@property (nonatomic, copy, readonly) NSString *keyPath;

/**
 *  The queue on which the callback will happen.
 */
@property (nonatomic, strong) NSOperationQueue *queue;

#pragma mark - Class Methods
#pragma mark Single KeyPath
/**
 *  Creates an observer and registers it.
 *  @param object  The object to observe. Must not be nil.
 *  @param keyPath The keyPath to observe on the object. Must not be nil.
 *  @param queue   The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @param block   The block to call on observed changes.
 *  @return A new FFObserver instance.
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                             queue:(NSOperationQueue *)queue
                             block:(FFObserverBlock)block;

/**
 *  Creates an observer and registers it.
 *  @param object   The object to observe. Must not be nil.
 *  @param keyPath  The keyPath to observe on the object. Must not be nil.
 *  @param target   The target which should be notified about observed changes. Must not be nil.
 *  @param selector The selector to call on the target. Must not be nil.
 *  @param queue    The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @return A new FFObserver instance.
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                          selector:(SEL)selector
                             queue:(NSOperationQueue *)queue;

#pragma mark Multiple KeyPaths
/**
 *  Creates an observer and registers it.
 *  @param object   The object to observe. Must not be nil.
 *  @param keyPaths The keyPaths to observe on the object. Must not be nil.
 *  @param queue    The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @param block    The block to call on observed changes.
 *  @return A new FFObserver instance.
 */
+ (instancetype)observerWithObject:(id)object
                          keyPaths:(NSArray *)keyPaths
                             queue:(NSOperationQueue *)queue
                             block:(FFObserverBlock)block;

/**
 *  Creates an observer and registers it.
 *  @param object   The object to observe. Must not be nil.
 *  @param keyPaths The keyPaths to observe on the object. Must not be nil.
 *  @param target   The target which should be notified about observed changes. Must not be nil.
 *  @param selector The selector to call on the target. Must not be nil.
 *  @param queue    The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @return A new FFObserver instance.
 */
+ (instancetype)observerWithObject:(id)object
                          keyPaths:(NSArray *)keyPaths
                            target:(id)target
                          selector:(SEL)selector
                             queue:(NSOperationQueue *)queue;

#pragma mark - Initializers
#pragma mark Single KeyPath
/**
 *  Creates an observer and registers it.
 *  @param object  The object to observe. Must not be nil.
 *  @param keyPath The keyPath to observe on the object. Must not be nil.
 *  @param queue   The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @param block   The block to call on observed changes.
 *  @return A new FFObserver instance.
 */
- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                         queue:(NSOperationQueue *)queue
                         block:(FFObserverBlock)block;

/**
 *  Creates an observer and registers it.
 *  @param object   The object to observe. Must not be nil.
 *  @param keyPath  The keyPath to observe on the object. Must not be nil.
 *  @param target   The target which should be notified about observed changes. Must not be nil.
 *  @param selector The selector to call on the target. Must not be nil.
 *  @param queue    The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @return A new FFObserver instance.
 */
- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                        target:(id)target
                      selector:(SEL)selector
                         queue:(NSOperationQueue *)queue;

#pragma mark Multiple KeyPaths
/**
 *  Creates an observer and registers it.
 *  @param object   The object to observe. Must not be nil.
 *  @param keyPaths The keyPaths to observe on the object. Must not be nil.
 *  @param queue    The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @param block    The block to call on observed changes.
 *  @return A new FFObserver instance.
 */
- (instancetype)initWithObject:(id)object
                      keyPaths:(NSArray *)keyPaths
                         queue:(NSOperationQueue *)queue
                         block:(FFObserverBlock)block NS_DESIGNATED_INITIALIZER;

/**
 *  Creates an observer and registers it.
 *  @param object   The object to observe. Must not be nil.
 *  @param keyPaths The keyPaths to observe on the object. Must not be nil.
 *  @param target   The target which should be notified about observed changes. Must not be nil.
 *  @param selector The selector to call on the target. Must not be nil.
 *  @param queue    The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @return A new FFObserver instance.
 */
- (instancetype)initWithObject:(id)object
                      keyPaths:(NSArray *)keyPaths
                        target:(id)target
                      selector:(SEL)selector
                         queue:(NSOperationQueue *)queue;

@end

#pragma mark - Deprecated
@interface FFObserver (FFDeprecatedMethods)

/**
 *  Creates an observer and registers it.
 *  @param object  The object to observe. Must not be nil.
 *  @param keyPath The keyPath to observe on the object. Must not be nil.
 *  @param block   The block to call on observed changes.
 *  @param queue   The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @return A new FFObserver instance.
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                             block:(FFObserverBlock)block
                             queue:(NSOperationQueue *)queue
__deprecated_msg("Use obesrverWithObject:keyPath:queue:block: instead");

/**
 *  Creates an observer and registers it.
 *  @param object   The object to observe. Must not be nil.
 *  @param keyPath  The keyPath to observe on the object. Must not be nil.
 *  @param target   The target which should be notified about observed changes. Must not be nil.
 *  @param selector The selector to call on the target. Must not be nil.
 *  @return A new FFObserver instance.
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                          selector:(SEL)selector
__deprecated_msg("Use observerWithObject:keyPath:target:selector:queue: instead");

/**
 *  Creates an observer and registers it.
 *  @param object  The object to observe. Must not be nil.
 *  @param keyPath The keyPath to observe on the object. Must not be nil.
 *  @param block   The block to call on observed changes.
 *  @param queue   The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @return A new FFObserver instance.
 */
- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                         block:(FFObserverBlock)block
                         queue:(NSOperationQueue *)queue
__deprecated_msg("Use initWithObject:keyPath:queue:block: instead");

/**
 *  Creates an observer and registers it.
 *  @param object   The object to observe. Must not be nil.
 *  @param keyPath  The keyPath to observe on the object. Must not be nil.
 *  @param target   The target which should be notified about observed changes. Must not be nil.
 *  @param selector The selector to call on the target. Must not be nil.
 *  @return A new FFObserver instance.
 */
- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                        target:(id)target
                      selector:(SEL)selector
__deprecated_msg("Use initWithObject:keyPath:target:selector:queue: instead");

/**
 *  Removes the FFObserver as KVO observer from the observed object.
 */
- (void)removeObserverFromObservingObject __deprecated_msg("Don't use this method, it breaks the internal handling!");

@end
