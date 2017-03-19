//
//  FFCacheManager.h
//  FFFoundation
//
//  Created by Florian Friedrich on 19.10.13.
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
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

#ifdef NS_EXTENSIBLE_STRING_ENUM
typedef NSString *FFCacheManagerName NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(CacheManager.Name);
extern const FFCacheManagerName FFDefaultCacheManagerName NS_SWIFT_NAME(default);
#else
typedef NSString *FFCacheManagerName NS_SWIFT_NAME(CacheManagerName);
extern const FFCacheManagerName FFDefaultCacheManagerName NS_SWIFT_NAME(CacheManagerNameDefault);
#endif

NS_SWIFT_NAME(CacheManager)
@interface FFCacheManager : NSObject

@property (nonatomic, copy, readonly) FFCacheManagerName name;

@property (nonatomic) BOOL clearsMemoryCachePeriodically;

+ (instancetype)defaultManager;
- (instancetype)initWithName:(FFCacheManagerName)name;
- (instancetype)init NS_UNAVAILABLE;

- (nullable NSData *)cachedFileWithUniqueName:(NSString *)uniqueName;

- (void)cacheFileWithUniqueName:(NSString *)uniqueName data:(nullable NSData *)data;
- (void)cacheFileWithUniqueName:(NSString *)uniqueName
                           data:(nullable NSData *)data
                     expiryDate:(nullable NSDate *)expiryDate;
- (void)cacheFileWithUniqueName:(NSString *)uniqueName
                           data:(nullable NSData *)data
           identifyingAttribute:(nullable NSString *)identifyingAttribute;

- (BOOL)isFileCurrentWithUniqueName:(NSString *)uniqueName;
- (BOOL)isFileCurrentWithUniqueName:(NSString *)uniqueName
               identifyingAttribute:(nullable NSString *)identifyingAttribute;

- (void)deleteFileFromCacheWithUniqueName:(NSString *)uniqueName;

- (nullable NSURL *)urlOfCachedFileWithUniqueName:(NSString *)uniqueName;

- (void)clearMemoryCache;
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
