//
//  NSOperationQueue+FFAdditions.m
//
//  Created by Florian Friedrich on 22.03.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "NSOperationQueue+FFAdditions.h"

@implementation NSOperationQueue (FFAdditions)

#pragma mark - Queue comparisons
+ (BOOL)isCurrentQueueMainQueue {
    return [self currentQueue].isMainQueue;
}

- (BOOL)isMainQueue {
    return [self isEqual:[[self class] mainQueue]];
}

- (BOOL)isCurrentQueue {
    return [self isEqual:[[self class] currentQueue]];
}

#pragma mark - Block Operations
- (void)addOperationWithBlock:(void (^)(void))block completion:(void (^)(void))completion {
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:block];
    blockOp.completionBlock = completion;
    [self addOperation:blockOp];
}

- (void)addOperationWithBlock:(void (^)(void))block waitUntilFinished:(BOOL)wait {
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:block];
    [self addOperations:@[blockOp] waitUntilFinished:wait];
}

- (void)addOperationWithBlockAndWaitIfNotCurrentQueue:(void (^)(void))block {
    [self addOperationWithBlock:block waitUntilFinished:!self.isCurrentQueue];
}

@end
