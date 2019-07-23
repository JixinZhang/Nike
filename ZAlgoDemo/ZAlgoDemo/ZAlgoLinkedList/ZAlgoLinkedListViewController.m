//
//  ZAlgoLinkedListViewController.m
//  ZAlgoDemo
//
//  Created by zjixin on 2019/7/19.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZAlgoLinkedListViewController.h"
#import "ZAlgoList.h"

/**
 LeetCode算法
 
 https://github.com/knightsj/awesome-algorithm-question-solution
 
 /Users/zjixin/Documents/zjixin/Library/awesome-algorithm-question-solution/
 */
@interface ZAlgoLinkedListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *originalArray;
@property (nonatomic, assign) NSInteger stepCount;

@end

@implementation ZAlgoLinkedListViewController{
    struct ZAlgoList *list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZAlgoLinkedListCell"];
    
    self.dataSource = @[
                        @{@"title" : @"1. 链表",
                          @"subtitle": @"",
                          @"action" : @"createLinkedList"},
                        @{@"title" : @"2. 小于目标值x的放在链表左侧，大于x的放在链表右侧，原链表节点顺序不能变",
                          @"subtitle": @"",
                          @"action" : @"partitionListDemo"},
                        @{@"title" : @"3. 链表是否有环",
                          @"subtitle": @"",
                          @"action" : @"listHasCycleDemo"},
                        @{@"title" : @"4. 两个链表相交的第一个节点",
                          @"subtitle" : @"",
                          @"action" : @"getIntersectionNodeDemo"},
                        @{@"title" : @"5. 反转链表",
                          @"subtitle" : @"",
                          @"action" : @"reverseListDemo"},
                        @{@"title" : @"6.1 链表合并（while循环）",
                          @"subtitle" : @"",
                          @"action" : @"mergeListDemo"},
                        @{@"title" : @"6.2 链表合并（递归）",
                          @"subtitle" : @"",
                          @"action" : @"mergeListWithRecursionDemo"},
                        @{@"title" : @"7. 倒数第k个节点",
                          @"subtitle" : @"",
                          @"action" : @"findKthNodeToTailDemo"},
                        ];
    [self.tableView reloadData];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZAlgoLinkedListCell" forIndexPath:indexPath];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    NSString *title = [dic valueForKey:@"title"];
    NSString *subtitle = [dic valueForKey:@"subtitle"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@--%@", title, subtitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [self.dataSource objectAtIndex:indexPath.row];
    NSString *action = [item valueForKey:@"action"];
    self.stepCount = 0;
    if (action) {
        SEL sel = NSSelectorFromString(action);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:item];
        }
    }
}

#pragma mark -- Action

- (void)createLinkedList {
    int array[] = {1, 5, 3, 2, 4, 2};
    list = malloc(sizeof(struct ZAlgoList));
    for (int index = 0; index < 6; index++) {
        int val = array[index];
        appendToTail(list, val);
    }
    
    displayAllNodeValue(list->head);
}

- (void)partitionListDemo {
    printf("list origin: ");
    displayAllNodeValue(list->head);
    printf("list partition by 3: ");
    struct ZAlgoListNode *resultHead = [self partitionList:list->head target:3];
    displayAllNodeValue(resultHead);
}

- (struct ZAlgoListNode *)partitionList:(struct ZAlgoListNode *)head target:(int)target {
    struct ZAlgoListNode *leftDummy = malloc(sizeof(struct ZAlgoListNode));
    leftDummy->val = 0;
    struct ZAlgoListNode *rightDummy = malloc(sizeof(struct ZAlgoListNode));
    rightDummy->val = 0;
    
    struct ZAlgoListNode *left = leftDummy;
    struct ZAlgoListNode *right = rightDummy;
    struct ZAlgoListNode *node = head;
    
    while (node != NULL) {
        if (node->val < target) {
            left->next = node;
            left = node;
        } else {
            right->next = node;
            right = node;
        }
        node = node->next;
    }
    right->next = NULL;
    left->next = rightDummy->next;
    return leftDummy->next;
}

- (void)listHasCycleDemo {
    //创造一个有环的链表，将`- (struct ZAlgoListNode *)partitionList:(struct ZAlgoListNode *)head target:(int)target`方法的倒数第三行代码`right->next = NULL;`注释就可以创造出有环的链表
    struct ZAlgoListNode *resultHead = [self partitionList:list->head target:3];
    BOOL result = hasCycle(resultHead);
    if (result) {
        printf("has cycle");
    } else {
        printf("has not cycle");
    }
}

- (void)getIntersectionNodeDemo {
    int arrayA[] = {1, 5, 3, 2, 4, 2};
    list = malloc(sizeof(struct ZAlgoList));
    for (int index = 0; index < 6; index++) {
        int val = arrayA[index];
        appendToTail(list, val);
    }
    struct ZAlgoList *listB = malloc(sizeof(struct ZAlgoList));
    int arrayB[3] = {10, 12, 19};
    for (int index = 0; index < 3; index++) {
        int val = arrayB[index];
        appendToTail(listB, val);
    }
    
    int arrayC[4] = {20, 21, 23, 24};
    for (int index = 0; index < 4; index++) {
        int val = arrayC[index];
        struct ZAlgoListNode *node = malloc(sizeof(struct ZAlgoListNode));
        node->val = val;
        node->next = nil;
        appendNodeToTail(list, node);
        appendNodeToTail(listB, node);
    }
    
    printf("listA:");
    displayAllNodeValue(list->head);
    printf("listB:");
    displayAllNodeValue(listB->head);
    
    struct ZAlgoListNode *resultNode = getIntersectionNode(list->head, listB->head);
    if (resultNode == NULL) {
        printf("listA 和 listB 没有相交的节点");
    } else {
        printf("listA 和 listB 相交的第一个节点val = %d", resultNode->val);
    }
}

- (void)reverseListDemo {
    int arrayA[] = {1, 2, 3, 4, 5, 6};
    list = malloc(sizeof(struct ZAlgoList));
    for (int index = 0; index < 6; index++) {
        int val = arrayA[index];
        appendToTail(list, val);
    }
    printf("original:");
    displayAllNodeValue(list->head);
    struct ZAlgoListNode *newNode = reverseList(list->head);
    printf("reversed:");
    displayAllNodeValue(newNode);
}

- (void)mergeListDemo {
    int arrayA[] = {1, 2, 4};
    list = malloc(sizeof(struct ZAlgoList));
    for (int index = 0; index < 3; index++) {
        int val = arrayA[index];
        appendToTail(list, val);
    }
    
    int arrayB[] = {1, 3, 4};
    struct ZAlgoList *listB = malloc(sizeof(struct ZAlgoList));
    for (int index = 0; index < 3; index++) {
        int val = arrayB[index];
        appendToTail(listB, val);
    }
    
    struct ZAlgoListNode *newNode = mergeTwoLists(list->head, listB->head);
    
    printf("originalA:");
    displayAllNodeValue(list->head);
    
    printf("originalB:");
    displayAllNodeValue(listB->head);
    
    printf("mergeList:");
    displayAllNodeValue(newNode);
}

- (void)mergeListWithRecursionDemo {
    int arrayA[] = {1, 2, 4};
    list = malloc(sizeof(struct ZAlgoList));
    for (int index = 0; index < 3; index++) {
        int val = arrayA[index];
        appendToTail(list, val);
    }
    
    int arrayB[] = {1, 3, 4};
    struct ZAlgoList *listB = malloc(sizeof(struct ZAlgoList));
    for (int index = 0; index < 3; index++) {
        int val = arrayB[index];
        appendToTail(listB, val);
    }
    
    struct ZAlgoListNode *newNode = mergeTwoListsWithRecursion(list->head, listB->head);
    
    printf("originalA:");
    displayAllNodeValue(list->head);
    
    printf("originalB:");
    displayAllNodeValue(listB->head);
    
    printf("mergeList:");
    displayAllNodeValue(newNode);
}

- (void)findKthNodeToTailDemo {
    int array[] = {1, 2, 4, 5, 9, 10, 13, 25, 34, 49, 51, 62, 70};
    list = malloc(sizeof(struct ZAlgoList));
    for (int index = 0; index < 13; index++) {
        int val = array[index];
        appendToTail(list, val);
    }
    displayAllNodeValue(list->head);
    struct ZAlgoListNode *kthNode = findKthNodeToTail(list->head, 5);
    if (kthNode != NULL) {
        printf("kth node to tail is %d", kthNode->val);
    } else {
        printf("can not fin kth node");
    }
}

@end
