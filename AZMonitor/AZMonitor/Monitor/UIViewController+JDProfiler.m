//
//  UIViewController+JDProfiler.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/4.
//  Copyright © 2019 app.jixin. All rights reserved.
//

#import "UIViewController+JDProfiler.h"
#import <objc/runtime.h>
#import "JDMonitor.h"
#import "JDSHPMUIStuckMonitor.h"

@implementation UIViewController (JDProfiler)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [self jd_swizzleMethodInClass:class originalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(jd_swizzleViewDidAppear:)];
        [self jd_swizzleMethodInClass:class originalSelector:@selector(viewWillDisappear:) swizzledSelector:@selector(jd_swizzleViewWillDisappear:)];
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

- (void)jd_swizzleViewDidAppear:(BOOL)animated {
    [[JDSHPMUIStuckMonitor sharedMonitor] startMonitorForViewController:self];
    [self jd_swizzleViewDidAppear:animated];
}

- (void)jd_swizzleViewWillDisappear:(BOOL)animated {
    [self jd_swizzleViewWillDisappear:animated];
    [[JDSHPMUIStuckMonitor sharedMonitor] finishMonitor];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *stucInfo = [JDSHPMUIStuckMonitor getStuckInfo];
        NSLog(@"jd_swizzleViewWillDisappear %@\n\n", stucInfo);
    });
}

@end
