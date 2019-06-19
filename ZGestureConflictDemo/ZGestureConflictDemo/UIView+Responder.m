//
//  UIView+Responder.m
//  ZGestureConflictDemo
//
//  Created by zjixin on 2019/6/19.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "UIView+Responder.h"
#import <objc/runtime.h>

#define NSLog(FORMAT, ...)  fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


@implementation UIView (Responder)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];

        Method pointMethodOld = class_getInstanceMethod(class, @selector(pointInside:withEvent:));
        Method pointMethod = class_getInstanceMethod(class, @selector(l_pointInside:withEvent:));
        BOOL pointAdd = class_addMethod(class, @selector(pointInside:withEvent:), method_getImplementation(pointMethod), method_getTypeEncoding(pointMethod));
        if (pointAdd) {
            class_replaceMethod(class, @selector(l_pointInside:withEvent:), method_getImplementation(pointMethodOld), method_getTypeEncoding(pointMethodOld));
        }else{
            method_exchangeImplementations(pointMethodOld, pointMethod);
        }


        Method hitMethodOld = class_getInstanceMethod(class, @selector(hitTest:withEvent:));
        Method hitMethod = class_getInstanceMethod(class, @selector(l_hitTest:withEvent:));
        BOOL hitAdd = class_addMethod(class, @selector(hitTest:withEvent:), method_getImplementation(hitMethod), method_getTypeEncoding(hitMethod));
        if (hitAdd) {
            class_replaceMethod(class, @selector(l_hitTest:withEvent:), method_getImplementation(hitMethodOld), method_getTypeEncoding(hitMethodOld));
        }else{
            method_exchangeImplementations(hitMethodOld, hitMethod);
        }
        
        
        
    });
}

// 检测坐标点是否落在当前视图范围内
- (BOOL)l_pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"当前视图 pointInside ======== %@ : %ld",self.class,self.tag);
    BOOL pointInside = [self l_pointInside:point withEvent:event];
    if (pointInside) {
        NSLog(@"3 --- \t 点击  在 ====== %@ : %ld ",self.class,self.tag);
    }else{
        NSLog(@"3 --- \t 点击不在 ====== %@ : %ld ",self.class,self.tag);
    }
    
    return pointInside;
}

//查找响应处理事件的最终视图
- (UIView *)l_hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    UIView *responserView = [self l_hitTest:point withEvent:event];
//    if (responserView) {
//        NSLog(@"2 --- \t 点击 响应 %@ : %ld -- 响应视图 %@ : %ld ", self.class, self.tag,responserView.class, (long)responserView.tag);
//    }else{
//        NSLog(@"2 --- \t 点击不响应 %@ : %ld -- 响应视图 查找不到", self.class, self.tag);
//    }
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subView in [self.subviews reverseObjectEnumerator]) {
            //转换坐标到子视图
            CGPoint convertedPoint = [subView convertPoint:point fromView:self];
            UIView *hitTestView = [subView hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        NSLog(@"2 --- \t 点击命中 %@", self.class);
        return self;
    }
    
    return nil;
}


- (void)touchesBegan: (NSSet<UITouch *> *)touches withEvent: (UIEvent *)event {
    //    [super touchesBegan:touches withEvent:event];
    NSLog(@"1 --- \t touch begin  = %@", self.class);
    UIResponder *next = [self nextResponder];
    while (next) {
        NSLog(@"1 --- \t next reponse = %@", next.class);
        next = [next nextResponder];
    }
}

- (void)touchesEnded: (NSSet<UITouch *> *)touches withEvent: (UIEvent *)event {
    NSLog(@"1 --- \t touch ended  = %@", self.class);

}

@end
