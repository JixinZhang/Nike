//
//  FPSAsyController.h
//  AZMonitor
//
//  Created by zhangjixin7 on 2020/9/21.
//  Copyright © 2020 app.jixin. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FPSAsyCOntrollerDelegate <NSObject>

- (void)FPSCountFinish:(int)fps;

@end

@interface FPSAsyController : GLKViewController

@property (nonatomic, weak) id<FPSAsyCOntrollerDelegate> FPSDelegate;

+ (instancetype)sharedInstance;

- (void)openFPSMonitor;

- (void)closeFPSMonitor;

@end

NS_ASSUME_NONNULL_END
