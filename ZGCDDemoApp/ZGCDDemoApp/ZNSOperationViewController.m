//
//  ZNSOperationViewController.m
//  ZGCDDemoApp
//
//  Created by zjixin on 2019/6/11.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZNSOperationViewController.h"

@interface ZNSOperationViewController()

@property (nonatomic, strong) NSArray<NSDictionary *> *dataSource;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, assign) NSInteger ticketCount;

@end

@implementation ZNSOperationViewController

static NSString *cellIdentifier = @"ZNSOperationCell";

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
                        @{@"title" : @"1.1 NSInvocationOperation",
                          @"action" : @"useInvocationOperation"},
                        @{@"title" : @"1.2.1 NSBlockOperation",
                          @"action" : @"useBlockOperation"},
                        @{@"title" : @"1.2.2 NSBlockOperation - addExecutionBlock",
                          @"action" : @"useBlockOperationAddExecutionBlock"},
                        @{@"title" : @"2. NSOperationQueue",
                          @"action" : @"useOperationQueue"},
                        @{@"title" : @"3.1 串行",
                          @"action" : @"useOperationQueueSerial"},
                        @{@"title" : @"3.2 并行",
                          @"action" : @"useOperationQueueConcurrent"},
                        @{@"title" : @"4. 操作依赖",
                          @"action" : @"addDependency"},
                        @{@"title" : @"5. 优先级(优先级不能取代操作依赖)",
                          @"action" : @"queuePriority"},
                        @{@"title" : @"6. 线程间通信",
                          @"action" : @"queueCommuication"},
                        @{@"title" : @"7. 线程安全",
                          @"action" : @"queueSecurity"},
                        ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = self.imageView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView reloadData];
    
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 282)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (NSLock *)lock {
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
            [self performSelector:sel];
        }
    }
}

#pragma mark - Action

/**
 NSInvocationOperation 类
 */
- (void)useInvocationOperation {
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    [operation start];
}

- (void)task1 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    }
}

/**
 NSBlockOperation 类
 */
- (void)useBlockOperation {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [operation start];
}


/**
 NSBlockOperation addExecutionBlock
 */
- (void)useBlockOperationAddExecutionBlock {
    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 2.添加额外的操作
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"6---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"7---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"8---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 3.调用 start 方法开始执行操作
    [op start];
}

/**
 NSOperationQueue
 */
- (void)useOperationQueue {
    //1. 获取队列
    //主队列
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    //自定义队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    
    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}

- (void)task2 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    }
}


/**
 NNSOperationQueue for serial
 */
- (void)useOperationQueueSerial {
    [self useOperationQueueWithMaxConcurrentOperationCount:1];
}

/**
 NSOperationQueue for concurrent
 */
- (void)useOperationQueueConcurrent {
    [self useOperationQueueWithMaxConcurrentOperationCount:4];
}

- (void)useOperationQueueWithMaxConcurrentOperationCount:(NSInteger)count {
    //1. 获取队列
    
    //自定义队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = count;
    // 2.创建操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}

/**
 NSOperationQueue 依赖
 */
- (void)addDependency {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 3.添加依赖
    [op2 addDependency:op1]; // 让op2 依赖于 op1，则先执行op1，在执行op2
    
    // 4.添加操作队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}

- (void)queuePriority {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;
    
    // 2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    op1.queuePriority = NSOperationQueuePriorityVeryLow;
    op2.queuePriority = NSOperationQueuePriorityVeryHigh;
    op4.queuePriority = NSOperationQueuePriorityNormal;
    op5.queuePriority = NSOperationQueuePriorityVeryHigh;
    
    // 3.添加依赖 op3->op2->op1
    [op2 addDependency:op1];
    [op3 addDependency:op2];
    
    // 4.添加操作队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
}

/**
 线程间通信
 */
- (void)queueCommuication {
    self.imageView.image = nil;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    __weak typeof(self)weakSelf = self;
    [queue addOperationWithBlock:^{
        //1. get image data from url
        NSURL *imageURL = [NSURL URLWithString:@"http://img4.cache.netease.com/photo/0001/2006-07-14/2M0RCN0D00J60001.jpg"];
        //2. download image (time consuming)
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            weakSelf.imageView.image = image;
        }];
    }];
}

//线程安全
- (void)queueSecurity {
    self.ticketCount = 20;
    NSOperationQueue *queueSH = [[NSOperationQueue alloc] init];
    queueSH.maxConcurrentOperationCount = 1;
    __weak typeof(self)weakSelf = self;
    [queueSH addOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];
    
    NSOperationQueue *queueBJ = [[NSOperationQueue alloc] init];
    queueBJ.maxConcurrentOperationCount = 1;
    
    [queueBJ addOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];
}

- (void)saleTicketSafe {
    while (1) {
        [self.lock lock];
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", self.ticketCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:.2];
        } else {
            NSLog(@"所有火车票均已售完");
            [self.lock unlock];
            break;
        }
        [self.lock unlock];
    }
    [[NSRunLoop mainRunLoop] addTimer:<#(nonnull NSTimer *)#> forMode:NSRunLoopCommonModes]
}

@end
