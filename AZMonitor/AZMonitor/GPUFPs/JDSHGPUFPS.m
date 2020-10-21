//
//  JDSHGPUFPS.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2020/9/21.
//  Copyright © 2020 app.jixin. All rights reserved.
//

#import "JDSHGPUFPS.h"
#import "FPSAsyController.h"

@interface JDSHGPUFPS ()<FPSAsyCOntrollerDelegate>

@property (nonatomic, assign) int totalFPS;
@property (nonatomic, assign) int maxFPS;
@property (nonatomic, assign) int minFPS;
@property (nonatomic, assign) int FPSRecordCount;
@property (nonatomic, copy)   NSString *groupId;

@end

@implementation JDSHGPUFPS

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static JDSHGPUFPS *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[JDSHGPUFPS alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)initFPS
{
    _maxFPS = 0;
    _minFPS = 60;
    _totalFPS = 0;
    _FPSRecordCount = 0;
}

- (void)startGPUFPSMonitor:(UIViewController *)VC
{
    if ([VC isKindOfClass:[UINavigationController class]]) {
        return;
    }
    if (!VC || ![VC isKindOfClass:[UIViewController class]] ||
        (_groupId && _groupId.length)) return;
    NSString *groupId = [NSString stringWithFormat:@"%p", VC];
    if (!(groupId && groupId.length)) return;
    _groupId = groupId;
    [self initFPS];
    [FPSAsyController sharedInstance].preferredFramesPerSecond = 60;
    [FPSAsyController sharedInstance].FPSDelegate = self;
    [VC.view addSubview:[FPSAsyController sharedInstance].view];
//    [[FPSAsyController sharedInstance] openFPSMonitor];
}

- (void)stopGPUFPSMonitor:(UIViewController *)VC
{
    if (!VC || ![VC isKindOfClass:[UIViewController class]] || !(_groupId && _groupId.length)) return;
    NSString *groupId = [NSString stringWithFormat:@"%p", VC];
    if (![_groupId isEqualToString:groupId]) return;
//    [[FPSAsyController sharedInstance] closeFPSMonitor];
    [[FPSAsyController sharedInstance].view removeFromSuperview];
    _groupId = nil;
}

- (NSString *)getFpsCount
{
//    return @"";//V8.4.4上线，暂不支持gpu统计
    //该方法直接调用时，请放入[JDSHRunLoopCommitManager globalQueue]中使用
    int avg = _FPSRecordCount == 0 ? 0 : _totalFPS / _FPSRecordCount;
    NSDictionary *fpsDic = @{
        @"avg":[NSString stringWithFormat:@"%d",avg],
        @"max":[NSString stringWithFormat:@"%d",_maxFPS],
        @"min":[NSString stringWithFormat:@"%d",_minFPS]
    };
    NSData *fpsDicData = [NSJSONSerialization dataWithJSONObject:fpsDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *fpsStr = [[NSString alloc] initWithData:fpsDicData encoding:NSUTF8StringEncoding];
    [self initFPS];
    return fpsStr?:@"";
}

- (void)FPSCountFinish:(int)fps {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!self) return;
        if (fps<=10) return;
        self.maxFPS = MAX(self.maxFPS, fps);
        self.minFPS = MIN(self.minFPS, fps);
        self.totalFPS += fps;
        self.FPSRecordCount ++;
//        printf("gpuFPS = %d\n", fps);
    });
}

@end
