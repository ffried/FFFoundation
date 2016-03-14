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
@import Foundation.NSObject;
@import Foundation.NSString;
@import Foundation.NSData;
@import Foundation.NSURL;
@import Foundation.NSDate;

extern NSString * __nonnull const FFDefaultCacheManagerName;

@interface FFCacheManager : NSObject

@property (nonatomic, strong, readonly, nonnull) NSString *name;

@property (nonatomic) BOOL clearsMemoryCachePeriodically;

+ (nonnull instancetype)defaultManager;
- (nonnull instancetype)initWithName:(nonnull NSString *)name;

- (nullable NSData *)cachedFileWithUniqueName:(nonnull NSString *)uniqueName;

- (void)cacheFileWithUniqueName:(nonnull NSString *)uniqueName data:(nullable NSData *)data;
- (void)cacheFileWithUniqueName:(nonnull NSString *)uniqueName
                           data:(nullable NSData *)data
                     expiryDate:(nullable NSDate *)expiryDate;
- (void)cacheFileWithUniqueName:(nonnull NSString *)uniqueName
                           data:(nullable NSData *)data
           identifyingAttribute:(nullable NSString *)identifyingAttribute;

- (BOOL)isFileCurrentWithUniqueName:(nonnull NSString *)uniqueName;
- (BOOL)isFileCurrentWithUniqueName:(nonnull NSString *)uniqueName
               identifyingAttribute:(nullable NSString *)identifyingAttribute;

- (void)deleteFileFromCacheWithUniqueName:(nonnull NSString *)uniqueName;

- (nullable NSURL *)urlOfCachedFileWithUniqueName:(nonnull NSString *)uniqueName;

- (void)clearMemoryCache;
- (void)clearCache;

@end
