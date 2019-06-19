//
//  ViewController.m
//  ZGestureConflictDemo
//
//  Created by zjixin on 2019/5/17.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AView.h"
#import "BView.h"
#import "CView.h"
#import "DView.h"

#define NSLog(FORMAT, ...)  fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

/**
 https://www.jianshu.com/p/4155c9ffe1a8
 */
@interface ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.view.tag = 20;
    
    AView *viewA = [[AView alloc] initWithFrame:self.view.bounds];
    viewA.backgroundColor = [UIColor redColor];
    [self.view addSubview:viewA];
    viewA.tag = 21;
    
    BView *viewB = [[BView alloc] initWithFrame:CGRectMake(30, 100, 200, 200)];
    viewB.backgroundColor = [UIColor blueColor];
    [viewA addSubview:viewB];
    viewB.tag = 211;
    
    CView *viewC = [[CView alloc] initWithFrame:CGRectMake(-20, 30, 100, 100)];
    viewC.backgroundColor = [UIColor orangeColor];
    [viewB addSubview:viewC];
    viewC.tag = 2111;
    
    DView *viewD = [[DView alloc] initWithFrame:CGRectMake(30, 400, 200, 200)];
    viewD.backgroundColor = [UIColor grayColor];
    [viewA addSubview:viewD];
    viewD.tag = 212;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aviewAction)];
    [viewA addGestureRecognizer:tap];
}

- (void)aviewAction {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
