//
//  DemoViewController.m
//  ZGCDDemoApp
//
//  Created by zjixin on 2019/6/10.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "DemoViewController.h"
#import "ZGCDViewController.h"
#import "ZNSThreadViewController.h"
#import "ZNSOperationViewController.h"

@interface DemoViewController ()<UITableViewDelegate, UITableViewDataSource>{
    dispatch_semaphore_t _semaphoreLock;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger ticketCount;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"多线程";
    self.dataSource = @[
                        @{@"title" : @"1. GCD",
                          @"action" : @"GCDDemo:"},
                        @{@"title" : @"2. NSThread",
                          @"action" : @"NSThreadDemo:"},
                        @{@"title" : @"3. NSOperation",
                          @"action" : @"NSOperationDemo:"},
                        ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZGCDTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZGCDTableViewCell"];
    }
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

- (void)GCDDemo:(NSDictionary *)model {
    NSString *title = [model valueForKey:@"title"];
    ZGCDViewController *vc = [[ZGCDViewController alloc] init];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)NSThreadDemo:(NSDictionary *)model {
    NSString *title = [model valueForKey:@"title"];
    ZNSThreadViewController *vc = [[ZNSThreadViewController alloc] init];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];}

- (void)NSOperationDemo:(NSDictionary *)model {
    NSString *title = [model valueForKey:@"title"];
    ZNSOperationViewController *vc = [[ZNSOperationViewController alloc] init];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
