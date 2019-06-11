//
//  HybridJsManager+Camera.h
//  GoldHybridFramework
//
//  Created by WSCN on 01/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "GoldHybridFramework.h"
#import "HybridImagePickerViewController.h"

@interface HybridJsManager (Camera)<HybridImagePickerViewControllerDelegate>

- (void) registerJs_camera_getPicture;

@end
