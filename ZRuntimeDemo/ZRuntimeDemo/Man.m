//
//  Man.m
//  ZRuntimeDemo
//
//  Created by zjixin on 2019/6/5.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "Man.h"

@implementation Man

- (void)foo:(id)send {
    NSLog(@"Doing foo");
}

+ (void)test {
    NSLog(@"Man +%@", NSStringFromSelector(_cmd));
}

@end
