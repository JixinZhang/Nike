//
//  JDSHPMUIStuckMonitor.h
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/5.
//  Copyright © 2019 app.jixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 主线程卡顿监控服务
@interface JDSHPMUIStuckMonitor : NSObject

/// 获取当前主线程卡顿监控开关的开启状态，
///
/// 只能通过'+ (void)enableMonitor'和'+ (void)disableMonitor'改变状态
@property (nonatomic, assign, readonly) BOOL monitorEnable;

+ (instancetype)sharedMonitor;

/// 开启监控
+ (void)enableMonitor;

/// 停止监控
/// 当前正在监控某个VC的主线程卡顿，如果停止监控，则当前监控会立刻停止，已记录的数据不会清空
+ (void)disableMonitor;

/// 暂存的当前vc的卡顿信息
/// key                  value      value含义及说明
///
/// lstuckCount     string      疑似卡顿的数量
/// cstuckCount    string      严重卡顿的数量
/// lstuckInfo         string      疑似卡顿堆栈信息    json数组
/// cstuckInfo        string      严重卡顿堆栈信息    json数组
+ (NSDictionary *)getStuckInfo;

/// 开始监控
/// @param viewController 监控的ViewController，内部不会对VC强引用或者如引用
- (void)startMonitorForViewController:(UIViewController *)viewController;

/// 结束对- (void)startMonitorForViewController:(UIViewController *)viewController 中的ViewController监控
- (void)finishMonitor;

@end

NS_ASSUME_NONNULL_END
