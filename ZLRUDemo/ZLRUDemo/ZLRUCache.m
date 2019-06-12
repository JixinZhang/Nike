//
//  ZLRUCache.m
//  ZLRUDemo
//
//  Created by zjixin on 2019/6/11.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZLRUCache.h"

@interface ZLRUCache ()

@property (nonatomic, strong) NSMutableArray<NSString *> *list;
@end

@implementation ZLRUCache

+ (instancetype)sharedCache {
    static ZLRUCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[ZLRUCache alloc] init];
    });
    return cache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxCapacity = 5;
        self.list = [NSMutableArray arrayWithCapacity:self.maxCapacity];
    }
    return self;
}

- (void)setMaxCapacity:(NSInteger)maxCapacity {
    if (maxCapacity <= 1) {
        maxCapacity = 1;
    }
    _maxCapacity = maxCapacity;
}

- (void)addWithModel:(NSString *)model {
    if (model == nil) {
        return;
    }
    
    if (!model.length) {
        return;
    }
    
    //如果加入的数据包含在当前列表中，则将其放入第一个位置
    if ([self.list containsObject:model]) {
        [self.list removeObject:model];
        [self.list insertObject:model atIndex:0];
        return;
    }
    
    //如果加入的数据超出了maxCapacity, 则先将超出的部分移除，然后再将加入的数据放到第一个位置
    if (self.list.count >= self.maxCapacity) {
        NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:self.maxCapacity];
        for (NSInteger index = 0; index < self.maxCapacity - 1; index++) {
            [tempList addObject:self.list[index]];
        }
        self.list = [NSMutableArray arrayWithArray:[tempList copy]];
    }
    [self.list insertObject:model atIndex:0];
}

- (void)removeWithModel:(NSString *)model {
    if (model != nil) {
        return;
    }
    
    if (!model.length) {
        return;
    }
    [self.list removeObject:model];
}

- (BOOL)removeAllModels {
    [self.list removeAllObjects];
    return YES;
}

- (NSArray<NSString *> *)cacheList {
    return [self.list copy];
}

@end
