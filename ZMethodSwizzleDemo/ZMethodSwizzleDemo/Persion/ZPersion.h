//
//  ZPersion.h
//  ZMethodSwizzleDemo
//
//  Created by zhangjixin7 on 2021/6/4.
//

#import "ZHuman.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZPersion : ZHuman

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy)   NSString *name;

- (void)showYourSelf;

- (void)run;

@end

NS_ASSUME_NONNULL_END
