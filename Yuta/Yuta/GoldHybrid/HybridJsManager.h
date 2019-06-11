//
//  HybridJsManager.h
//  B5MHybridFramework
//
//  Created by Micker on 15/11/20.
//  Copyright © 2015年 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HybridJsApi.h"

@interface HybridJsManager : NSObject

+ (instancetype) sharedHybridManager;

- (void) start;

- (void) registerJsApi:(HybridJsApi *) jsapi;

- (void) registerJsApi:(HybridJsApi *) jsapi groupId:(NSString *) groupId;

- (void) registerJsApis:(NSArray *) jsapis;

- (void) registerJsApis:(NSArray *) jsapis groupId:(NSString *) groupId;

- (void) unRegisterJsApis:(NSString *) groupId;

- (NSArray *) jsApis;

- (NSArray *) jsApis:(NSString *)groupId;

- (HybridJsApi *) jsApi:(NSString *) name;

- (HybridJsApi *) jsApi:(NSString *)name groupId:(NSString *) groupdId;

#pragma mark

- (HybridJsApi *) jsApiHandler:(NSString *) name;

@end
