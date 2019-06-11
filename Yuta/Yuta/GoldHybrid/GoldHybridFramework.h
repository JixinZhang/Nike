//
//  GoldHybridFramework.h
//  GoldHybridFramework
//
//  Created by Micker on 16/9/5.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for GoldHybridFramework.
FOUNDATION_EXPORT double GoldHybridFrameworkVersionNumber;

//! Project version string for GoldHybridFramework.
FOUNDATION_EXPORT const unsigned char GoldHybridFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GoldHybridFramework/PublicHeader.h>

#if __has_include(<GoldHybridFramework/GoldHybridFramework.h>)

#import <GoldHybridFramework/NSDictionary+HybridContext.h>
#import <GoldHybridFramework/HybridJsApi.h>
#import <GoldHybridFramework/HybridJsApiHandler.h>
#import <GoldHybridFramework/HybridJsBridge.h>
#import <GoldHybridFramework/HybridJsManager.h>

#else

#import "NSDictionary+HybridContext.h"
#import "HybridJsApi.h"
#import "HybridJsApiHandler.h"
#import "HybridJsBridge.h"
#import "HybridJsManager.h"

#endif
