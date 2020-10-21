//
//  ViewController.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/3.
//  Copyright © 2019 app.jixin. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewController.h"
#import "JDMonitor.h"
#import "JDSHPMUIStuckMonitor.h"
#import "JDSHPMStackBacktrace.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate> {
    NSInteger _count1;
    NSInteger _count2;
}
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UISwitch *monitorSwitch;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"root VC";
    [self.view addSubview:self.button];
    [self.view addSubview:self.monitorSwitch];
    
    BOOL enable = [[JDSHPMUIStuckMonitor sharedMonitor] monitorEnable];
    [self.monitorSwitch setOn:enable];
    
    double time = CFAbsoluteTimeGetCurrent();
    NSLog(@"time = %f", time);
    
//    _count1 = 10000;
//    _count2 = 10000;
//    __weak typeof(self)weakSelf = self;
//    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 4;
//    
//    // 2.创建操作
//    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
//        [weakSelf getMainThread];
//    }];
//    
//    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
//        [weakSelf getAllThreadButMain];
//    }];
//    [queue addOperation:op1];
//    [queue addOperation:op2];
    
    
    
    UIImageView *blurImgv = [[UIImageView alloc]initWithFrame:CGRectMake(50, 500, 150, 150)];
    blurImgv.image = [UIImage imageNamed:@"redio"];
    [self.view addSubview:blurImgv];
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    view.frame = blurImgv.frame;
    [self.view addSubview:view];
    
//    [self playAudio];
}

- (void)playAudio {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"梁祝" ofType:@"mp3"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    if (fileData) {
        self.player = [[AVAudioPlayer alloc] initWithData:fileData error:nil];
        self.player.delegate = self;
        [self.player prepareToPlay];
        
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        [self.player play];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(240 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.player stop];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.player play];
//            });
        });
    }
}

- (void)getMainThread {
    while (_count1) {
        _count1--;
        printf("Main Index = %ld -->%s", (long)_count1, [JDSHPMStackBacktrace jdsh_stackBacktraceOfMainThread].UTF8String);
    }
}

- (void)getAllThreadButMain {
    while (_count2) {
        _count2--;
        printf("All Index = %ld -->%s", (long)_count2, [JDSHPMStackBacktrace jdsh_stackBacktraceOfAllThread].UTF8String);
    }
}



- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 300) / 2.0, 150, 300, 50)];
        _button.backgroundColor = [UIColor redColor];
        _button.tag = 1000;
        [_button setTitle:@"tableView" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UISwitch *)monitorSwitch {
    if (!_monitorSwitch) {
        _monitorSwitch = [[UISwitch alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 300) / 2.0, 220, 44, 44)];
        [_monitorSwitch addTarget:self action:@selector(monitorSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        _monitorSwitch.userInteractionEnabled = YES;
    }
    return _monitorSwitch;
}

- (void)buttonAction:(UIButton *)button {
    Class cls1 = NSClassFromString(@"ThreeDViewController");
    Class cls2 = NSClassFromString(@"DemoViewController");
    UIViewController *demoVC = [[cls1 alloc] init];
    demoVC.title = @"0";
    [self.navigationController pushViewController:demoVC animated:YES];
}

- (void)monitorSwitchChanged:(UISwitch *)monitorSwitch {
    if (monitorSwitch.on) {
        [JDSHPMUIStuckMonitor enableMonitor];
    } else {
        [JDSHPMUIStuckMonitor disableMonitor];
    }
    
    func1();
}

void func1() {
    printf("func1");
    printf("%s", [JDSHPMStackBacktrace jdsh_stackBacktraceOfMainThread].UTF8String);
    func2();
}

void func2() {
    printf("func2");
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
}

@end
