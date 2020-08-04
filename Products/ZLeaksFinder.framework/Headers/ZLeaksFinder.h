//
//  ZLeaksFinder.h
//  ZLeaksFinder
//
//  Created by zhangjixin7 on 2020/7/21.
//  Copyright © 2020 jixin. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for ZLeaksFinder.
FOUNDATION_EXPORT double ZLeaksFinderVersionNumber;

//! Project version string for ZLeaksFinder.
FOUNDATION_EXPORT const unsigned char ZLeaksFinderVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ZLeaksFinder/PublicHeader.h>

#if __has_include(<ZLeaksFinder/ZLeaksFinder.h>)

#import <ZLeaksFinder/UIViewController+MemoryLeak.h>
#import <ZLeaksFinder/FBRetainCycleDetector.h>

#else

#import "UIViewController+MemoryLeak.h"
#import "FBRetainCycleDetector.h"

#endif
