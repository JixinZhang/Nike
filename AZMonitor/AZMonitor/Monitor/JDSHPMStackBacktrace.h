//
//  JDSHPMStackBacktrace.h
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/12.
//  Copyright © 2019 app.jixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDSHPMStackBacktrace : NSObject

+ (NSString *)jdsh_stackBacktraceOfAllThread;
+ (NSString *)jdsh_stackBacktraceOfCurrentThread;
+ (NSString *)jdsh_stackBacktraceOfMainThread;
+ (NSString *)jdsh_stackBacktraceOfNSThread:(NSThread *)thread;

@end

NS_ASSUME_NONNULL_END
