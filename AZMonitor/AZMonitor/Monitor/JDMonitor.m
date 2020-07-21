//
//  JDMonitor.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2019/12/3.
//  Copyright © 2019 app.jixin. All rights reserved.
//

#import "JDMonitor.h"
#import "MJCallStack.h"

#define kPageFreezeTimeSlightly 50
#define kPageFreezeTimeSeriously 80

@interface JDUIStuckMonitor : NSObject {
    @public
    NSInteger _slightlyCount;
    NSInteger _seriouslyCount;
    CFTimeInterval _lastTime;
    dispatch_semaphore_t _lock;
    CFMutableArrayRef _slightlyTimeArr;
    CFMutableArrayRef _seriouslyTimeArr;
    CFRunLoopObserverRef _runLoopObserver;
    CFRunLoopActivity _runLoopActivity;
}

@property (nonatomic, assign, getter=isStart) BOOL start;
@property (nonatomic, assign, getter=isEnd) BOOL end;
@property (nonatomic, strong) NSMutableArray<NSString *> *slightlyRecordArr;
@property (nonatomic, strong) NSMutableArray<NSString *> *seriouslyRecordArr;
@property (nonatomic, weak)   UIViewController *viewController;

@end

@implementation JDUIStuckMonitor

- (void)dealloc {
    NSLog(@"JDMonitor ======= dealloc");
}

- (void)initDatas {
    _slightlyCount = 0;
    _seriouslyCount = 0;
    _lastTime = 0;
    _lock = dispatch_semaphore_create(0);

    _slightlyTimeArr = CFArrayCreateMutable(CFAllocatorGetDefault(), 3, &kCFTypeArrayCallBacks);
    _seriouslyTimeArr = CFArrayCreateMutable(CFAllocatorGetDefault(), 3, &kCFTypeArrayCallBacks);
    self.end = NO;
    self.seriouslyRecordArr = [NSMutableArray array];
    self.slightlyRecordArr = [NSMutableArray array];
}

#pragma mark - Private

- (void)p_clearRecord {
    _slightlyCount = 0;
    CFArrayRemoveAllValues(_slightlyTimeArr);
    _seriouslyCount = 0;
    CFArrayRemoveAllValues(_seriouslyTimeArr);
}

- (void)p_reportPageFreezeWith:(NSArray *)record seriously:(BOOL)seriously {
    NSString *string = [NSString stringWithFormat:@"JDMonitor ======= %@ %@", seriously ? @"重度❌" : @"轻度⚠️", record];
    printf("\n%s\n", string.UTF8String);
    NSString *backtrace = [MJCallStack mj_backtraceOfMainThread];
    if (backtrace && backtrace.length) {
        if (seriously) {
            [self.seriouslyRecordArr addObject:backtrace];
        } else {
            [self.slightlyRecordArr addObject:backtrace];
        }
    }
}

/// 监听RunLoop状态台变的回调
/// @param observer RunLoop监听
/// @param activity RunLoop状态
/// @param info 监听的环境
static void jd_CFRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    JDUIStuckMonitor *monitor = (__bridge JDUIStuckMonitor *)info;
    if ([monitor isKindOfClass:[JDUIStuckMonitor class]]) {
        monitor->_runLoopActivity = activity;
        dispatch_semaphore_t lock = monitor->_lock;
        if (lock != NULL) {
            // RunLoop状态改变
            // 解锁
            dispatch_semaphore_signal(lock);
        }
    } else {
        NSLog(@"info = %@", info);
    }
}

- (void)startMonitor {
    [self initDatas];
    // 给主线程添加监听
     CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
     CFRunLoopRef runLoop = CFRunLoopGetMain();
     _runLoopObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, jd_CFRunLoopObserverCallBack, &context);
     CFRunLoopAddObserver(runLoop, _runLoopObserver, kCFRunLoopCommonModes);
    
     // 开辟一个子线程处理卡顿
     dispatch_queue_t queue = dispatch_queue_create("com.jd.sh.monitor.uistuck", DISPATCH_QUEUE_CONCURRENT);
     __weak __typeof__ (self)weakSelf = self;
     dispatch_async(queue, ^{
         __strong __typeof__ (self)strongSelf = weakSelf;
         if (!strongSelf) {
             return;
         }
         while (YES) {
             if (strongSelf.isEnd) {
                 return;
             }
             if (!strongSelf.isStart) {
                 continue;
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
//                 printf("JDMonitor ======= delta: %ld\n", integerDelta);
                 
                 if (deltaMilliSecond >= kPageFreezeTimeSeriously) {
                     // 时间差大于等于80ms，记录到严重卡顿中
                     strongSelf->_seriouslyCount += 1;
                     CFArrayAppendValue(strongSelf->_seriouslyTimeArr, (__bridge const void *)(@(integerDelta)));
                     
                 } else if (deltaMilliSecond >= kPageFreezeTimeSlightly) {
                     // 时间差大于等于50ms，记录到轻微卡顿中
                     strongSelf->_slightlyCount += 1;
                     CFArrayAppendValue(strongSelf->_slightlyTimeArr, (__bridge const void *)(@(integerDelta)));
                     
                 } else {
                     // 时间差小于50ms，则不记录并且将之前记录的数据清空
                     [strongSelf p_clearRecord];
                 }
                 // 判断卡顿
                 if (strongSelf->_seriouslyCount == 3) {
                     // 连续三次超过80ms，上报一次严重卡顿
                     [strongSelf p_reportPageFreezeWith:(__bridge NSArray *)(strongSelf->_seriouslyTimeArr) seriously:YES];
                     [strongSelf p_clearRecord];
                     
                 } else if (strongSelf->_slightlyCount == 2) {
                     // 连续两次超过50ms，上报一次轻度卡顿
                     [strongSelf p_reportPageFreezeWith:(__bridge NSArray *)(strongSelf->_slightlyTimeArr) seriously:NO];
                     [strongSelf p_clearRecord];
                     
                 } else if (strongSelf->_slightlyCount + strongSelf->_seriouslyCount == 3) {
                     // 轻度卡顿次数+严重卡顿次数 连续且等于三次，上报一次轻度卡顿
                     NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:3];
                     [temp addObjectsFromArray:(__bridge NSArray *)(strongSelf->_seriouslyTimeArr)];
                     [temp addObjectsFromArray:(__bridge NSArray *)(strongSelf->_slightlyTimeArr)];
                     [strongSelf p_reportPageFreezeWith:temp seriously:NO];
                     [strongSelf p_clearRecord];
                 }
             }
         }
     });
}

- (void)endMonitor {
    self.start = NO;
    self.end = YES;
    if (!_runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(_runLoopObserver);
    _runLoopObserver = NULL;
}

- (void)startMonitorForViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    [self.seriouslyRecordArr removeAllObjects];
    [self.slightlyRecordArr removeAllObjects];
    self.start = YES;
    [self startMonitor];
}

- (void)pauseMonitor {
    self.start = NO;
    NSMutableDictionary *record = [NSMutableDictionary dictionaryWithCapacity:2];
    if (self.seriouslyRecordArr.count) {
        record[@"seriously"] = self.seriouslyRecordArr;
    }
    
    if (self.slightlyRecordArr.count) {
        record[@"slightly"] = self.slightlyRecordArr;
    }
    
    if (self.viewController) {
        record[@"vc"] = self.viewController;
    }
    NSLog(@"JDMonitor ======= record: %@", record);
    self.viewController = nil;
    [self endMonitor];
}

@end

@interface JDMonitor ()

@property (nonatomic, strong) JDUIStuckMonitor *uiStockMonitor;
@property (nonatomic, assign) BOOL enable;
@end

@implementation JDMonitor

+ (instancetype)sharedMonitor {
    static JDMonitor *_monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _monitor = [[JDMonitor alloc] init];
    });
    return _monitor;
}


#pragma mark - Public

+ (void)enableMonitor {
    [JDMonitor sharedMonitor].enable = YES;
}

+ (void)disableMonitor {
    [JDMonitor sharedMonitor].enable = NO;
}

- (void)startMonitorForViewController:(UIViewController *)viewController {
    if (self.enable) {
        JDUIStuckMonitor *uiStockMonitor = [[JDUIStuckMonitor alloc] init];
        [uiStockMonitor startMonitorForViewController:viewController];
        self.uiStockMonitor = uiStockMonitor;
    }
}

- (void)pauseMonitor {
    if (self.uiStockMonitor) {
        [self.uiStockMonitor pauseMonitor];
        self.uiStockMonitor = nil;
    }
}

@end
