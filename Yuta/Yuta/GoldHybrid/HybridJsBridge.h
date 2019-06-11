//
//  HybridJsBridge.h
//  GoldHybridFramework
//
//  Created by Micker on 16/9/6.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol HybridJsBridgeExport <JSExport>

/**
 
 @param invoke js中的方法
 @param void 映射到OC中的方法
 */
JSExportAs(invoke, - (void) invoke:(NSString *) method args:(NSString *) args);

@end

@interface HybridJsBridge : NSObject

@property (nonatomic, weak, readwrite) UIWebView        *webView;
@property (nonatomic, weak, readwrite) WKWebView        *wkWebView;
@property (nonatomic, weak, readonly ) UIViewController *controller;

- (void) invokeCallBackId:(NSString *)callbackID response:(NSDictionary *) response;

@end

#pragma mark --
#pragma mark -- UIWebView
@interface HybridJsBridge(UIWebView)<HybridJsBridgeExport>

@end

#pragma mark --
#pragma mark -- WKWebView
@interface HybridJsBridge(WKWebView)<WKScriptMessageHandler>

@end
