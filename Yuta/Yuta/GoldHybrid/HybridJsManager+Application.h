//
//  HybridJsManager+Application.h
//  GoldHybridFramework
//
//  Created by Micker on 16/9/7.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import "HybridJsManager.h"

@interface HybridJsManager (Application)

/**
 *  检查用户版本号的方法
 *
 *  @parames
 *  @param  callbackId 回调值
 *
 *  @return  currentVersion  当前版本号
 */
- (void) registerJs_getCurrentVersion;

/**
 *  获取设备属性
 *
 *  @parames
 *  @param  callbackId 回调值
 *
 *  @return  currentVersion  当前版本号
 */
- (void) registerJs_properties;

/**
 *  调取跳转功能
 *
 *  @param url     跳转的链接url
 */
- (void) registerJs_openURL;
@end
