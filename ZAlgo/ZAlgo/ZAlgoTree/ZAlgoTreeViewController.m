//
//  ZAlgoTreeViewController.m
//  ZAlgoDemo
//
//  Created by zjixin on 2019/8/29.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZAlgoTreeViewController.h"
#import "ZAlgoTreeOC.h"

@interface ZAlgoTreeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *dataSource;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *originalArray;
@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic, strong) ZAlgoTreeOC *tree;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ZAlgoTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZAlgoTreeCell"];
    self.tableView.tableFooterView = self.textView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UIColor blackColor];
        _textView.backgroundColor = [UIColor brownColor];
    }
    return _textView;
}

- (void)setupData{
    self.dataSource = @[
                        @{@"title" : @"1. 生成二叉树",
                          @"action" : @"generateBinarySearchTree"},
                        
                        @{@"title" : @"2.1 前序遍历(根左右) -- 递归",
                          @"action" : @"bstPreOrderRecursionDemo"},
                        @{@"title" : @"2.2 前序遍历(根左右) -- 栈",
                          @"action" : @"preOrderStackDemo"},
                        
                        @{@"title" : @"3.1 中序遍历(左根右) -- 递归",
                          @"action" : @"inOrderRecursionDemo"},
                        @{@"title" : @"3.2 中序遍历(左根右) -- 栈",
                          @"action" : @"inOrderStackDemo"},
                        
                        @{@"title" : @"3.1 后序遍历(左右根) -- 递归",
                          @"action" : @"postOrderRecursionDemo"},
                        @{@"title" : @"3.2 后序遍历(左右根) -- 栈 -- 标记量",
                          @"action" : @"postOrderStackDemo"},
                        @{@"title" : @"3.3 后序遍历(左右根) -- 栈 -- 记录",
                          @"action" : @"postOrderStackWithRecordDemo"},
                        
                        @{@"title" : @"4. 层级遍历 -- 队列",
                          @"action" : @"levelOrderDemo"},
                        
                        @{@"title" : @"5. 删除二叉树中的节点",
                          @"action" : @"deleteDemo"},
                        ];
    
    self.originalArray = [NSMutableArray arrayWithArray:@[@(33), @(17), @(13), @(16), @(18), @(25), @(19), @(27), @(50), @(34), @(58), @(66), @(51), @(55)]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZAlgoTreeCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *title = dic[@"title"];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.stepCount = 0;
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *action = dic[@"action"];
    if (action) {
//        printf("- (void)%s {\n\t\n", action.UTF8String);
//        printf("}\n\n");
        SEL sel = NSSelectorFromString(action);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel];
        }
    }
}

- (void)generateBinarySearchTree {
    self.originalArray = [NSMutableArray arrayWithArray:@[@(33), @(17), @(13), @(16), @(18), @(25), @(19), @(27), @(50), @(34), @(58), @(66), @(51), @(55)]];
    NSInteger rootValue = self.originalArray.firstObject.integerValue;
    [self.originalArray removeObjectAtIndex:0];
    ZAlgoTreeNodeOC *root = [[ZAlgoTreeNodeOC alloc] initWithValue:rootValue];
    self.tree = [[ZAlgoTreeOC alloc] initWithRoot:root];
    for (NSNumber *num in self.originalArray) {
        [self.tree insertWithValue:num.integerValue];
    }
    NSInteger maxDepth = [self.tree maxDepth];
    BOOL isBST = [self.tree isVailBST];
    NSMutableString *string = [NSMutableString stringWithFormat:@"\noriginalData = [%ld, ", (long)rootValue];
    for (NSNumber *num in self.originalArray) {
        [string appendFormat:@"%@, ", num];
    }
    [string appendString:@"]\n\nThe tree"];
    [string appendFormat:@"%@ ", isBST ? @"is a Binary Search Tree" : @"is not a Binary Search Tree"];
    [string appendFormat:@"\nmax depth = %ld\n\n", (long)maxDepth];
    [string appendFormat:@"%s", __func__];
    self.textView.text = string;
    
}

- (void)bstPreOrderRecursionDemo {
    NSArray<ZAlgoTreeNodeOC *> *result = [self.tree preOrderRecursion];
    NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:result.count];
    for (ZAlgoTreeNodeOC *node in result) {
        [array addObject:@(node.val)];
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"\npreOrder = ["];
    for (NSNumber *num in array) {
        [string appendFormat:@"%@, ", num];
    }
    [string appendString:@"]\n\n"];
    [string appendFormat:@"%s", __func__];
    self.textView.text = string;
}

- (void)preOrderStackDemo {
    NSArray<ZAlgoTreeNodeOC *> *result = [self.tree preOrderStack];
    NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:result.count];
    for (ZAlgoTreeNodeOC *node in result) {
        [array addObject:@(node.val)];
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"\npreOrder = ["];
    for (NSNumber *num in array) {
        [string appendFormat:@"%@, ", num];
    }
    [string appendString:@"]\n\n"];
    [string appendFormat:@"%s", __func__];
    self.textView.text = string;
}

- (void)inOrderRecursionDemo {
    NSArray<ZAlgoTreeNodeOC *> *result = [self.tree inOrderRecursion];
    NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:result.count];
    for (ZAlgoTreeNodeOC *node in result) {
        [array addObject:@(node.val)];
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"\npreOrder = ["];
    for (NSNumber *num in array) {
        [string appendFormat:@"%@, ", num];
    }
    [string appendString:@"]\n\n"];
    [string appendFormat:@"%s", __func__];
    self.textView.text = string;
}

- (void)inOrderStackDemo {
    NSArray<ZAlgoTreeNodeOC *> *result = [self.tree inOrderStack];
    NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:result.count];
    for (ZAlgoTreeNodeOC *node in result) {
        [array addObject:@(node.val)];
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"\npreOrder = ["];
    for (NSNumber *num in array) {
        [string appendFormat:@"%@, ", num];
    }
    [string appendString:@"]\n\n"];
    [string appendFormat:@"%s", __func__];
    self.textView.text = string;
}

- (void)postOrderRecursionDemo {
    NSArray<ZAlgoTreeNodeOC *> *result = [self.tree postOrderRecursion];
    NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:result.count];
    for (ZAlgoTreeNodeOC *node in result) {
        [array addObject:@(node.val)];
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"\npreOrder = ["];
    for (NSNumber *num in array) {
        [string appendFormat:@"%@, ", num];
    }
    [string appendString:@"]\n\n"];
    [string appendFormat:@"%s", __func__];
    self.textView.text = string;
}

- (void)postOrderStackDemo {
    NSArray<ZAlgoTreeNodeOC *> *result = [self.tree postOrderStack];
    NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:result.count];
    for (ZAlgoTreeNodeOC *node in result) {
        [array addObject:@(node.val)];
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"\npreOrder = ["];
    for (NSNumber *num in array) {
        [string appendFormat:@"%@, ", num];
    }
    [string appendString:@"]\n\n"];
    [string appendFormat:@"%s", __func__];
    self.textView.text = string;
}

- (void)postOrderStackWithRecordDemo {
    NSArray<ZAlgoTreeNodeOC *> *result = [self.tree postOrderStackWithRecord];
    NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:result.count];
    for (ZAlgoTreeNodeOC *node in result) {
        [array addObject:@(node.val)];
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"\npreOrder = ["];
    for (NSNumber *num in array) {
        [string appendFormat:@"%@, ", num];
    }
    [string appendString:@"]\n\n"];
    [string appendFormat:@"%s", __func__];
    self.textView.text = string;
}

- (void)levelOrderDemo {
    
}

- (void)deleteDemo {
    
}

@end
