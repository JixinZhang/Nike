//
//  ZAlgoSortViewController.m
//  ZAlgoDemo
//
//  Created by zjixin on 2019/6/18.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZAlgoSortViewController.h"

/**
 iOS开发几大算法资料整理
 https://www.jianshu.com/p/77ba54a46ad7
 */
@interface ZAlgoSortViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *originalArray;
@property (nonatomic, assign) NSInteger stepCount;

@end

@implementation ZAlgoSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZAlgoDemoCell"];
    
    self.dataSource = @[
                        @{@"title" : @"1. 冒泡排序",
                          @"subtitle": @"(O(n^2))",
                          @"action" : @"bubbleSortDemo"},
                        @{@"title" : @"2. 选择排序",
                          @"subtitle": @"(O(n^2))",
                          @"action" : @"selectSortDemo"},
                        @{@"title" : @"3. 插入排序",
                          @"subtitle": @"(O(n^2))",
                          @"action" : @"insertSortDemo"},
//                        @{@"title" : @"4. 希尔排序",
//                          @"subtitle": @"(O(<#n#>))",
//                          @"action" : @"<#action#>"},
                        @{@"title" : @"5.1 归并排序--自顶向下",
                          @"subtitle": @"(O(nlogn))",
                          @"action" : @"mergeSortDemo"},
                        @{@"title" : @"5.2 归并排序--自底向上",
                          @"subtitle": @"(O(nlogn))",
                          @"action" : @"mergeBottomToTopDemo"},
                        @{@"title" : @"6. 快速排序",
                          @"subtitle": @"(O(nlogn))",
                          @"action" : @"quickSortDemo"},
//                        @{@"title" : @"7. 堆排序",
//                          @"subtitle": @"(O(<#n#>))",
//                          @"action" : @"<#action#>"},
//                        @{@"title" : @"8. 计数排序",
//                          @"subtitle": @"(O(<#n#>))",
//                          @"action" : @"<#action#>"},
//                        @{@"title" : @"9. 桶排序",
//                          @"subtitle": @"(O(<#n#>))",
//                          @"action" : @"<#action#>"},
//                        @{@"title" : @"10. 基数排序",
//                          @"subtitle": @"(O(<#n#>))",
//                          @"action" : @"<#action#>"},
                        ];
    [self.tableView reloadData];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1000];
    NSInteger count = 1000;
    for (NSInteger index = 0; index < count; index++) {
        NSInteger value = arc4random() % count;
        [array addObject:@(value)];
    }
//    array = @[@(4), @(2), @(1), @(5), @(7), @(6), @(3), @(8)];
    self.originalArray = [NSArray arrayWithArray:array];
    NSLog(@"originalArray = %@", self.originalArray);
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
    NSString *action = [item valueForKey:@"action"];
    self.stepCount = 0;
    if (action) {
        SEL sel = NSSelectorFromString(action);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:item];
        }
    }
}

#pragma mark -- bubble sort

- (void)bubbleSortDemo {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.originalArray];
    for (NSInteger index = 0; index < temp.count - 1; index++) {
        for (NSInteger j = 0; j < temp.count - 1 - index; j++) {
            if ([temp[j + 1] integerValue] < [temp[j] integerValue]) {
                [temp exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                self.stepCount++;
            }
        }
    }
    NSLog(@"%@ step = %ld", NSStringFromSelector(_cmd), (long)self.stepCount);
    NSLog(@"temp = %@",temp);
}

#pragma mark - SelectSort

- (void)selectSortDemo {
    //直接选择排序
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.originalArray];
    for (NSInteger i = 0; i < temp.count; i++) {
        for (NSInteger j = i + 1; j < temp.count; j++) {
            if ([temp[j] integerValue] < [temp[i] integerValue]) {
                [temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                self.stepCount++;
            }
        }
    }
    
    NSLog(@"%@ step = %ld", NSStringFromSelector(_cmd), (long)self.stepCount);
    NSLog(@"temp = %@",temp);
}

#pragma mark -- insertSort

- (void)insertSortDemo {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.originalArray];
    [self insertSortWith:temp];
    NSLog(@"%@ step = %ld", NSStringFromSelector(_cmd), (long)self.stepCount);
    NSLog(@"temp = %@",temp);
    
}

- (void)insertSortWith:(NSMutableArray *)array {
    if (array.count <= 1) {
        return;
    }
    /* 插入排序
     1.将未排序序列的第一个元素作为有序序列，把第二个元素到最后一个元素当做未排序序列
     2.从头到尾一次扫描未排序序列，将每个元素插入到适当的位置（相等，则插入到相等元素的后面）
     */
    for (NSInteger index = 1; index < array.count; index++) {
        NSInteger value = [array[index] integerValue];
        NSInteger j = index - 1;
        for (; j >= 0; --j) {
            if ([array[j] integerValue] > value) {
                array[j+1] = array[j];
                self.stepCount++;
            } else {
                break;
            }
        }
        array[j+1] = @(value);
    }
}


#pragma mark -- Quick sort

- (void)quickSortDemo {
    // https://blog.csdn.net/vayne_xiao/article/details/53508973
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.originalArray];

    [self quickSortWithArray:temp left:0 right:temp.count - 1];
    NSLog(@"%@ step = %ld", NSStringFromSelector(_cmd), (long)self.stepCount);
    NSLog(@"temp = %@",temp);
}

- (void)quickSortWithArray:(NSMutableArray *)array
                      left:(NSInteger)left
                     right:(NSInteger)right {
    if (left > right) {
        return;
    }
    
    NSInteger i = left;
    NSInteger j = right;
    NSInteger key = [array[i] integerValue];
    while (i < j) {
        //新的循环
        //先从最右侧开始查找，不满足当前查找的值小于 基准值则继续；满足则从左侧开始查找
        while (i < j && key <= [array[j] integerValue]) {
            j--;
        }
        
        //再从左侧开始查找，不满足当前查找的值 大于等于 基准值 则继续；
        while (i < j && key >= [array[i] integerValue]) {
            i++;
        }
        
        //找到 右侧小于基准值 && 左侧大于基准值，交换
        if (i < j) {
            NSNumber *temp = array[i];
            array[i] = array[j];
            array[j] = temp;
//            [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            self.stepCount++;
        }
    }
    
    //将基准放到中间位置
    array[left] = array[i];
    array[i] = @(key);
    self.stepCount++;
   
    [self quickSortWithArray:array left:left right:i - 1];
    [self quickSortWithArray:array left:i + 1 right:right];
}

#pragma mark -- mergeSort

- (void)mergeSortDemo {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.originalArray];
    [self mergeSortWithArray:temp left:0 right:temp.count - 1];
    NSLog(@"%@ step = %ld", NSStringFromSelector(_cmd), (long)self.stepCount);
    NSLog(@"temp = %@",temp);
}

- (void)mergeSortWithArray:(NSMutableArray *)array
                      left:(NSInteger)left
                     right:(NSInteger)right {
    if (left >= right) {
        return;
    }
    //中间索引的位置
    NSInteger middle = (left + right) / 2;
    
    [self mergeSortWithArray:array left:left right:middle];
    [self mergeSortWithArray:array left:middle + 1 right:right];
    [self merge:array left:left middle:middle right:right];
    
}

- (void)merge:(NSMutableArray *)array left:(NSInteger)left middle:(NSInteger)middle right:(NSInteger)right {
    
    NSMutableArray *leftArray = [NSMutableArray arrayWithCapacity:middle - left + 1];
    NSMutableArray *rightArray = [NSMutableArray arrayWithCapacity:right - middle + 1];
    
    for (NSInteger index = left; index <= middle; index++) {
        leftArray[index - left] = array[index];
    }
    
    for (NSInteger index = middle + 1; index <= right; index++) {
        rightArray[index - (middle + 1)] = array[index];
    }
    
    NSInteger i = 0, j = 0;
    //循环从left开始到right区间内给数组重新赋值 注意赋值的时候也是从left开始的不要习惯性写成了从0开始--还有都是闭区间
    for (NSInteger k = left; k <= right; k++) {
        
        if (i >= leftArray.count) {
            array[k] = rightArray[j];
            j++;
            
        } else if (j >= rightArray.count) {
            array[k] = leftArray[i];
            i++;
            
        } else if ([leftArray[i] integerValue] > [rightArray[j] integerValue]) {
            array[k] = rightArray[j];
            j++;
            
        } else if ([leftArray[i] integerValue] <= [rightArray[j] integerValue]) {
            array[k] = leftArray[i];
            i++;
        }

        self.stepCount++;
    }
}

- (void)mergeBottomToTopDemo {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.originalArray];
    [self mergeBottomToTopWityArray:temp];
    NSLog(@"%@ step = %ld", NSStringFromSelector(_cmd), (long)self.stepCount);
    NSLog(@"temp = %@",temp);
}

- (void)mergeBottomToTopWityArray:(NSMutableArray *)array {
    for (NSInteger size = 1; size < array.count; size += size) {
        for (NSInteger i = 0; i + size < array.count; i += 2 * size) {
            NSInteger middle = i + size - 1;
            [self merge:array left:i middle:middle right:MIN(i+size+size-1, array.count-1)];
        }
    }
}
@end
