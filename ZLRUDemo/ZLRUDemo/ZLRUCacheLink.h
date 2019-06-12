//
//  ZLRUCacheLink.h
//  ZLRUDemo
//
//  Created by zjixin on 2019/6/11.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLRUCacheLink : NSObject

@property (nonatomic, assign) NSInteger maxCapacity;
@property (nonatomic, assign) NSUInteger countLimit;

@property (nonatomic, assign) BOOL releaseOnMainThread;
@property (nonatomic, assign) BOOL releaseAsynchronously;

- (BOOL)containsObjectForKey:(id)key;

- (id)objectForKey:(id)key;

- (void)setObject:(id)object forKey:(id)key;

- (void)removeObjectForKey:(id)key;

- (void)trimToCount:(NSUInteger)count;

- (NSArray *)cacheList;

@end

NS_ASSUME_NONNULL_END
