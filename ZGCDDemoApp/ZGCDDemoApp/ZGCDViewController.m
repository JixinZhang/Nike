//
//  ZGCDViewController.m
//  ZGCDDemoApp
//
//  Created by zjixin on 2019/6/11.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZGCDViewController.h"

/**
 https://www.jianshu.com/p/2d57c72016c6
 */
@interface ZGCDViewController()<UITableViewDelegate, UITableViewDataSource>{
    dispatch_semaphore_t _semaphoreLock;
}

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger ticketCount;

@end

@implementation ZGCDViewController

static NSString *cellIdentifier = @"ZGCDCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
                        @{@"title" : @"1. 同步执行 + 并发队列",
                          @"action" : @"syncConcurrent"},
                        @{@"title" : @"2. 异步执行 + 并发队列",
                          @"action" : @"asyncConcurrent"},
                        @{@"title" : @"3. 同步执行 + 串行队列",
                          @"action" : @"syncSerial"},
                        @{@"title" : @"4. 异步执行 + 串行队列",
                          @"action" : @"asyncSerial"},
                        @{@"title" : @"5.1 主线程中调用 同步执行 + 主队列",
                          @"action" : @"syncMain"},
                        @{@"title" : @"5.2 其他线程中，同步执行 + 主队列",
                          @"action" : @"otherQueheSyncMain"},
                        @{@"title" : @"6. 异步执行 + 主队列",
                          @"action" : @"asyncMain"},
                        @{@"title" : @"7. dispatch_barrier_async（栅栏）",
                          @"action" : @"dispatchBarrieryAsync"},
                        @{@"title" : @"8. dispatch_apply（快速迭代）",
                          @"action" : @"dispatchApply"},
                        @{@"title" : @"9. dispatch_group（队列组）",
                          @"action" : @"groupNotify"},
                        @{@"title" : @"10.1 dispatch_semaphore(非线程安全)",
                          @"action" : @"dispatchSemaphoreNotSafe"},
                        @{@"title" : @"10.2 dispatch_semaphore(线程安全)",
                          @"action" : @"dispatchSemaphore"},
                        ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView reloadData];
    
//    [self performSelector:@selector(viewDidLoad) withObject:nil afterDelay:0];
    
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
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    NSLog(@"syncCocurrent --- %@", [NSThread currentThread]);
    NSLog(@"syncCocurrent --- begin");
    
    dispatch_queue_t queueConCurrent = dispatch_queue_create("app.jixin.queue.concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queueConCurrent, ^{
        //任务1
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:0.5];  //模拟耗时操作
            NSLog(@"syncCocurrent --- task1 --- %@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queueConCurrent, ^{
        //任务2
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:0.5];  //模拟耗时操作
            NSLog(@"syncCocurrent --- task2 --- %@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queueConCurrent, ^{
        //任务3
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:0.5];  //模拟耗时操作
            NSLog(@"syncCocurrent --- task3 --- %@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"syncCocurrent --- end");
}

/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"currentThread --- %@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent --- begin");
    
    dispatch_queue_t queueConCurrent = dispatch_queue_create("app.jixin.queue.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queueConCurrent, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"asyncConcurrent --- task1 --- %@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queueConCurrent, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"asyncConcurrent --- task2 --- %@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queueConCurrent, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"asyncConcurrent --- task3 --- %@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent --- end");
}

/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queueSerial = dispatch_queue_create("app.jixin.queue.serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queueSerial, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queueSerial, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queueSerial, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncSerial---end");
    
}

/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queueSerial = dispatch_queue_create("app.jixin.queue.serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queueSerial, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queueSerial, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queueSerial, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncSerial---end");
}

/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncMain---end");
}

- (void)otherQueheSyncMain {
    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
}

/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncMain---end");
}

/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)dispatchBarrieryAsync {
    dispatch_queue_t queue = dispatch_queue_create("app.jixin.queue.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}

- (void)dispatchApply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"dispatch_apply --- begin");
    dispatch_apply(6, queue, ^(size_t idx) {
        NSLog(@"%zd --- %@", idx, [NSThread currentThread]);
    });
    NSLog(@"dispatch_apply --- end");
}

/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
}

/*
 场景：总共有50张火车票，有两个售卖火车票的窗口，一个是北京火车票售卖窗口，另一个是上海火车票售卖窗口。两个窗口同时售卖火车票，卖完为止。
 */

- (void)dispatchSemaphoreNotSafe {
    NSLog(@"currentThread --- %@", [NSThread currentThread]);
    NSLog(@"semaphore --- begin");
    
    self.ticketCount = 50;
    
    //表示上海窗口
    dispatch_queue_t queueSH = dispatch_queue_create("app.jixin.queue.shanghai", DISPATCH_QUEUE_SERIAL);
    
    //表示北京窗口
    dispatch_queue_t queueBJ = dispatch_queue_create("app.jixin.queue.beijing", DISPATCH_QUEUE_SERIAL);
    
    _semaphoreLock = dispatch_semaphore_create(1);
    __weak typeof (self)weakSelf = self;
    dispatch_async(queueSH, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queueBJ, ^{
        [weakSelf saleTicketNotSafe];
    });
    NSLog(@"semaphore --- end");
}

- (void)saleTicketNotSafe {
    while (1) {
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else {
            NSLog(@"所有车票已售完");
            break;
        }
    }
}

/*
 场景：总共有50张火车票，有两个售卖火车票的窗口，一个是北京火车票售卖窗口，另一个是上海火车票售卖窗口。两个窗口同时售卖火车票，卖完为止。
 */
- (void)dispatchSemaphore {
    NSLog(@"currentThread --- %@", [NSThread currentThread]);
    NSLog(@"semaphore --- begin");
    
    self.ticketCount = 50;
    
    //表示上海窗口
    dispatch_queue_t queueSH = dispatch_queue_create("app.jixin.queue.shanghai", DISPATCH_QUEUE_SERIAL);
    
    //表示北京窗口
    dispatch_queue_t queueBJ = dispatch_queue_create("app.jixin.queue.beijing", DISPATCH_QUEUE_SERIAL);
    
    _semaphoreLock = dispatch_semaphore_create(1);
    __weak typeof (self)weakSelf = self;
    dispatch_async(queueSH, ^{
        [weakSelf saleTicketWithSafe];
    });
    
    dispatch_async(queueBJ, ^{
        [weakSelf saleTicketWithSafe];
    });
    NSLog(@"semaphore --- end");
}

- (void)saleTicketWithSafe {
    while (1) {
        //相当于加锁 dispatch_semaphore_wait，当信号量为0时，等待。
        dispatch_semaphore_wait(_semaphoreLock, DISPATCH_TIME_FOREVER);
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else {
            NSLog(@"所有车票已售完");
            dispatch_semaphore_signal(_semaphoreLock);
            break;
        }
        //相当于解锁，当信号量大于0时，执行
        dispatch_semaphore_signal(_semaphoreLock);
        
    }
}

@end
