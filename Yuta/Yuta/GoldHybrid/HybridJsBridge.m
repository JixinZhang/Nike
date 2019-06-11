//
//  HybridJsBridge.m
//  GoldHybridFramework
//
//  Created by Micker on 16/9/6.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import "HybridJsBridge.h"
#import "HybridJsManager.h"
#import <GoldLogFramework/GoldLogFramework.h>

@interface HybridJsBridge()
@property (nonatomic, weak, readwrite) UIViewController *controller;
@end

@implementation HybridJsBridge

- (NSString *) ocMethodFromString:(NSString *)origin {
    NSArray* names = [origin componentsSeparatedByString:@"."];
    NSString *oc_method = nil;
    if (names.count == 3 && [names.firstObject isEqualToString:@"Yuta"]){
        oc_method = [NSString stringWithFormat:@"%@_%@", [names[1] lowercaseString], names[2]];
    }
    return oc_method;
}

- (NSString *) jsonFromDictionary:(NSDictionary *) data {
    NSString *json = @"{}";
    if ([NSJSONSerialization isValidJSONObject:data]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return json;
}

- (UIResponder *) findFirstViewContrller:(UIResponder *) responder {
    if (responder && ![responder isKindOfClass:[UIViewController class]]) {
        return [self findFirstViewContrller:[responder nextResponder]];
    }
    return responder;
}

- (UIViewController *) controller {
    if (!_controller) {
        _controller = (UIViewController *)[self findFirstViewContrller:(self.webView?:(self.wkWebView))];
    }
    return _controller;
}


- (void) __invoke:(NSString *) method args:(NSDictionary *) dict {
    NSString *oc_method = [self ocMethodFromString:method];
    if (!oc_method) {
        ERRLOG(@"method is nil! ");
        return;
    }
    INFOLOG(@"jsapi name: %@ args = %@", oc_method, dict);
    
    if (oc_method && dict) {
        HybridJsApi *jsapi = [[HybridJsManager sharedHybridManager] jsApi:oc_method];
        
        if (!jsapi) {
            ERRLOG(@"jsapi name: %@ is not implemented!!!", oc_method);
            return;
        }
        NSString *callbackId = [dict objectForKey:@"callbackId"];
        HybridContext *context = [HybridContext dictionaryWithObject:self forKey:@"bridge"];
//        UIView *currentView = (self.webView?:(self.wkWebView));
        //self.controller = [self findFirstViewContrller:(self.webView?:(self.wkWebView))];
        //!self.controller?:[context setValue:self.controller forKey:@"controller"];
        //!self.webView?:[context setValue:self.webView forKey:@"webView"];
        //!self.wkWebView?:[context setValue:self.wkWebView forKey:@"wkWebView"];
        //!currentView ? : [context setValue:self.wkWebView forKey:@"currentView"];
        
        __weak typeof(self) weakSelf = self;
        [jsapi handler:dict context:context callBack:^(id response) {
            [weakSelf invokeCallBackId:callbackId response:response];
        }];
    }
}


- (void) invokeCallBackId:(NSString *)callbackID response:(NSDictionary *) response {
    NSString *json = [self jsonFromDictionary:response];
    NSString *jsString = [NSString stringWithFormat:@"window.__YutaAppCallback(%@,%@);", callbackID, json];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.wkWebView) {
            [self.wkWebView evaluateJavaScript:jsString completionHandler:nil];
        }
        else if (self.webView) {
            [self.webView stringByEvaluatingJavaScriptFromString:jsString];
        }
    });

}
@end


#pragma mark --
#pragma mark -- UIWebView
@implementation  HybridJsBridge(UIWebView)

- (void) invoke:(NSString *) method args:(NSString *) args {
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[args?: @"{}" dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    [self __invoke:method args:dict];
}

@end

#pragma mark --
#pragma mark -- WKWebView
@implementation  HybridJsBridge(WKWebView)

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[message.body?: @"{}" dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    [self __invoke:dict[@"methodName"] args:dict[@"args"]];
}

@end
