//
//  ZPersion.m
//  ZMethodSwizzleDemo
//
//  Created by zhangjixin7 on 2021/6/4.
//

#import "ZPersion.h"

@implementation ZPersion

- (void)showYourSelf {
    printf("I am %s, and i'm %ld year old\n", self.name.UTF8String, (long)self.age);
}

- (void)run {
    printf("run\n");
}

@end
