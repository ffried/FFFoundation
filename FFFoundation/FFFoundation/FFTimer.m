//
//  FFTimer.m
//  FFFoundation
//
//  Created by Florian Friedrich on 1.12.13.
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

#import <FFFoundation/FFTimer.h>

@interface FFTimer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

- (void)timerFired:(NSTimer *)timer;

@end


@implementation FFTimer

#pragma mark - NSTimer methods
+ (FFTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
    return [[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:invocation.target selector:invocation.selector userInfo:nil repeats:yesOrNo];
}

+ (FFTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
    FFTimer *timer = [[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:invocation.target selector:invocation.selector userInfo:nil repeats:yesOrNo];
    [[NSRunLoop mainRunLoop] addFFTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

+ (FFTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    return [[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

+ (FFTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
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

- (instancetype)init {
    return [self initWithFireDate:[NSDate date]
                         interval:0.0
                           target:[[NSObject alloc] init]
                         selector:@selector(description)
                         userInfo:nil
                          repeats:NO];
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
