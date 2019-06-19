//
//  DemoTableView.m
//  ZGestureConflictDemo
//
//  Created by zjixin on 2019/5/17.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "DemoTableView.h"

@implementation YPlayerView



@end

@implementation DemoTableView

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return NO;
//}
//
////第二个会失效
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//    NSLog(@"gesture = %@", gestureRecognizer.view);
//    NSLog(@"otherGesture = %@", otherGestureRecognizer.view);
//
//    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"YPlayerView")]) {
//        return YES;
//    }
//    return NO;
//}
//
////第一个失效
////- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
////    NSLog(@"gesture = %@", gestureRecognizer.view);
////    NSLog(@"otherGesture = %@", otherGestureRecognizer.view);
////
////    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableView")] && ![gestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableView")]) {
////        return YES;
////    }
////    return NO;
////}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return YES;
//}

@end
