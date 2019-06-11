//
//  HybridJsApiHandler.h
//  B5MHybridFramework
//
//  Created by Micker on 15/11/9.
//  Copyright © 2015年 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HybridJsApi.h"

@interface HybridJsApiHandler : NSObject

- (void) handler:(NSDictionary *) data context:(HybridContext *) context callBack:(JSApiHandlerReponseCallBack) callBack;

@end
