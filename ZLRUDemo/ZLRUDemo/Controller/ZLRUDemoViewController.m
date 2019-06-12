//
//  ZLRUDemoViewController.m
//  ZLRUDemo
//
//  Created by zjixin on 2019/6/11.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZLRUDemoViewController.h"
#import "ZLRULinkTableViewController.h"
#import "ZLRUArrayTableViewController.h"

@interface ZLRUDemoViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSDictionary *> *dataSource;

@end

@implementation ZLRUDemoViewController

static NSString *cellIdentifier = @"ZLRUDemoCell";

- (void)viewDidLoad {
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.dataSource = @[
                        @{@"title" : @"1. 缓存淘汰算法-链表",
                          @"action" : @"LRULinkDemo:"},
                        @{@"title" : @"2. 缓存淘汰算法-数组",
                          @"action" : @"LRUArrayDemo:"},
                        ];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *item = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [item valueForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [self.dataSource objectAtIndex:indexPath.row];
    NSString *action = [item valueForKey:@"action"];
    if (action) {
        SEL sel = NSSelectorFromString(action);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:item];
        }
    }
}

#pragma mark - Action

- (void)LRULinkDemo:(NSDictionary *)model {
    NSString *title = [model valueForKey:@"title"];
    ZLRULinkTableViewController *vc = [[ZLRULinkTableViewController alloc] init];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];}

- (void)LRUArrayDemo:(NSDictionary *)model {
    NSString *title = [model valueForKey:@"title"];
    ZLRUArrayTableViewController *vc = [[ZLRUArrayTableViewController alloc] init];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];}

@end
