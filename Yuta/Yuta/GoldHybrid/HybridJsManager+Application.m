//
//  HybridJsManager+Application.m
//  GoldHybridFramework
//
//  Created by Micker on 16/9/7.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import "HybridJsManager+Application.h"
#import "sys/utsname.h"
#import "WKViewController.h"

@implementation HybridJsManager (Application)

- (NSString *)currentVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (BOOL)deviceIsVirtual {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (NSString *)deviceIdfa{
    return [[NSUUID UUID] UUIDString];
}

- (NSString *) deviceSystemVersion{
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)deviceModel {
    struct utsname systemInfo;
    uname (&systemInfo);
    return [NSString stringWithCString :systemInfo.machine encoding : NSUTF8StringEncoding ];
}

- (NSDictionary *)deviceInfo {
    return @{@"isVirtual" : [NSNumber numberWithBool:[self deviceIsVirtual]],
             @"manufacturer" : @"Apple",
             @"model" : [self deviceModel],
             @"native_version" : [self currentVersion],
             @"platform" : @"iOS",
             @"uuid": [self deviceIdfa],
             @"version" : [self deviceSystemVersion]};
}

- (void) registerJs_getCurrentVersion{
    [self registerJsApi:[HybridJsApi jsapi:@"getCurrentVersion"
                                   handler:^(NSDictionary *data, HybridContext *context, JSApiHandlerReponseCallBack responseCallBack)
    {
        NSDictionary *dictionary = @{@"value":[self currentVersion]};
        !responseCallBack?:responseCallBack(dictionary);
    }]];
}

- (void) registerJs_properties {
    [self registerJsApi:[HybridJsApi jsapi:@"device_getProperties"
                                   handler:^(NSDictionary *data, HybridContext *context, JSApiHandlerReponseCallBack responseCallBack)
                         {
                             NSDictionary *dictionary = [self deviceInfo];
                             !responseCallBack?:responseCallBack(dictionary);
                         }]];

}

- (void) registerJs_openURL {
    [self registerJsApi:[HybridJsApi jsapi:@"openURL"
                                   handler:^(NSDictionary *data, HybridContext *context, JSApiHandlerReponseCallBack responseCallBack)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data[@"url"]]];
    }]];
}

- (void) registerJs_webView_open {
    [self registerJsApi:[HybridJsApi jsapi:@"webview_open"
                                   handler:^(NSDictionary *data, HybridContext *context, JSApiHandlerReponseCallBack responseCallBack)
                         {
                             NSString *url = [data valueForKey:@"url"];
                             NSString *agent = [data valueForKey:@"agent"];
                             if ([url length] > 0) {
                                 if (agent) {
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
                                 } else {
                                     WKViewController *wkVC = [[WKViewController alloc] init];
                                     [wkVC loadWebWithURL:url];
                                     
                                     UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
                                     [vc presentViewController:wkVC animated:YES completion:nil];
                                 }
                             }
                         }]];
}

@end
