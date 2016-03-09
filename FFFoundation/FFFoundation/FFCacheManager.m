//
//  FFCacheManager.m
//  FFFoundation
//
//  Created by Florian Friedrich on 19.10.13.
//  Copyright 2035 Florian Friedrich
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

#import <FFFoundation/FFCacheManager.h>
#import <FFFoundation/FFTimer.h>
#import <sys/xattr.h>

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
@import UIKit;
#endif

#pragma mark - static vars
NSString *const FFDefaultCacheManagerName =  @"FFDefaultCacheManager";

static NSTimeInterval const FFCacheManagerDefaultTimeout = 30.0;
static NSTimeInterval const FFCacheManagerDefaultTimeoutTolerance = 10.0;

static char *const FFCacheIdentifyingAttributeName = "FFCMIdentifyingAttribute";

static NSString *FFCacheFolderPath = nil;
static NSDateFormatter *FFCacheDateFormatter = nil;

#pragma mark - private vars and methods
@interface FFCacheManager ()
@property (nonatomic, strong, readonly) NSMutableDictionary *cacheDict;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) FFTimer *clearCacheArrayTimer;

+ (void)initStaticVars;

- (void)checkForFolderCreation;

- (void)setupClearCacheTimer;

- (void)resetCacheDict;

- (NSString *)managersCachePath;
- (NSString *)fullCachePathForFileWithUniqueName:(NSString *)name;

- (BOOL)isFileCachedWithUniqueName:(NSString *)uniqueName;

@end


@implementation FFCacheManager

+ (void)initialize {
    [super initialize];
    if (self == [FFCacheManager class]) {
        [self initStaticVars];
    }
}

+ (instancetype)defaultManager {
    static id DefaultManager = nil;
    static dispatch_once_t DefaultManagerToken;
    @synchronized(self) {
        dispatch_once(&DefaultManagerToken, ^{
            DefaultManager = [[self alloc] initWithName:FFDefaultCacheManagerName];
        });
    }
    return DefaultManager;
}

+ (void)initStaticVars {
    FFCacheFolderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    FFCacheDateFormatter = [[NSDateFormatter alloc] init];
    FFCacheDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    FFCacheDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    FFCacheDateFormatter.dateFormat = @"yyyyMMddHHmmss";
}

#pragma mark - Initiation and Deallocation
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        self.fileManager = [NSFileManager defaultManager];
        
        [self checkForFolderCreation];
        
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resetCacheDict)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
#endif
    }
    return self;
}

- (instancetype)init {
    return [self initWithName:FFDefaultCacheManagerName];
}

- (void)dealloc {
    [self.clearCacheArrayTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.cacheDict removeAllObjects];
}

#pragma mark - properties
- (void)setClearsMemoryCachePeriodically:(BOOL)clearsMemoryCachePeriodically {
    if (_clearsMemoryCachePeriodically != clearsMemoryCachePeriodically) {
        _clearsMemoryCachePeriodically = clearsMemoryCachePeriodically;
        if (clearsMemoryCachePeriodically) {
            [self setupClearCacheTimer];
        } else {
            [self.clearCacheArrayTimer invalidate];
            self.clearCacheArrayTimer = nil;
        }
    }
}

#pragma mark - helper methods
- (BOOL)isFileCachedWithUniqueName:(NSString *)uniqueName {
    return ([self.cacheDict objectForKey:uniqueName] != nil) ||
    [self.fileManager fileExistsAtPath:[self fullCachePathForFileWithUniqueName:uniqueName]];
}

- (void)setupClearCacheTimer {
    FFTimer *timer = [FFTimer timerWithTimeInterval:FFCacheManagerDefaultTimeout
                                             target:self selector:@selector(resetCacheDict)
                                           userInfo:nil repeats:YES];
    if ([timer respondsToSelector:@selector(setTolerance:)]) {
        timer.tolerance = FFCacheManagerDefaultTimeoutTolerance;
    }
    [[NSRunLoop mainRunLoop] addFFTimer:timer forMode:NSDefaultRunLoopMode];
    self.clearCacheArrayTimer = timer;
}

- (void)checkForFolderCreation {
    NSString *path = [self managersCachePath];
    if (![self.fileManager fileExistsAtPath:path]) {
        __autoreleasing NSError *error = nil;
        if (![self.fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSLog(@"Couldn't create managers cache directory (%@): %@", path, error);
        }
    }
    if (!self.cacheDict) {
        [self resetCacheDict];
    }
}

- (NSString *)managersCachePath {
    return [FFCacheFolderPath stringByAppendingPathComponent:self.name];
}

- (NSString *)fullCachePathForFileWithUniqueName:(NSString *)name {
    return [[self managersCachePath] stringByAppendingPathComponent:name];
}

#pragma mark - Cache handling
#pragma mark Caching files
- (void)cacheFileWithUniqueName:(NSString *)uniqueName
                           data:(NSData *)data
           identifyingAttribute:(NSString *)identifyingAttribute {
    [self.cacheDict setObject:data forKey:uniqueName];
    
    NSString *fullCachePath = [self fullCachePathForFileWithUniqueName:uniqueName];
    
    __autoreleasing NSError *error = nil;
    if (data) {
        [data writeToFile:fullCachePath options:NSDataWritingAtomic error:&error];
    } else if ([self.fileManager fileExistsAtPath:fullCachePath]) {
        [self.fileManager removeItemAtPath:fullCachePath error:&error];
    }
    if (error) {
        NSLog(@"Error while writing file to cache: %@", error);
    }
    if (identifyingAttribute) {
        if ([self.fileManager fileExistsAtPath:fullCachePath]) {
            const char *filePath = [fullCachePath fileSystemRepresentation];
            const char *attribute = [identifyingAttribute UTF8String];
            
            int result = setxattr(filePath, FFCacheIdentifyingAttributeName, attribute, strlen(attribute), 0, 0);
            if (result < 0) {
                NSLog(@"Failed to set identifying attribute of file!");
            }
        } else {
            NSLog(@"Couldn't add file attributes because file doesn't exist!");
        }
    }
}

- (void)cacheFileWithUniqueName:(NSString *)uniqueName data:(NSData *)data expiryDate:(NSDate *)expiryDate {
    NSString *identifyingAttribute = nil;
    if (expiryDate) {
        identifyingAttribute = [FFCacheDateFormatter stringFromDate:expiryDate];
    }
    return [self cacheFileWithUniqueName:uniqueName data:data identifyingAttribute:identifyingAttribute];
}

- (void)cacheFileWithUniqueName:(NSString *)uniqueName data:(NSData *)data {
    return [self cacheFileWithUniqueName:uniqueName data:data identifyingAttribute:nil];
}

#pragma mark Retrieving cached files
- (NSData *)cachedFileWithUniqueName:(NSString *)uniqueName
{
    if (![self isFileCachedWithUniqueName:uniqueName]) return nil;
    
//    if (![self isFileCurrentWithUniqueName:uniqueName type:type]) return nil; // Prevents return of outdated files
    
    NSData *cachedData = nil;
    cachedData = [self.cacheDict objectForKey:uniqueName];
    
    if (cachedData == nil) {
        __autoreleasing NSError *error = nil;
        cachedData = [NSData dataWithContentsOfFile:[self fullCachePathForFileWithUniqueName:uniqueName]
                                            options:NSDataReadingMappedIfSafe
                                              error:&error];
        if (error) {
            NSLog(@"Error while reading cached file: %@", error);
        }
    }
    
    return cachedData;
}

- (NSURL *)urlOfCachedFileWithUniqueName:(NSString *)uniqueName {
    if ([self isFileCachedWithUniqueName:uniqueName]) {
        return [NSURL fileURLWithPath:[self fullCachePathForFileWithUniqueName:uniqueName]];
    }
    return nil;
}

#pragma mark check for expiration
- (BOOL)isFileCurrentWithUniqueName:(NSString *)uniqueName
               identifyingAttribute:(NSString *)identifyingAttribute {
    BOOL isCurrent = YES;
    
    NSString *fullCachePath = [self fullCachePathForFileWithUniqueName:uniqueName];
    if ([self.fileManager fileExistsAtPath:fullCachePath]) {
        const char *filePath = [fullCachePath fileSystemRepresentation];
        ssize_t bufferLength = getxattr(filePath, FFCacheIdentifyingAttributeName, NULL, 0, 0, 0);
        
        if (bufferLength < 0) {
            NSLog(@"Failed to get identifying attribute's buffer length!");
        } else {
            char *buffer = malloc(bufferLength);
            ssize_t result = getxattr(filePath, FFCacheIdentifyingAttributeName, buffer, 255, 0, 0);
            
            if (result < 0) {
                NSLog(@"Failed to get identifying attribute of cached file!");
            } else {
                NSString *attribute = [[NSString alloc] initWithBytes:buffer length:bufferLength encoding:NSUTF8StringEncoding];
                if (attribute) {
                    if (identifyingAttribute) {
                        isCurrent = [identifyingAttribute isEqualToString:attribute];
                    } else {
                        NSDate *expiryDate = [FFCacheDateFormatter dateFromString:attribute];
                        if (expiryDate) {
                            isCurrent = [[expiryDate laterDate:[NSDate date]] isEqualToDate:expiryDate];
                        }
                    }
                }
            }
            free(buffer);
        }
    } else {
        isCurrent = NO;
    }
    
    return isCurrent;
}

- (BOOL)isFileCurrentWithUniqueName:(NSString *)uniqueName {
    return [self isFileCurrentWithUniqueName:uniqueName identifyingAttribute:nil];
}

#pragma mark deleting cached files
- (void)deleteFileFromCacheWithUniqueName:(NSString *)uniqueName {
    [self.cacheDict removeObjectForKey:uniqueName];
    
    __autoreleasing NSError *error = nil;
    [self.fileManager removeItemAtPath:[self fullCachePathForFileWithUniqueName:uniqueName] error:&error];
    if (error) {
        NSLog(@"Error while removing file from cache: %@", error);
    }
}

#pragma mark resetting cache
- (void)resetCacheDict {
    [self.cacheDict removeAllObjects];
    _cacheDict = [NSMutableDictionary dictionary];
}

- (void)clearMemoryCache {
    [self resetCacheDict];
}

- (void)clearCache {
    [self resetCacheDict];

    if ([self.fileManager fileExistsAtPath:[self managersCachePath]]) {
        __autoreleasing NSError *error = nil;
        if (![self.fileManager removeItemAtPath:[self managersCachePath] error:&error]) {
            NSLog(@"Clear cache error: %@", error);
        }
    }
    
    [self checkForFolderCreation];
}

@end
