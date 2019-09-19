//
//  Persion.m
//  ZRuntimeDemo
//
//  Created by zjixin on 2019/6/5.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "Persion.h"
#import <objc/runtime.h>
#import "Man.h"

/*
 *  runtime的消息转发的三次机会。动态方法解析，备用接收者和完整消息转发。
 
 1. 动态方法解析：
    * 首先，Objective-C运行时会调用 +resolveInstanceMethod:或者 +resolveClassMethod:，让你有机会提供一个函数实现。如果你添加了函数并返回YES， 那运行时系统就会重新启动一次消息发送的过程；
    * 如果resolve方法返回 NO ，运行时就会移到下一步：forwardingTargetForSelector（备用接收者）。
 2. 备用接收者：
    * 在forwardingTargetForSelector中，将消息转发给备用接收者去执行；
    * 返回nil 则启动完整消息转发。
 
 3. 完整消息转发：
    * 步骤一未动态解析未实现的方法 且 步骤二未转发给备用接收者执行；
    * runtime会发送methodSignatureForSelector:消息获得函数的参数和返回值类型；
    * 如果methodSignatureForSelector返回nil，则程序发送-doesNotRecognizeSelector:消息，程序crash；
    * 如果返回一个函数签名，runtime会创建一个NSInvocation对象并发送`-forwardInvocation:`消息给目标对象
 
 */


@implementation Persion

- (instancetype)init {
    self = [super init];
    if (self) {
        //执行foo函数
        [self performSelector:@selector(foo:) withObject:@"object" afterDelay:<#(NSTimeInterval)#> inModes:<#(nonnull NSArray<NSRunLoopMode> *)#>];
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return YES;
    if (sel == @selector(foo:)) {
        //如果执行foo函数, 就动态解析，置顶新的IMP
//        class_addMethod([self class], sel, (IMP)fooMethod, "v@:");
//        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
    if (aSelector == @selector(foo:)) {
        return [Man new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"foo:"]) {
        //签名，进入forwardInvocation
        //签名参数 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    Man *p = [Man new];
    
    if ([p respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:p];
    } else {
        [self doesNotRecognizeSelector:sel];
    }
}

@end

