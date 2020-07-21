//
//  JDMonitor.h
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/3.
//  Copyright © 2019 app.jixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMonitor : NSObject

+ (instancetype)sharedMonitor;

/// 开启监控
+ (void)enableMonitor;

/// 停止监控
+ (void)disableMonitor;

/// 开始监控
/// @param viewController 监控的ViewController
- (void)startMonitorForViewController:(UIViewController *)viewController;

/// 暂停对- (void)startMonitorForViewController:(UIViewController *)viewController 中的ViewController监控
- (void)pauseMonitor;

@end

NS_ASSUME_NONNULL_END
