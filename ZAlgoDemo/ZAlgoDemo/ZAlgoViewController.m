//
//  ZAlgoViewController.m
//  ZAlgoDemo
//
//  Created by zjixin on 2019/6/20.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZAlgoViewController.h"

@interface ZAlgoViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ZAlgoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = "algorithm by Objective-C"
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZAlgoDemoCell"];
    
    self.dataSource = @[
                        @{@"title" : @"1. 排序算法",
                          @"subtitle": @"",
                          @"viewController" : @"ZAlgoSortViewController"},
                        @{@"title" : @"2. 其他",
                          @"subtitle": @"",
                          @"viewController" : @"ZAlgoStringViewController"},
                        ];
    [self.tableView reloadData];
    
    [self.view.layer.delegate actionForLayer:self.view.layer forKey:@"position"];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZAlgoDemoCell" forIndexPath:indexPath];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    NSString *title = [dic valueForKey:@"title"];
    NSString *subtitle = [dic valueForKey:@"subtitle"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@--%@", title, subtitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [self.dataSource objectAtIndex:indexPath.row];
    [self showDemoWithModel:item];
}

- (void)showDemoWithModel:(NSDictionary *)model {
    NSString *vcClassName = [model valueForKey:@"viewController"];
    if (vcClassName == nil) {
        return;
    }
    Class vcClass = NSClassFromString(vcClassName);
    id viewController = [[vcClass alloc] init];
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
