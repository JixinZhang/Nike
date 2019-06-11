//
//  NSDictionary+HybridContext.h
//  GoldHybridFramework
//
//  Created by Micker on 16/9/6.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@class HybridJsBridge;

typedef NSDictionary HybridContext;

@interface NSDictionary (HybridContext)

- (UIView *) currentView;

- (UIWebView *) webView;

- (WKWebView *) wkWebView;

- (UIViewController *) controller;

- (HybridJsBridge *) bridge;

@end
