//
//  AppDelegate.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/3.
//  Copyright © 2019 app.jixin. All rights reserved.
//

// 


#import "AppDelegate.h"
#import "JDMonitor.h"
#import "JDSHPMUIStuckMonitor.h"
#import "FPSAsyController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [JDSHPMUIStuckMonitor enableMonitor];
//    [JDMonitor enableMonitor];
//    [[FPSAsyController sharedInstance] openFPSMonitor];

    self.bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"app.jixin.background.test" expirationHandler:^{
        [self.myTimer invalidate];
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskId];
        self.bgTaskId = UIBackgroundTaskInvalid;
        NSLog(@"endBackgroundTask");
    }];
    NSLog(@"beginBackgroundTaskWithName %lu", (unsigned long)self.bgTaskId);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([self isMultitaskingSupported] == NO) {
        return;
    }
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMthod:) userInfo:nil repeats:YES];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (self.bgTaskId != UIBackgroundTaskInvalid) {
//        [self endBackgroundTast];
        [self.myTimer invalidate];
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskId];
        self.bgTaskId = UIBackgroundTaskInvalid;
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"Background app is killed");
}

- (BOOL)isMultitaskingSupported {
    BOOL result = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    return result;
}

NSInteger count = 0;

- (void)timerMthod:(NSTimer *)sender {
    NSTimeInterval backgroundTimeRemaining = [UIApplication sharedApplication].backgroundTimeRemaining;
    if (backgroundTimeRemaining == DBL_MAX) {
        count++;
        NSLog(@"Background Time goes = %ld", (long)count);
    } else {
        NSLog(@"Background Time Remaining = %.0f Seconds", backgroundTimeRemaining);
        if (backgroundTimeRemaining <= 25) {
//            [self.myTimer invalidate];
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskId];
            self.bgTaskId = UIBackgroundTaskInvalid;
            NSLog(@"BackgroundTask complate");
        }
    }
}

@end
