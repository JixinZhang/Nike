//
//  DemoViewController.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/3.
//  Copyright © 2019 app.jixin. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DemoViewController

- (void)dealloc {
    NSLog(@"DemoViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor redColor];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify =@"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    if (indexPath.row % 20 == 0 || indexPath.row % 20 == 1 || indexPath.row % 20 == 2) {
//        usleep((20 + indexPath.row * 5.0) * 1000); // ms
        cell.textLabel.text = @"卡顿";
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ -> %ld", self.title, (long)indexPath.row];
    }
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 18;
//    cell.layer.shouldRasterize = YES;
    cell.opaque = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = self.title.integerValue + 1;
    DemoViewController *vc = [[DemoViewController alloc] init];
    vc.title = [NSString stringWithFormat:@"%ld", (long)index];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
