//
//  FFCacheManager.h
//
//  Created by Florian Friedrich on 19.10.13.
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

extern NSString *const FFDefaultCacheManagerName;

@interface FFCacheManager : NSObject

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic) BOOL clearsMemoryCachePeriodically;

+ (instancetype)defaultManager;
- (instancetype)initWithName:(NSString *)name;

- (NSData *)cachedFileWithUniqueName:(NSString *)uniqueName;

- (void)cacheFileWithUniqueName:(NSString *)uniqueName data:(NSData *)data;
- (void)cacheFileWithUniqueName:(NSString *)uniqueName data:(NSData *)data expiryDate:(NSDate *)expiryDate;
- (void)cacheFileWithUniqueName:(NSString *)uniqueName data:(NSData *)data identifyingAttribute:(NSString *)identifyingAttribute;

- (BOOL)isFileCurrentWithUniqueName:(NSString *)uniqueName;
- (BOOL)isFileCurrentWithUniqueName:(NSString *)uniqueName identifyingAttribute:(NSString *)identifyingAttribute;

- (void)deleteFileFromCacheWithUniqueName:(NSString *)uniqueName;

- (NSURL *)urlOfCachedFileWithUniqueName:(NSString *)uniqueName;

- (void)clearMemoryCache;
- (void)clearCache;

@end
