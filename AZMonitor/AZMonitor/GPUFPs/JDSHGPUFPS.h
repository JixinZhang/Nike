//
//  JDSHGPUFPS.h
//  AZMonitor
//
//  Created by zhangjixin7 on 2020/9/21.
//  Copyright © 2020 app.jixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDSHGPUFPS : NSObject

+ (instancetype)sharedInstance;
- (void)startGPUFPSMonitor:(UIViewController *)VC;
- (void)stopGPUFPSMonitor:(UIViewController *)VC;
- (NSString *)getFpsCount;

@end

NS_ASSUME_NONNULL_END
