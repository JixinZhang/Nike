//
//  ViewController.m
//  ZMethodSwizzleDemo
//
//  Created by zhangjixin7 on 2021/6/4.
//

#import "ViewController.h"
#import "ZPersion.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZPersion *person = [ZPersion new];
    person.age = 20;
    person.name = @"pige";
    [person showYourSelf];
    
    [person happy];
    
    [person run];
}


@end
