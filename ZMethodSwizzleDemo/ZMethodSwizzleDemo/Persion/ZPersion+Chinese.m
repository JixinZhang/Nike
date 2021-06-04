//
//  ZPersion+Chinese.m
//  ZMethodSwizzleDemo
//
//  Created by zhangjixin7 on 2021/6/4.
//

#import "ZPersion+Chinese.h"
#import "ZTool.h"
#import <objc/runtime.h>

@implementation ZPersion (Chinese)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        [ZTool ztool_swizzleMethodInClass:cls
                         originalSelector:@selector(showYourSelf)
                         swizzledSelector:@selector(chinese_showYourSelf)];
        
        [ZTool ztool_swizzleMethodInClass:cls
                         originalSelector:@selector(happy)
                         swizzledSelector:@selector(chinese_happy)];
    });
}

- (void)chinese_showYourSelf {
    printf("您好\n");
    [self chinese_showYourSelf];
}

- (void)chinese_happy {
    printf("chinese_happy\n");
    [self chinese_happy];
}

- (void)run {
    printf("sub run\n");
    
    unsigned int methodCount;
    Method *methodList = class_copyMethodList([self class], &methodCount);
    IMP lastImp = NULL;
    SEL lastSel = NULL;
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:methodCount];
    
    for (NSInteger i = 0; i < methodCount; i++) {
        Method method = methodList[i];
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method))
                                        encoding:NSUTF8StringEncoding];
        
        [temp setValue:@(0) forKey:methodName];
        
        if ([@"run" isEqualToString:methodName]) {
            lastImp = method_getImplementation(method);
            lastSel = method_getName(method);
        }
    }
    
    void (*func)(id, SEL) = (void *)lastImp;
    func(self, lastSel);
    free(methodList);
}

@end
