//
//  ZAlgoLeakDemoViewController.m
//  ZAlgoDemo
//
//  Created by zhangjixin7 on 2020/7/21.
//  Copyright © 2020 zjixin. All rights reserved.
//

#import "ZAlgoLeakDemoViewController.h"

@implementation ZAlgoLeakDemoViewController

- (void)dealloc {
    NSLog(@"ZAlgoLeakDemoViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(tiktok) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)tiktok {
    
}

@end
