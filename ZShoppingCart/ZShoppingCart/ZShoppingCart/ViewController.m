//
//  ViewController.m
//  ZShoppingCart
//
//  Created by AlexZhang on 22/11/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import "ViewController.h"
#import "ShoppingCartCollectionViewController.h"
#import "ShoppingCartTableViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *tableButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.button];
    [self.view addSubview:self.tableButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 300) / 2.0, 150, 300, 50)];
        _button.backgroundColor = [UIColor redColor];
        _button.tag = 1000;
        [_button setTitle:@"ShoppingCart CollectionView" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIButton *)tableButton {
    if (!_tableButton) {
        _tableButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 300) / 2.0, 220, 300, 50)];
        _tableButton.backgroundColor = [UIColor redColor];
        _tableButton.tag = 1001;
        [_tableButton setTitle:@"ShoppingCart TableView" forState:UIControlStateNormal];
        [_tableButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableButton;
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 1000) {
        ShoppingCartCollectionViewController *shopping = [[ShoppingCartCollectionViewController alloc] init];
        [self.navigationController pushViewController:shopping animated:YES];
    } else if (button.tag == 1001) {
        ShoppingCartTableViewController *shoppingCart = [[ShoppingCartTableViewController alloc] init];
        [self.navigationController pushViewController:shoppingCart animated:YES];
    }
}

@end
