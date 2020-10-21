//
//  AppDelegate.h
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/3.
//  Copyright © 2019 app.jixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskId;
@property (nonatomic, strong) NSTimer *myTimer;

@end

