//
//  GoldLogFramework.h
//  GoldLogFramework
//
//  Created by Micker on 16/5/11.
//  Copyright © 2016年 wallstreetcn. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for GoldLogFramework.
FOUNDATION_EXPORT double GoldLogFrameworkVersionNumber;

//! Project version string for GoldLogFramework.
FOUNDATION_EXPORT const unsigned char GoldLogFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GoldLogFramework/PublicHeader.h>


#if __has_include(<GoldLogFramework/GoldLogFramework.h>)

#import <GoldLogFramework/GoldLog.h>

#else

#import "GoldLog.h"

#endif