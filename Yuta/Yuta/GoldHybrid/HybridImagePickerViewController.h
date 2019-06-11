//
//  HybridImagePickerViewController.h
//  GoldHybridFramework
//
//  Created by WSCN on 01/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HybridImagePickerOptions.h"

typedef void (^HybridImagePickerBlock)(id response);

@class HybridImagePickerViewController;

@protocol HybridImagePickerViewControllerDelegate <NSObject>

@optional

- (void) imagePickerController:(HybridImagePickerViewController *)controller didTakeImage:(NSData *)imageData userInfo:(HybridImagePickerOptions *)userInfo;

- (void) imagePickerControllerDidCancel:(HybridImagePickerViewController *)controller userInfo:(HybridImagePickerOptions *)userInfo;

@end


@interface HybridImagePickerViewController : UIImagePickerController

@property (nonatomic, strong) HybridImagePickerOptions *options;
@property (nonatomic, strong) HybridJsBridge *bridge;
@property (nonatomic, copy) HybridImagePickerBlock block;
@property (nonatomic, weak) id<HybridImagePickerViewControllerDelegate> jsImagePickerDelegate;

- (instancetype)initWithCameraOptions:(HybridImagePickerOptions *)options;

@end
