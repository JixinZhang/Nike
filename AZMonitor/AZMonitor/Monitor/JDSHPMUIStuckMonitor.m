//
//  JDSHPMUIStuckMonitor.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/5.
//  Copyright © 2019 app.jixin. All rights reserved.
//

#import "JDSHPMUIStuckMonitor.h"
#import <pthread.h>
#import "JDSHPMStackBacktrace.h"

#define kUIStuckTimelstuck 50
#define kUIStuckTimecstuck 80

@interface JDSHPMUIStuckMonitor () {
    @public
    NSInteger _lstuckCount;                 // 轻度卡顿计数
    NSInteger _cstuckCount;                 // 严重卡顿计数
    CFTimeInterval _lastTime;               // 记录上次处理时间
    pthread_mutex_t _safetyLock;            // 线程安全锁
    dispatch_semaphore_t _lock;             // 等待锁，用于产生记录的时间间隔
    CFMutableArrayRef _lstuckTimeArr;       // 记录发生轻度卡顿时卡顿时长
    CFMutableArrayRef _cstuckTimeArr;       // 记录发生严重卡顿时卡顿时长
    CFRunLoopActivity _runLoopActivity;     // 记录主线程RunLoop的状态改变后的值
    CFRunLoopObserverRef _runLoopObserver;  // 对主线程的RunLoop状态的监听
}

/// 标记主线程卡顿监控服务是否开启，开启后才可以对主线程添加监控
///
/// 关闭后主线程卡顿监控服务会立刻关闭，子线程会销毁(do-while循环被return，子线程自动被系统回收，并非立刻回收)
@property (nonatomic, assign) BOOL uistockMonitorEnable;

/// 标记开始记录页面卡顿，需要在开始监控之前设置为YES。
///
/// 设置为NO后子线程销毁(do-while循环被return，子线程自动被系统回收，并非立刻回收)
@property (nonatomic, assign) BOOL start;

/// 记录轻度卡顿函数调用堆栈信息
@property (nonatomic, strong) NSMutableArray<NSString *> *lstuckRecordArr;

/// 记录轻度卡顿的次数，第一期暂不统计函数调用堆栈信息
@property (nonatomic, assign) NSInteger lstuckRecordCount;

/// 记录严重卡顿函数调用堆栈信息
@property (nonatomic, strong) NSMutableArray<NSString *> *cstuckRecordArr;

/// 记录轻度卡顿的次数，第一期暂不统计函数调用堆栈信息
@property (nonatomic, assign) NSInteger cstuckRecordCount;

/// VC的地址，将卡顿记录和每个页面一一对应
@property (nonatomic, copy)   NSString *vcAdress;

/// 专门用于监控主线程的子线程，会随着每个VC的生命周期不断销毁和创建
@property (nonatomic, strong) NSOperationQueue *operationQueue;

/// 暂存当前vc的卡顿信息
/// key                  value      value含义及说明
///
/// lstuckCount     string      疑似卡顿的数量
/// cstuckCount    string      严重卡顿的数量
/// lstuckInfo         string      疑似卡顿堆栈信息    json数组
/// cstuckInfo        string      严重卡顿堆栈信息    json数组
@property (nonatomic, strong) NSMutableDictionary *stuckInfo;

@end

@implementation JDSHPMUIStuckMonitor

+ (instancetype)sharedMonitor {
    static JDSHPMUIStuckMonitor *_monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _monitor = [[JDSHPMUIStuckMonitor alloc] init];
    });
    return _monitor;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = dispatch_semaphore_create(0);
        pthread_mutex_init(&_safetyLock, NULL);
        self.stuckInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)initDatas {
    pthread_mutex_lock(&_safetyLock);
    
    _lstuckCount = 0;
    _cstuckCount = 0;
    _lastTime = 0;
    
    long semaphore = dispatch_semaphore_signal(_lock);
    while (semaphore) {
        semaphore = dispatch_semaphore_signal(_lock);
    }
    
    _lstuckTimeArr = CFArrayCreateMutable(CFAllocatorGetDefault(), 3, &kCFTypeArrayCallBacks);
    _cstuckTimeArr = CFArrayCreateMutable(CFAllocatorGetDefault(), 3, &kCFTypeArrayCallBacks);
    self.start = YES;
    
    self.cstuckRecordArr = [NSMutableArray array];
    self.lstuckRecordArr = [NSMutableArray array];
    pthread_mutex_unlock(&_safetyLock);
}

#pragma mark - Private

- (void)p_clearRecord {
    _lstuckCount = 0;
    CFArrayRemoveAllValues(_lstuckTimeArr);
    _cstuckCount = 0;
    CFArrayRemoveAllValues(_cstuckTimeArr);
}

- (void)p_reportUIStuckWith:(NSArray *)record cstuck:(BOOL)cstuck {
    NSString *string = [NSString stringWithFormat:@"JDSHPMUIStuckMonitor ======= %@(毫秒) %@", cstuck ? @"重度❌" : @"轻度⚠️", record];
    printf("\n%s\n", string.UTF8String);
    if (cstuck) {
        self.cstuckRecordCount += 1;
    } else {
        self.lstuckRecordCount += 1;
    }
    
    if (cstuck && self.cstuckRecordArr.count >= 10) {
        // 严重卡顿的堆栈信息只记录10条
        return;
    }
    
    if (!cstuck && self.lstuckRecordArr.count >= 10) {
        // 轻微卡顿的堆栈信息只记录10条
        return;
    }
    
    NSLog(@"JDSHPMUIStuckMonitor ======= 🐢 %@", [JDSHPMStackBacktrace jdsh_stackBacktraceOfNSThread:[NSThread mainThread]]);
    NSString *backtrace = [JDSHPMStackBacktrace jdsh_stackBacktraceOfMainThread];
     if (backtrace && backtrace.length) {
         if (cstuck) {
             [self.cstuckRecordArr addObject:backtrace];
         } else {
             [self.lstuckRecordArr addObject:backtrace];
         }
     }
//    NSString *currentThread = [NSString stringWithFormat:@"JDSHPMUIStuckMonitor ======= \n%@\n", [NSThread currentThread]];
//    printf("%s", currentThread.UTF8String);
}

/// 监听RunLoop状态台变的回调
/// @param observer RunLoop监听
/// @param activity RunLoop状态
/// @param info 监听的环境
static void jdshRunLoop_CFRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    JDSHPMUIStuckMonitor *monitor = (__bridge JDSHPMUIStuckMonitor *)info;
    monitor->_runLoopActivity = activity;
    printf("JDSHPMUIStuckMonitor ======= activity: %ld\n", activity);
    dispatch_semaphore_t lock = monitor->_lock;
    if (lock != NULL) {
        // RunLoop状态改变
        // 解锁
        dispatch_semaphore_signal(lock);
    }
}

- (void)initMonitor {
    [self initDatas];
    
    // 给主线程添加监听
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
    CFRunLoopRef runLoop = CFRunLoopGetMain();
    _runLoopObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, jdshRunLoop_CFRunLoopObserverCallBack, &context);
    CFRunLoopAddObserver(runLoop, _runLoopObserver, kCFRunLoopCommonModes);
   
    __weak __typeof__ (self)weakSelf = self;
    
    if (self.operationQueue) {
        [self.operationQueue cancelAllOperations];
        self.operationQueue = nil;
    }
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 1;
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        __strong __typeof__ (self)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        while (YES) {
            if (!strongSelf.uistockMonitorEnable) {
                NSLog(@"JDSHPMUIStuckMonitor ======= return %@\n", [NSThread currentThread]);
                return;
            }
            
            if (!strongSelf.start) {
                printf("JDSHPMUIStuckMonitor ======= return \t start\n");
                return;
            }
            
            if (strongSelf->_lastTime == 0) {
                strongSelf->_lastTime = CFAbsoluteTimeGetCurrent();
                continue;
            }
            /*
             *  加锁，超时时间80ms
             *  举个例子：
             *  1. RunLoop卡顿，卡在kCFRunLoopBeforeSources状态500ms，才进入下一个状态kCFRunLoopBeforeWaiting
             *  不加锁 则记录的时间差很小，但是RunLoop当前仍然卡在kCFRunLoopBeforeSources，则不能准确记录卡顿；
             *  加锁， 则能够记录时间差，并且可以记录连续三次的80ms。
             *  2. RunLoop没有卡顿，则加锁的地方无需等待，直接进入记录时间差
             */
            if (!strongSelf->_lock) {
                continue;
            }
            dispatch_semaphore_wait(strongSelf->_lock, dispatch_time(DISPATCH_TIME_NOW, 80 * NSEC_PER_MSEC));
            
            if (strongSelf->_runLoopActivity == kCFRunLoopBeforeSources ||
                strongSelf->_runLoopActivity == kCFRunLoopAfterWaiting)
            {
                // 和前一次的时间差，单位：s
                CFAbsoluteTime delta = CFAbsoluteTimeGetCurrent() - strongSelf->_lastTime;
                strongSelf->_lastTime = CFAbsoluteTimeGetCurrent();
                // 时间差毫秒 单位：ms
                CFAbsoluteTime deltaMilliSecond = delta * 1000;
                // 时间差毫秒取整 单位：ms
                NSInteger integerDelta = ceil(delta * 1000);
//                printf("JDSHPMUIStuckMonitor ======= delta: %ld\n", integerDelta);
                
                pthread_mutex_lock(&(strongSelf->_safetyLock));
                
                if (deltaMilliSecond >= kUIStuckTimecstuck) {
                    // 时间差大于等于80ms，记录到严重卡顿中
                    strongSelf->_cstuckCount += 1;
                    CFArrayAppendValue(strongSelf->_cstuckTimeArr, (__bridge const void *)(@(integerDelta)));
                    
                } else if (deltaMilliSecond >= kUIStuckTimelstuck) {
                    // 时间差大于等于50ms，记录到轻微卡顿中
                    strongSelf->_lstuckCount += 1;
                    CFArrayAppendValue(strongSelf->_lstuckTimeArr, (__bridge const void *)(@(integerDelta)));
                    
                } else {
                    // 时间差小于50ms，则不记录并且将之前记录的数据清空
                    [strongSelf p_clearRecord];
                }
                // 判断卡顿
                if (strongSelf->_cstuckCount == 3) {
                    // 连续三次超过80ms，上报一次严重卡顿
                    [strongSelf p_reportUIStuckWith:(__bridge NSArray *)(strongSelf->_cstuckTimeArr) cstuck:YES];
                    [strongSelf p_clearRecord];
                    
                } else if (strongSelf->_lstuckCount == 2) {
                    // 连续两次超过50ms，上报一次轻度卡顿
                    [strongSelf p_reportUIStuckWith:(__bridge NSArray *)(strongSelf->_lstuckTimeArr) cstuck:NO];
                    [strongSelf p_clearRecord];
                    
                } else if (strongSelf->_lstuckCount + strongSelf->_cstuckCount == 3) {
                    // 轻度卡顿次数+严重卡顿次数 连续且等于三次，上报一次轻度卡顿
                    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:3];
                    [temp addObjectsFromArray:(__bridge NSArray *)(strongSelf->_cstuckTimeArr)];
                    [temp addObjectsFromArray:(__bridge NSArray *)(strongSelf->_lstuckTimeArr)];
                    [strongSelf p_reportUIStuckWith:temp cstuck:NO];
                    [strongSelf p_clearRecord];
                }
                pthread_mutex_unlock(&(strongSelf->_safetyLock));
            }
        }
    }];
    operationQueue.name = @"com.jd.sh.monitor.uistuck";
    [operationQueue addOperation:operation];
    self.operationQueue = operationQueue;
}

- (void)endMonitor {
    self.start = NO;
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
    if (!_runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(_runLoopObserver);
    _runLoopObserver = NULL;
}

#pragma mark - Public

+ (void)enableMonitor {
    JDSHPMUIStuckMonitor *monitor = [JDSHPMUIStuckMonitor sharedMonitor];
    monitor.uistockMonitorEnable = YES;
}

+ (void)disableMonitor {
    JDSHPMUIStuckMonitor *monitor = [JDSHPMUIStuckMonitor sharedMonitor];
    monitor.uistockMonitorEnable = NO;
    [monitor endMonitor];
}

+ (NSDictionary *)getStuckInfo {
    return [JDSHPMUIStuckMonitor sharedMonitor].stuckInfo;
}

- (void)startMonitorForViewController:(UIViewController *)viewController {
    // 主线程卡顿监控服务未开启，则不处理
    if (!self.uistockMonitorEnable) return;
    
    if (viewController && [viewController isKindOfClass:[UIViewController class]]) {
        self.vcAdress = [NSString stringWithFormat:@"%p", viewController];
        
        [self.cstuckRecordArr removeAllObjects];
        [self.lstuckRecordArr removeAllObjects];
        self.cstuckRecordCount = 0;
        self.lstuckRecordCount = 0;
        self.start = YES;
        [self initMonitor];
    }
}

- (void)finishMonitor {
    self.start = NO;
    
    NSInteger lstuckRecordCount = self.lstuckRecordCount;
    NSInteger cstuckRecordCount = self.cstuckRecordCount;
    
    NSArray<NSString *> *lstuckRecordArr = self.lstuckRecordArr;
    NSArray<NSString *> *cstuckRecordArr = self.cstuckRecordArr;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *record = [NSMutableDictionary dictionaryWithCapacity:2];
        
        record[@"lstuckCount"] = [NSString stringWithFormat:@"%ld", (long)lstuckRecordCount];
        record[@"cstuckCount"] = [NSString stringWithFormat:@"%ld", (long)cstuckRecordCount];
        
        if (lstuckRecordArr.count) {
            NSError *error;
            NSData *lstuckData = [NSJSONSerialization dataWithJSONObject:lstuckRecordArr options:NSJSONWritingPrettyPrinted error:&error];
            NSString *lstuckInfoString = [[NSString alloc] initWithData:lstuckData encoding:NSUTF8StringEncoding];
            if (!error) {
                record[@"lstuckInfo"] = lstuckInfoString.length ? lstuckInfoString : @"";
            }
        }
        
        if (cstuckRecordArr.count) {
            NSError *error;
            NSData *cstuckData = [NSJSONSerialization dataWithJSONObject:cstuckRecordArr options:NSJSONWritingPrettyPrinted error:&error];
            NSString *cstuckInfoString = [[NSString alloc] initWithData:cstuckData encoding:NSUTF8StringEncoding];
            if (!error) {
                record[@"cstuckInfo"] = cstuckInfoString.length ? cstuckInfoString : @"";
            }
            NSLog(@"cstuckInfo's length = %ld", (long)cstuckInfoString.length);
        }
        self.stuckInfo = record;
        NSLog(@"JDSHPMUIStuckMonitor ======= record: %@", record);
    });
    self.vcAdress = nil;
    self.start = NO;
    [self endMonitor];
}

- (BOOL)monitorEnable {
    return self.uistockMonitorEnable;
}

@end
