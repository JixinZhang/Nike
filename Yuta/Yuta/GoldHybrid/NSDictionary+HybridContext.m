//
//  NSDictionary+HybridContext.m
//  GoldHybridFramework
//
//  Created by Micker on 16/9/6.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import "NSDictionary+HybridContext.h"
#import "HybridJsBridge.h"

@implementation NSDictionary (HybridContext)

- (UIWebView *) webView {
    return [self valueForKey:@"webView"];
}

- (UIView *) currentView {
    return [self valueForKey:@"currentView"];
}

- (WKWebView *) wkWebView {
    return [self valueForKey:@"wkWebView"];
}

- (UIViewController *) controller {
    return [self valueForKey:@"controller"];
}

- (HybridJsBridge *) bridge {
    return [self valueForKey:@"bridge"];
}
@end
