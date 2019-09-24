//
//  WKWebViewMessageHandler.m
//  Yuta
//
//  Created by zjixin on 2019/9/20.
//  Copyright © 2019 wallstreetcn.com. All rights reserved.
//

#import "WKWebViewMessageHandler.h"

@implementation WKWebViewMessageHandler

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        self.scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
