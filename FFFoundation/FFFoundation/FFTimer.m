//
//  FFTimer.m
//
//  Created by Florian Friedrich on 1.12.13.
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

#import "FFTimer.h"

@interface FFTimer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

- (void)timerFired:(NSTimer *)timer;

@end


@implementation FFTimer

#pragma mark - NSTimer methods
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
    return [[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:invocation.target selector:invocation.selector userInfo:nil repeats:yesOrNo];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
    FFTimer *timer = [[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:invocation.target selector:invocation.selector userInfo:nil repeats:yesOrNo];
    [[NSRunLoop mainRunLoop] addFFTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    return [[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    FFTimer *timer = [[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    [[NSRunLoop mainRunLoop] addFFTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(id)ui repeats:(BOOL)rep {
    self = [super init];
    if (self) {
        self.target = t;
        self.selector = s;
        self.timer = [[NSTimer alloc] initWithFireDate:date interval:ti target:self selector:@selector(timerFired:) userInfo:ui repeats:rep];
    }
    return self;
}

- (void)fire {
    [self.timer fire];
}

- (NSDate *)fireDate {
    return [self.timer fireDate];
}

- (void)setFireDate:(NSDate *)date {
    [self.timer setFireDate:date];
}

- (NSTimeInterval)timeInterval {
    return [self.timer timeInterval];
}

- (NSTimeInterval)tolerance NS_AVAILABLE(10_9, 7_0) {
    return [self.timer tolerance];
}

- (void)setTolerance:(NSTimeInterval)tolerance NS_AVAILABLE(10_9, 7_0) {
    [self.timer setTolerance:tolerance];
}

- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
}

- (BOOL)isValid {
    return [self.timer isValid];
}

- (id)userInfo {
    return [self.timer userInfo];
}

#pragma mark - Fire method
- (void)timerFired:(NSTimer *)timer {
    if (timer == self.timer) {
        if (self.target != nil && self.selector != nil) {
            if ([self.target respondsToSelector:self.selector]) {
                NSMethodSignature *methodSignature = [self.target methodSignatureForSelector:self.selector];
                if (methodSignature) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
                    invocation.selector = self.selector;
                    invocation.target = self.target;
                    if (methodSignature.numberOfArguments == 3) {
                        id timer = self;
                        [invocation setArgument:&timer atIndex:2];
                    }
                    [invocation invoke];
                }
            }
        } else {
            [self invalidate];
        }
    }
}

@end


#pragma mark - NSRunLoop category
@implementation NSRunLoop (FFTimer)

- (void)addFFTimer:(FFTimer *)timer forMode:(NSString *)mode {
    [self addTimer:timer.timer forMode:mode];
}

@end
