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

@interface ViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UISwitch *monitorSwitch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.button];
    [self.view addSubview:self.monitorSwitch];
    
    BOOL enable = [[JDSHPMUIStuckMonitor sharedMonitor] monitorEnable];
    [self.monitorSwitch setOn:enable];
    
    double time = CFAbsoluteTimeGetCurrent();
    NSLog(@"time = %f", time);
    
//    dispatch_semaphore_t lock = dispatch_semaphore_create(1);
//    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
//    NSLog(@"lock unlock");
////    dispatch_semaphore_signal(lock);
//    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
//    NSLog(@"lock unlock2");

    
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
    DemoViewController *demoVC = [[DemoViewController alloc] init];
    demoVC.title = @"0";
    [self.navigationController pushViewController:demoVC animated:YES];
}

- (void)monitorSwitchChanged:(UISwitch *)monitorSwitch {
    if (monitorSwitch.on) {
        [JDSHPMUIStuckMonitor enableMonitor];
    } else {
        [JDSHPMUIStuckMonitor disableMonitor];
    }
}

@end
