//
//  ZPersion+British.m
//  ZMethodSwizzleDemo
//
//  Created by zhangjixin7 on 2021/6/4.
//

#import "ZPersion+British.h"
#import "ZTool.h"

@implementation ZPersion (British)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        [ZTool ztool_swizzleMethodInClass:cls
                         originalSelector:@selector(showYourSelf)
                         swizzledSelector:@selector(british_showYourSelf)];
    });
}

- (void)british_showYourSelf {
    printf("Hi, there\n");
    [self british_showYourSelf];
}

@end
