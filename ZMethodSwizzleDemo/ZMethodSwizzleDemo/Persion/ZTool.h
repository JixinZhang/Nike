//
//  ZTool.h
//  ZMethodSwizzleDemo
//
//  Created by zhangjixin7 on 2021/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTool : NSObject

+ (void)ztool_swizzleMethodInClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
