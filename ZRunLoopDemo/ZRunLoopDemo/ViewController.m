//
//  ViewController.m
//  ZRunLoopDemo
//
//  Created by zjixin on 2019/9/21.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>

@interface ViewController ()

@end

void ZCFRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            printf("   kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            printf("   kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            printf("   kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            printf("   kCFRunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            printf("   kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            printf("   kCFRunLoopExit");
            break;
        default:
            break;
    }
    printf("\t\t --- %lu\n", activity);
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CFRunLoopObserverRef observerRef = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ZCFRunLoopObserverCallBack, nil);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observerRef, kCFRunLoopCommonModes);
    CFRelease(observerRef);
}


@end
