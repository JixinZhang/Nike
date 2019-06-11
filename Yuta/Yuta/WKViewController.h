//
//  WKViewController.h
//  GoldHybridFramework
//
//  Created by Micker on 16/9/6.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface WKViewController : UIViewController

- (void)loadWebWithURL:(NSString *)url;

@end
