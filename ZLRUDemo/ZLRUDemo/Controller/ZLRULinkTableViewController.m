//
//  ZLRULinkTableViewController.m
//  ZLRUDemo
//
//  Created by zjixin on 2019/6/11.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZLRULinkTableViewController.h"
#import "ZLRUCacheLink.h"

@interface ZLRULinkTableViewController ()

@property (nonatomic, strong) NSArray<NSString *> *dataSource;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ZLRUCacheLink *lruCache;
@property (nonatomic, assign) NSTimeInterval timeInterval;

@end

@implementation ZLRULinkTableViewController

static NSString *cellIdentifier = @"ZLRUDemoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.textView;
    self.dataSource = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n"];
    [self.tableView reloadData];
    
    self.lruCache = [[ZLRUCacheLink alloc] init];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
        _textView.editable = NO;
        _textView.scrollEnabled = YES;
        _textView.font = [UIFont systemFontOfSize:17];
    }
    return _textView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string = [self.dataSource objectAtIndex:indexPath.row];
    self.timeInterval = [[NSDate date] timeIntervalSince1970];

    [self.lruCache setObject:string forKey:string];
    [self updateTextView];
}

- (void)updateTextView {
    [self.lruCache trimToCount:5];
    NSArray<NSString *> *list = [self.lruCache cacheList];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"link \tduration = %.f", (currentTime - self.timeInterval) * 1000000);
    self.timeInterval = currentTime;

    NSMutableString *string = [[NSMutableString alloc] init];
    for (NSInteger index = 0; index < list.count; index++) {
        NSString *item = [list objectAtIndex:index];
        [string appendString:[NSString stringWithFormat:@"\n      %ld -> %@", (long)index, item]];
    }
    self.textView.text = string;
}

@end
