//
//  FFObserver.h
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

#import <FFFoundation/FFFoundation.h>
@import Foundation.NSObject;
@import Foundation.NSArray;
@import Foundation.NSOperation;

NS_ASSUME_NONNULL_BEGIN

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
typedef void (^FFObserverBlock)(FFObserver *observer, id object, NSString *keyPath, NSDictionary<NSString *, id> *changeDictionary);

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
@property (nonatomic, weak, readonly, nullable) id target;
/**
 *  The selector which will be called on the target.
 *  Only set if the observer was created with the corresponding initializer / class method.
 */
@property (nonatomic, assign, readonly, nullable) SEL selector;

/**
 *  The observed object.
 */
@property (nonatomic, weak, readonly) id observedObject;
/**
 *  The observed keypaths.
 */
@property (nonatomic, copy, readonly) NSArray<NSString *> *keyPaths;
/**
 *  The observed keypath. Nil if multiple keypaths are observed.
 */
@property (nonatomic, copy, readonly, nullable) NSString *keyPath;

/**
 *  The queue on which the callback will happen. If set to nil it will be reset to mainQueue.
 */
@property (nonatomic, strong, null_resettable) NSOperationQueue *queue;

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
                             queue:(nullable NSOperationQueue *)queue
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
                             queue:(nullable NSOperationQueue *)queue;

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
                          keyPaths:(NSArray<NSString *> *)keyPaths
                             queue:(nullable NSOperationQueue *)queue
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
                          keyPaths:(NSArray<NSString *> *)keyPaths
                            target:(id)target
                          selector:(SEL)selector
                             queue:(nullable NSOperationQueue *)queue;

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
                         queue:(nullable NSOperationQueue *)queue
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
                         queue:(nullable NSOperationQueue *)queue;

#pragma mark Multiple KeyPaths
/**
 *  Creates an observer and registers it.
 *  @param object   The object to observe. Must not be nil.
 *  @param keyPaths The keyPaths to observe on the object. Must not be nil.
 *  @param queue    The queue on which the callback should happen. Will be mainQueue if nil is passed.
 *  @param block    The block to call on observed changes.
 *  @return A new FFObserver instance.
 */
- (instancetype)initWithObject:(nonnull id)object
                      keyPaths:(nonnull NSArray<NSString *> *)keyPaths
                         queue:(nullable NSOperationQueue *)queue
                         block:(nonnull FFObserverBlock)block NS_DESIGNATED_INITIALIZER;

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
                      keyPaths:(NSArray<NSString *> *)keyPaths
                        target:(id)target
                      selector:(SEL)selector
                         queue:(nullable NSOperationQueue *)queue;

/**
 *  Not available. Use one of the other initializers instead!
 */
- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;

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
                             queue:(nullable NSOperationQueue *)queue
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

NS_ASSUME_NONNULL_END
