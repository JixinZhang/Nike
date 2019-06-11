//
//  HybridJsManager+View.h
//  GoldHybridFramework
//
//  Created by Micker on 16/9/7.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import "HybridJsManager.h"

@interface HybridJsManager (View)

/**
 *  弹出提示框
 *
 *  @parames
 *  @param  callbackId  回调值
 *  @param  message     内容
 *  @param  title       标题
 *  @param  cancel      取消
 *  @param  okButtonName 确定
 *
 *  @return  currentVersion
 */
- (void) registerJs_dialogs_alert;

@end
