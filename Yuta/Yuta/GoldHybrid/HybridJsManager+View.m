//
//  HybridJsManager+View.m
//  GoldHybridFramework
//
//  Created by Micker on 16/9/7.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import "HybridJsManager+View.h"

@implementation HybridJsManager (View)

- (void) registerJs_dialogs_alert {
    
    [self registerJsApi:[HybridJsApi jsapi:@"dialogs_alert"
                                   handler:^(NSDictionary *data, HybridContext *context, JSApiHandlerReponseCallBack responseCallBack)
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:data[@"title"]
                                                                                 message:data[@"message"]
                                                                                delegate:nil
                                                                       cancelButtonTitle:data[@"cancel"]?@"取消":nil
                                                                       otherButtonTitles:data[@"okButtonName"]?:@"确定", nil];
                             [alertView show];
                         }]];
}

- (void) registerJs_dialogs_confirm {
    
    [self registerJsApi:[HybridJsApi jsapi:@"dialogs_confirm"
                                   handler:^(NSDictionary *data, HybridContext *context, JSApiHandlerReponseCallBack responseCallBack)
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:data[@"title"]
                                                                                 message:data[@"message"]
                                                                                delegate:nil
                                                                       cancelButtonTitle:data[@"cancel"]?:@"取消"
                                                                       otherButtonTitles:data[@"okButtonName"]?:@"确定", nil];
                             [alertView show];
                         }]];
}

@end
