//
//  HybridJsApi.h
//  B5MHybridFramework
//
//  Created by Micker on 15/11/5.
//  Copyright © 2015年 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+HybridContext.h"

typedef void (^JSApiHandlerReponseCallBack)(id response);
typedef void (^JSApiHandlerBlock)(NSDictionary *data , HybridContext * context, JSApiHandlerReponseCallBack responseCallBack);

@interface HybridJsApi : NSObject

@property (nonatomic, readonly, strong) NSString          *name;
@property (nonatomic, readonly, copy  ) JSApiHandlerBlock block;
@property (nonatomic, readonly, assign) Class             handleCls;//HybridJsApiHandler 's sub class

+ (instancetype) jsapi:(NSString *) name handler:(JSApiHandlerBlock) block;

+ (instancetype) jsapi:(NSString *) name handlerCls:(Class) cls;

- (void) handler:(NSDictionary *) data context:(HybridContext *) context callBack:(JSApiHandlerReponseCallBack) callBack;

@end
