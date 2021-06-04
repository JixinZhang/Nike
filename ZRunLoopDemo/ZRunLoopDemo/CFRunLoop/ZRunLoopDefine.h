//
//  ZRunLoopDefine.h
//  ZRunLoopDemo
//
//  Created by zhangjixin7 on 2020/5/25.
//  Copyright © 2020 zjixin. All rights reserved.
//

#ifndef ZRunLoopDefine_h
#define ZRunLoopDefine_h

struct _block_item {
    struct _block_item *_next;
    CFTypeRef _mode;    // CFString or CFSet
    void (^_block)(void);
};

//typedef struct {
//    CFIndex    version;
//    void *    info;
//    const void *(*retain)(const void *info);
//    void    (*release)(const void *info);
//    CFStringRef    (*copyDescription)(const void *info);
//    Boolean    (*equal)(const void *info1, const void *info2);
//    CFHashCode    (*hash)(const void *info);
//    void    (*schedule)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
//    void    (*cancel)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
//    void    (*perform)(void *info);
//} CFRunLoopSourceContext;

//typedef struct {
//    CFIndex    version;
//    void *    info;
//    const void *(*retain)(const void *info);
//    void    (*release)(const void *info);
//    CFStringRef    (*copyDescription)(const void *info);
//    Boolean    (*equal)(const void *info1, const void *info2);
//    CFHashCode    (*hash)(const void *info);
//#if TARGET_OS_OSX || TARGET_OS_IPHONE
//    mach_port_t    (*getPort)(void *info);
//    void *    (*perform)(void *msg, CFIndex size, CFAllocatorRef allocator, void *info);
//#else
//    void *    (*getPort)(void *info);
//    void    (*perform)(void *info);
//#endif
//} CFRunLoopSourceContext1;

struct __CFRunLoopTimer {
    uint16_t _bits;
    pthread_mutex_t _lock;
    CFRunLoopRef _runLoop;
    CFMutableSetRef _rlModes;       // timer所在的runloopmode
    CFAbsoluteTime _nextFireDate;   // 下次触发时间
    CFTimeInterval _interval;        /* immutable */
    CFTimeInterval _tolerance;          /* mutable */   // 容忍度，误差范围
    uint64_t _fireTSR;            /* TSR units */
    CFIndex _order;            /* immutable */
    CFRunLoopTimerCallBack _callout;    /* immutable */ // 回调函数
    CFRunLoopTimerContext _context;    /* immutable, except invalidation */
};

struct __CFRunLoopObserver {
    pthread_mutex_t _lock;
    CFRunLoopRef _runLoop;
    CFIndex _rlCount;
    CFOptionFlags _activities;        /* immutable */
    CFIndex _order;            /* immutable */         // 标记在runloop中执行的顺序
    CFRunLoopObserverCallBack _callout;    /* immutable */ //函数指针
    CFRunLoopObserverContext _context;    /* immutable, except invalidation */
};

typedef struct __CFRunLoopMode *CFRunLoopModeRef;

struct __CFRunLoopMode {
    pthread_mutex_t _lock;    /* must have the run loop locked before locking this */
    CFStringRef _name;
    Boolean _stopped;
    char _padding[3];
    
    
    CFMutableSetRef _sources0;
    CFMutableSetRef _sources1;
    CFMutableArrayRef _observers;
    CFMutableArrayRef _timers;
    
    
    CFMutableDictionaryRef _portToV1SourceMap;
    CFIndex _observerMask;
#if USE_DISPATCH_SOURCE_FOR_TIMERS
    dispatch_source_t _timerSource;
    dispatch_queue_t _queue;
    Boolean _timerFired; // set to true by the source when a timer has fired
    Boolean _dispatchTimerArmed;
#endif
    uint64_t _timerSoftDeadline; /* TSR */
    uint64_t _timerHardDeadline; /* TSR */
};

struct __CFRunLoop {
    pthread_mutex_t _lock;            /* locked for accessing mode list */
//    __CFPort _wakeUpPort;            // used for CFRunLoopWakeUp
    Boolean _unused;
//    volatile _per_run_data *_perRunData;              // reset for runs of the run loop
    pthread_t _pthread;             // runloop对应的线程
    uint32_t _winthread;
    
    CFMutableSetRef _commonModes;           // 标记为common的Mode
    CFMutableSetRef _commonModeItems;       // 标记为common的ModeItem，包括source、timmer和Observer
    CFRunLoopModeRef _currentMode;          // 当前模式CFRunLoopMode
    CFMutableSetRef _modes;                 // 添加到当前RunLoop 的 全部RunLoopMode
    
    struct _block_item *_blocks_head;
    struct _block_item *_blocks_tail;
    CFAbsoluteTime _runTime;
    CFAbsoluteTime _sleepTime;
    CFTypeRef _counterpart;
};

#endif /* ZRunLoopDefine_h */
