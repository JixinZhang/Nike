//
//  CFRunLoopSimple.c
//  ZRunLoopDemo
//
//  Created by zhangjixin7 on 2020/5/27.
//  Copyright © 2020 zjixin. All rights reserved.
//

#include <stdio.h>



SInt32 CFRunLoopRunSpecific(CFRunLoopRef rl, CFStringRef modeName, CFTimeInterval seconds, Boolean returnAfterSourceHandled) {     /* DOES CALLOUT */
    int32_t result = kCFRunLoopRunFinished;
    // RunLoop原理--->1. kCFRunLoopEntry
    if (currentMode->_observerMask & kCFRunLoopEntry ) __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopEntry);
    result = __CFRunLoopRun(rl, currentMode, seconds, returnAfterSourceHandled, previousMode);
    // RunLoop原理--->10. kCFRunLoopExit
    if (currentMode->_observerMask & kCFRunLoopExit ) __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
    return result;
}

/* rl, rlm are locked on entrance and exit */
static int32_t __CFRunLoopRun(CFRunLoopRef rl, CFRunLoopModeRef rlm, CFTimeInterval seconds, Boolean stopAfterHandle, CFRunLoopModeRef previousMode) {
    Boolean didDispatchPortLastTime = true;
    int32_t retVal = 0;
    do {
        // RunLoop原理--->2. kCFRunLoopBeforeTimers
        if (rlm->_observerMask & kCFRunLoopBeforeTimers) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeTimers);
        // RunLoop原理--->3. kCFRunLoopBeforeSources
        if (rlm->_observerMask & kCFRunLoopBeforeSources) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeSources);
        //RunLoop原理--->执行加入到RunLoop的Blocks
        __CFRunLoopDoBlocks(rl, rlm);

        // RunLoop原理--->4. 处理Source0
        Boolean sourceHandledThisLoop = __CFRunLoopDoSources0(rl, rlm, stopAfterHandle);
        if (sourceHandledThisLoop) {
            __CFRunLoopDoBlocks(rl, rlm);
        }
        // 处理过Source0或者未超时
        Boolean poll = sourceHandledThisLoop || (0ULL == timeout_context->termTSR);

        // RunLoop原理--->5. 如果有Source1需要处理，则跳往 9. handle_msg
        if (__CFRunLoopServiceMachPort(dispatchPort, &msg, sizeof(msg_buffer), &livePort, 0, &voucherState, NULL)) {
            goto handle_msg;
        }

        // RunLoop原理--->6. 通知Observers：RunLoop即将进入休眠 kCFRunLoopBeforeWaiting
        if (!poll && (rlm->_observerMask & kCFRunLoopBeforeWaiting)) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeWaiting);
        // RunLoop原理--->7. 休眠，如果有Source1需要处理则会唤醒RunLoop
        __CFRunLoopSetSleeping(rl);

        __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort, poll ? 0 : TIMEOUT_INFINITY, &voucherState, &voucherCopy);

        __CFRunLoopUnsetSleeping(rl);
        // RunLoop原理--->8. 通知Observers：RunLoop休眠结束kCFRunLoopAfterWaiting
        // Boolean poll = sourceHandledThisLoop || (0ULL == timeout_context->termTSR);
        // （处理过Source0或者超时） 或者 （处理过Source0并且超时）都不会发送kCFRunLoopAfterWaiting通知，因为没有休眠
        if (!poll && (rlm->_observerMask & kCFRunLoopAfterWaiting)) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopAfterWaiting);
        // RunLoop原理--->9. 处理handle_msg
        handle_msg:;
            // RunLoop原理--->9.1 处理Timer的回调
            CFRUNLOOP_WAKEUP_FOR_TIMER();
            __CFRunLoopDoTimers();

            // RunLoop原理--->9.2 处理dispatch到当前RunLoop的block
            CFRUNLOOP_WAKEUP_FOR_DISPATCH();
            __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);

            // RunLoop原理--->9.3 处理Source1（基于port）触发的事件
            CFRUNLOOP_WAKEUP_FOR_SOURCE();
            __CFRunLoopDoSource1()

            // RunLoop原理--->执行加入到RunLoop的Blocks
            __CFRunLoopDoBlocks(rl, rlm);
    } while (0 == retVal);  //RunLoop原理--->回到 2. kCFRunLoopBeforeTimers

    return retVal;
}
