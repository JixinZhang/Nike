//
//  HybridJsApiHandler.m
//  B5MHybridFramework
//
//  Created by Micker on 15/11/9.
//  Copyright © 2015年 Micker. All rights reserved.
//

#import "HybridJsApiHandler.h"
#import <GoldLogFramework/GoldLogFramework.h>
@implementation HybridJsApiHandler

- (void) handler:(NSDictionary *) data  context:(HybridContext *) context callBack:(JSApiHandlerReponseCallBack) callBack {
    DEBUGLOG(@"jsapi handle data = %@", data);
}

@end
