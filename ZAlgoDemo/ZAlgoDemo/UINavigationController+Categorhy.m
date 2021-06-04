//
//  UINavigationController+Categorhy.m
//  ZAlgoDemo
//
//  Created by zhangjixin7 on 2021/1/12.
//  Copyright © 2021 zjixin. All rights reserved.
//

#import "UINavigationController+Categorhy.h"
#import <objc/runtime.h>

@implementation UINavigationController (Categorhy)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        [self jd_swizzleMethodInClass:class originalSelector:@selector(setViewControllers:) swizzledSelector:@selector(jd_swizzleSetViewControllers:)];
//        [self jd_swizzleMethodInClass:class originalSelector:@selector(setViewControllers:animated:) swizzledSelector:@selector(jd_swizzleSetViewControllers:animated:)];
//
//    });
//}
//
//+ (void)jd_swizzleMethodInClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
//    
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//    
//    BOOL methodAdded = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    if (methodAdded) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//- (void)jd_swizzleSetViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
//    [self jd_swizzleSetViewControllers:viewControllers];
//    NSLog(@"%@", viewControllers);
//}
//
//- (void)jd_swizzleSetViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
//    [self jd_swizzleSetViewControllers:viewControllers animated:animated];
//    NSLog(@"%@", viewControllers);
//}

@end
