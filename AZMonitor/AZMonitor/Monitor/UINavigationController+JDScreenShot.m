//
//  UINavigationController+JDScreenShot.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2020/8/18.
//  Copyright © 2020 app.jixin. All rights reserved.
//

#import "UINavigationController+JDScreenShot.h"
#import <objc/runtime.h>

@implementation UINavigationController (JDScreenShot)

- (NSMutableDictionary *)screenShotDict {
    NSMutableDictionary *_screenShotDict = objc_getAssociatedObject(self, @selector(screenShotDict));
    if (!_screenShotDict) {
        _screenShotDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(screenShotDict), _screenShotDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _screenShotDict;
}

- (void)setScreenShotDict:(NSMutableDictionary *)screenShotDict {
    objc_setAssociatedObject(self, @selector(screenShotDict), screenShotDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [self jd_swizzleMethodInClass:class originalSelector:@selector(pushViewController:animated:) swizzledSelector:@selector(jd_swizzlePushViewController:animated:)];
        [self jd_swizzleMethodInClass:class originalSelector:@selector(popViewControllerAnimated:) swizzledSelector:@selector(jd_swizzlePopViewControllerAnimated:)];
    });
}

+ (void)jd_swizzleMethodInClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL methodAdded = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (methodAdded) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)jd_swizzlePushViewController:(UIViewController *)viewController animated:(BOOL)animated  {
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    
    UIView *tempView = [self.view.window snapshotViewAfterScreenUpdates:YES];
//    UIImage *tempView = [self captureWithView:self.view.window size:[UIScreen mainScreen].bounds.size];
    
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    
    printf("duration = %.0f\n", (end - start) * 1000);
    
//    tempView.userInteractionEnabled = NO;
//    UIViewController *lastVC = self.viewControllers.lastObject;
//    [lastVC.view addSubview:tempView];
    [self.screenShotDict setValue:tempView forKey:[NSString stringWithFormat:@"%p", self]];
    
    [self jd_swizzlePushViewController:viewController animated:animated];
}

- (void)jd_swizzlePopViewControllerAnimated:(BOOL)animated {
    [self jd_swizzlePopViewControllerAnimated:animated];
}

- (UIImage *)captureWithView:(UIView *)cView size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, cView.opaque, 0.0);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.f && [cView isDescendantOfView:[UIApplication sharedApplication].keyWindow])
    {
        [cView drawViewHierarchyInRect:cView.bounds afterScreenUpdates:NO];
    }
    else
    {
        [cView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
   
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
