//
//  FFTimer.h
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

#import <FFFoundation/FFFoundation.h>

#define FFTIMER_AVAILABLE 1

@interface FFTimer : NSObject

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(id)ui repeats:(BOOL)rep;

- (void)fire;

- (NSDate *)fireDate;
- (void)setFireDate:(NSDate *)date;

- (NSTimeInterval)timeInterval;

- (NSTimeInterval)tolerance NS_AVAILABLE(10_9, 7_0);
- (void)setTolerance:(NSTimeInterval)tolerance NS_AVAILABLE(10_9, 7_0);

- (void)invalidate;
- (BOOL)isValid;

- (id)userInfo;

@end

@interface NSRunLoop (FFTimer)

- (void)addFFTimer:(FFTimer *)timer forMode:(NSString *)mode;

@end
