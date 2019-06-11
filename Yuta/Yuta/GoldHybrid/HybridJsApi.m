//
//  HybridJsApi.m
//  B5MHybridFramework
//
//  Created by Micker on 15/11/5.
//  Copyright © 2015年 Micker. All rights reserved.
//

#import "HybridJsApi.h"
#import <GoldLogFramework/GoldLogFramework.h>

@interface HybridJsApi() {
    id _handlerObject;
}

@end

@implementation HybridJsApi

+ (instancetype) jsapi:(NSString *) name handler:(JSApiHandlerBlock) block{
    HybridJsApi *jsapi = [[HybridJsApi alloc] init];
    [jsapi setValue:name forKey:@"name"];
    [jsapi setValue:[block copy] forKey:@"block"];
    return jsapi;
}

+ (instancetype) jsapi:(NSString *) name handlerCls:(Class) cls {
    HybridJsApi *jsapi = [[HybridJsApi alloc] init];
    [jsapi setValue:name forKey:@"name"];
    [jsapi setValue:cls forKey:@"handleCls"];
    return jsapi;
}

- (void) handler:(NSDictionary *) data  context:(HybridContext *) context callBack:(JSApiHandlerReponseCallBack) callBack {
//    INFOLOG(@"%@, data = %@", [self debugDescription], data);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.block) {
            self.block(data, context, callBack);
        }
        else {
            if (!_handlerObject)
                _handlerObject = [[self.handleCls alloc] init];
            [_handlerObject handler:data context:context callBack:callBack];
        }
    });
}

- (void) dealloc {
    _block = nil;
}

- (NSString *) debugDescription {
    return [NSString stringWithFormat:@"jsapi name:%@, block:%@, handler:%@", self.name, self.block ? @"set" : @"null", NSStringFromClass(self.handleCls)];
}

@end
