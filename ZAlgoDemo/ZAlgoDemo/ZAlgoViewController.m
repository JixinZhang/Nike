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

@property (nonatomic, strong) UILabel       *searchWordLabel1;
@property (nonatomic, strong) UILabel       *searchWordLabel2;
@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, assign) NSInteger     count;

@end

@implementation ZAlgoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"algorithm by Objective-C";
//    [self.view addSubview:self.tableView];
    
//    NSLog(@"%@", [NSRunLoop currentRunLoop]);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZAlgoDemoCell"];
    
    self.dataSource = @[
                        @{@"title" : @"1. 排序算法",
                          @"subtitle": @"",
                          @"viewController" : @"ZAlgoSortViewController"},
                        @{@"title" : @"2. 链表",
                          @"subtitle" : @"",
                          @"viewController" : @"ZAlgoLinkedListViewController"},
                        @{@"title" : @"3. 二分查找(Binary search)",
                          @"subtitle": @"",
                          @"viewController" : @"ZAlgoStringViewController"},
                        @{@"title" : @"4. 二叉搜索树(Binary Search Tree)",
                          @"subtitle": @"",
                          @"viewController" : @"ZAlgoTreeViewController"},
                        @{@"title" : @"0. 其他",
                          @"subtitle": @"",
                          @"viewController" : @"ZAlgoStringViewController"},
                        @{@"title" : @"测试内存泄漏",
                          @"subtitle": @"",
                          @"viewController" : @"ZAlgoLeakDemoViewController"},
                        ];
    [self.tableView reloadData];
    
    [self.view.layer.delegate actionForLayer:self.view.layer forKey:@"position"];
    sort();
    
    self.searchWordLabel1.frame = CGRectMake(20, 200, 100 - 20 - 12.5, 40);
    self.searchWordLabel2.frame = CGRectMake(20, 240, 100 - 20 - 12.5, 40);
    
    [self.view addSubview:self.searchWordLabel1];
    [self.view addSubview:self.searchWordLabel2];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    _count = 0;
}

- (void)tick {
    BOOL labelOnewillLeavel = _searchWordLabel2.frame.origin.y >= 200;

    UILabel *willLeavel = labelOnewillLeavel ? _searchWordLabel1 : _searchWordLabel2;
    UILabel *willCome   = labelOnewillLeavel ? _searchWordLabel2 : _searchWordLabel1;
        
    willCome.alpha = 1;
    
    willCome.text = [NSString stringWithFormat:@"%ld", (long)_count++];
    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
    [UIView animateWithDuration:0.3 delay:0 options:options animations:^{
        willCome.alpha = 1;
        willCome.frame = CGRectMake(20, 200, 100 - 20 - 12.5, 40);;
        
        willLeavel.alpha = 0;
        willLeavel.frame = CGRectMake(20, 160, 100 - 20 - 12.5, 40);;
        
        
    } completion:^(BOOL finished) {
        willCome.alpha = 1;
        willCome.frame = CGRectMake(20, 200, 100 - 20 - 12.5, 40);
        
        willLeavel.alpha = 0;
        willLeavel.frame = CGRectMake(20, 240, 100 - 20 - 12.5, 40);
    }];
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
        NSMutableArray *mutaArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        NSInteger index = [mutaArr indexOfObject:viewController];
        if (index != NSNotFound) {
            Class vcCls = NSClassFromString(@"ZAlgoLinkedListViewController");
            id vc = [[vcCls alloc] init];
            [mutaArr insertObject:vc atIndex:index];
//            [self.navigationController setViewControllers:mutaArr animated:NO];
            self.navigationController.viewControllers = mutaArr;
        }
    }
}

int compar_int(const void* _a, const void* _b) {
    int *a = (int* )_a;
    int *b = (int *)_b;
    return *a - *b;
}

void sort() {
    int array[] = {6, 1 ,2 ,7, 9, 3, 4, 5, 10, 8};
    //C语言提供的快速排序函数
    qsort(array, 10, sizeof(int), compar_int);
    printf("");
}



- (UILabel *)searchWordLabel1 {
    if (!_searchWordLabel1) {
        _searchWordLabel1 = [[UILabel alloc] init];
        _searchWordLabel1.userInteractionEnabled = NO;
        _searchWordLabel1.font = [UIFont systemFontOfSize:13];
    }
    return _searchWordLabel1;
}

- (UILabel *)searchWordLabel2 {
    if (!_searchWordLabel2) {
        _searchWordLabel2 = [[UILabel alloc] init];
        _searchWordLabel2.userInteractionEnabled = NO;
        _searchWordLabel2.font = [UIFont systemFontOfSize:13];
    }
    return _searchWordLabel2;
}

@end
