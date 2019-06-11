//
//  ZNSThreadViewController.m
//  ZGCDDemoApp
//
//  Created by zjixin on 2019/6/11.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZNSThreadViewController.h"
#import <pthread.h>

/**
 https://www.jianshu.com/p/cbaeea5368b1
 */
@interface ZNSThreadViewController()

@property (nonatomic, strong) NSArray<NSDictionary *> *dataSource;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSThread *ticketWindowSH;
@property (nonatomic, strong) NSThread *ticketWindowBJ;
@property (nonatomic, assign) NSInteger ticketCount;

@end

@implementation ZNSThreadViewController

static NSString *cellIdentifier = @"ZNSThreadCell";

- (void)dealloc {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.ticketWindowSH isExecuting]) {
        [self.ticketWindowSH cancel];
    }
    
    if ([self.ticketWindowBJ isExecuting]) {
        [self.ticketWindowBJ cancel];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
                        @{@"title" : @"1. pthread 使用",
                          @"action" : @"pthreadDemo"},
                        @{@"title" : @"2. NSThread 基本使用",
                          @"action" : @"NSThreadDemo"},
                        @{@"title" : @"3. NSThread 线程间通信",
                          @"action" : @"downloadImage"},
                        @{@"title" : @"4.1 NSThread 非线程安全",
                          @"action" : @"NSThreadNotSafe"},
                        @{@"title" : @"4.2 NSThread 线程安全",
                          @"action" : @"NSThreadSafe"}
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
 pthread 基本使用方法
 */
- (void)pthreadDemo {
    //1. 创建线程
    pthread_t thread;
    // 2. 开启线程: 执行任务
    pthread_create(&thread, NULL, run, NULL);
    // 3. 设置子线程的状态设置为 detached，该线程运行结束后会自动释放所有资源
    pthread_detach(thread);
}

void* run(void *param) {
    NSLog(@"pthread --- %@", [NSThread currentThread]);
    return NULL;
}

/**
 NSThread 基本使用
 */
- (void)NSThreadDemo {
    // 1. 先创建线程，再启动线程
    // 1.1 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadDemoRun) object:nil];
    // 1.2 启动线程
    [thread start];
    
//    // 2. 创建线程后自动启动线程
//    [NSThread detachNewThreadSelector:@selector(threadDemoRun) toTarget:self withObject:nil];
//
//
//    // 3. 隐式创建并启动线程
//    [self performSelectorInBackground:@selector(threadDemoRun) withObject:nil];
}

- (void)threadDemoRun {
    NSLog(@"threadDemoRun --- %@", [NSThread currentThread]);
}

/**
 NSThread 线程间通信
 */
- (void)downloadImage {
    self.imageView.image = nil;
    [NSThread detachNewThreadSelector:@selector(downloadImageOnSubThread) toTarget:self withObject:nil];
}
// 异步线程下载图片
- (void)downloadImageOnSubThread {
    NSLog(@"current thread --- %@", [NSThread currentThread]);
    
    //1. get image data from url
    NSURL *imageURL = [NSURL URLWithString:@"http://img4.cache.netease.com/photo/0001/2006-07-14/2M0RCN0D00J60001.jpg"];
    //2. download image (time consuming)
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    [self performSelectorOnMainThread:@selector(refreshImageViewWith:) withObject:image waitUntilDone:YES];
}

//回到主线程刷新UI
- (void)refreshImageViewWith:(UIImage *)image {
    self.imageView.image = image;
}

/**
 NSThread 非线程安全
 */
- (void)NSThreadNotSafe {
    //1. 设置剩余火车票
    self.ticketCount = 20;
    
    //2. 设置上海火车售票窗口线程
    self.ticketWindowSH = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketNotSafe) object:nil];
    self.ticketWindowSH.name = @"Shanghai";
    
    //3. 设置北京火车售票窗口线程
    self.ticketWindowBJ = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketNotSafe) object:nil];
    self.ticketWindowBJ.name = @"Beijing";
    
    //4. 开始售票
    [self.ticketWindowSH start];
    [self.ticketWindowBJ start];
}

- (void)saleTicketNotSafe {
    while (1) {
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", self.ticketCount, [NSThread currentThread].name]);
            [NSThread sleepForTimeInterval:0.2];
        } else {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}

/**
 NSThread 线程安全
 */
- (void)NSThreadSafe {
    //1. 设置剩余火车票
    self.ticketCount = 20;
    
    //2. 设置上海火车售票窗口线程
    self.ticketWindowSH = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketSafe) object:nil];
    self.ticketWindowSH.name = @"Shanghai";
    
    //3. 设置北京火车售票窗口线程
    self.ticketWindowBJ = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketSafe) object:nil];
    self.ticketWindowBJ.name = @"Beijing";
    
    //4. 开始售票
    [self.ticketWindowSH start];
    [self.ticketWindowBJ start];
}

- (void)saleTicketSafe {
    while (1) {
        //互斥锁
        @synchronized (self) {
            if (self.ticketCount > 0) {
                self.ticketCount--;
                NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", self.ticketCount, [NSThread currentThread].name]);
                [NSThread sleepForTimeInterval:.2];
            } else {
                NSLog(@"所有火车票均已售完");
                break;
            }
        }
    }
}

@end
