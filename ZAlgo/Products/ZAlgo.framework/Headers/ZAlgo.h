//
//  ZAlgo.h
//  ZAlgo
//
//  Created by zjixin on 2019/9/19.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ZAlgo.
FOUNDATION_EXPORT double ZAlgoVersionNumber;

//! Project version string for ZAlgo.
FOUNDATION_EXPORT const unsigned char ZAlgoVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ZAlgo/PublicHeader.h>
#if __has_include(<ZAlgo/ZAlgo.h>)

#import <ZAlgo/ZAlgoTreeViewController.h>
#import <ZAlgo/ZAlgoSortViewController.h>
#import <ZAlgo/ZAlgoLinkedListViewController.h>
#import <ZAlgo/ZAlgoStringViewController.h>

#else

#improt "ZAlgoTreeViewController.h"
#import "ZAlgoSortViewController.h"
#import "ZAlgoLinkedListViewController.h"
#import "ZAlgoStringViewController.h"

#endif

