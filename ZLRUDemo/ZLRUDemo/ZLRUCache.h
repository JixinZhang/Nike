//
//  ZLRUCache.h
//  ZLRUDemo
//
//  Created by zjixin on 2019/6/11.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 用数组实现LRU(least recently used)
 */
@interface ZLRUCache : NSObject

/**
 maxCapacity default is 5, 最小值为1
 */
@property (nonatomic, assign) NSInteger maxCapacity;

+ (instancetype)sharedCache;

- (void)addWithModel:(NSString *)model;

- (void)removeWithModel:(NSString *)model;

- (BOOL)removeAllModels;

- (NSArray<NSString *> *)cacheList;

@end

NS_ASSUME_NONNULL_END
