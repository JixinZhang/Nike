//
//  HybridJsManager.m
//  B5MHybridFramework
//
//  Created by Micker on 15/11/20.
//  Copyright © 2015年 Micker. All rights reserved.
//

#import "HybridJsManager.h"
#import "HybridJsApi.h"
#import <objc/runtime.h>
#import <GoldLogFramework/GoldLogFramework.h>

#define kHybridDefaultJsApi     @"kHybridDefaultJsApi"

@interface HybridJsManager()

@property (nonatomic, strong) NSMutableDictionary *internelJsApis;

@end

@implementation HybridJsManager

+ (instancetype) sharedHybridManager {
    static HybridJsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HybridJsManager alloc] init];
    });
    return instance;
}

- (NSMutableDictionary *) internelJsApis {
    if (!_internelJsApis) {
        _internelJsApis = [NSMutableDictionary dictionary];
    }
    return _internelJsApis;
}

- (void) start {
    //TODO read default jsapi 、 plugin from plist files
//    [self registerJsApi:[HybridJsApi jsapi:@"checkIsLogined" handlerCls:NSClassFromString(@"JsApiHandlerForTitle")]];
    if ([_internelJsApis count] > 0) {
        return;
    }
    unsigned int count;
    Method *methods = class_copyMethodList([self class], &count);
    NSUInteger index = 0;
    for (int i = 0; i < count; i++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        if ([name hasPrefix:@"registerJs_"]){
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

            INFOLOG(@"正在注册[%lu]：%@", (unsigned long)++index, name);
            [self performSelector:NSSelectorFromString(name) withObject:nil];

#pragma clang diagnostic pop
        }
    }
}


#pragma mark
#pragma mark jsApi

- (void) registerJsApi:(HybridJsApi *) jsapi {
    [self registerJsApi:jsapi groupId:kHybridDefaultJsApi];
}

- (void) registerJsApi:(HybridJsApi *) jsapi groupId:(NSString *) groupId {
    if (jsapi) {
        [self registerJsApis:@[jsapi] groupId:groupId];
    }
}

- (void) registerJsApis:(NSArray *) jsapis {
    [self registerJsApis:jsapis groupId:kHybridDefaultJsApi];
}

- (void) registerJsApis:(NSArray *) jsapis groupId:(NSString *) groupId {
    if (jsapis && groupId) {
        NSMutableArray *array = [self.internelJsApis valueForKey:groupId];
        if (!array) {
            array = [NSMutableArray array];
            [self.internelJsApis setValue:array forKey:groupId];
        }
        [array addObjectsFromArray:jsapis];
    }
}

- (void) unRegisterJsApis:(NSString *) groupId {
    if (groupId) {
        [self.internelJsApis removeObjectForKey:groupId];
    }
}

- (NSArray *) jsApis {
    return [self.internelJsApis valueForKey:kHybridDefaultJsApi];
}

- (NSArray *) jsApis:(NSString *)groupId {
    return [self.internelJsApis valueForKey:groupId];
}

- (HybridJsApi *) jsApi:(NSString *) name {
    return [self jsApi:name groupId:kHybridDefaultJsApi];
}

- (HybridJsApi *) jsApi:(NSString *)name groupId:(NSString *) groupdId {
    NSMutableArray *array = [self.internelJsApis valueForKey:groupdId];
    __block HybridJsApi * jsApi = nil;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HybridJsApi *temp = (HybridJsApi *) obj;
        if ([temp.name isEqualToString:name]) {
            jsApi = temp;
            *stop = YES;
        }
    }];
    return jsApi;
}

- (HybridJsApi *) jsApiHandler:(NSString *) name {
    __block HybridJsApi *jsapi = [self jsApi:name];
    if (!jsapi) {
        [[self.internelJsApis allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:kHybridDefaultJsApi]) {
                jsapi = [self jsApi:name groupId:obj];
                *stop = jsapi;
            }
        }];
    }
    
    return jsapi;
}
@end




