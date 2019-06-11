//
//  HybridImagePickerOptions.h
//  GoldHybridFramework
//
//  Created by WSCN on 01/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HybridJsBridge.h"

@interface HybridImagePickerOptions : NSObject

typedef NS_ENUM(NSInteger, HybridPhotoEncodingType){
    HybridPhotoEncodingTypeJPEG = 0,
    HybridPhotoEncodingTypePNG
};

typedef NS_ENUM(NSInteger, HybridCameraDirection){
    HybridCameraDirectionBack = 0,
    HybridCameraDirectionFront
};

typedef NS_ENUM(NSInteger, HybridPhotoMediaType){
    HybridPhotoMediaTypePicture = (1 << 0),
    HybridPhotoMediaTypeVideo = (1 << 1),
    HybridPhotoMediaTypeAll = (1 << 2)
};

typedef NS_ENUM(NSInteger, HybridPhotoSourceType){
    HybridPhotoSourceTypeUndefined = 0,
    HybridPhotoSourceTypePhotoLibrary,
    HybridPhotoSourceTypeCamera
};

typedef NS_ENUM(NSInteger, HybridPhotoOutputType){
    HybridPhotoOutputTypeData = 0,
    HybridPhotoOutputTypeURL
};

@property (nonatomic, assign) BOOL allowEdit;
@property (nonatomic, assign) HybridPhotoEncodingType encodingType;
@property (nonatomic, assign) BOOL saveToPhotoAlbum;
@property (nonatomic, assign) NSUInteger targetWidth;
@property (nonatomic, assign) NSUInteger targetHeight;
@property (nonatomic, assign) HybridCameraDirection cameraDirection;
@property (nonatomic, assign) HybridPhotoMediaType mediaType;
@property (nonatomic, assign) NSUInteger quality;                    //0 - 100
@property (nonatomic, assign) HybridPhotoSourceType sourceType;
@property (nonatomic, assign) HybridPhotoOutputType outputType;

@property (nonatomic, copy) NSString *callbackId;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (UIImagePickerControllerSourceType) hybridImagePickerSourceType;
- (UIImagePickerControllerCameraDevice) cameraDevice;
- (NSArray *) pickerControlerMediaTypesForSourceType:(UIImagePickerControllerSourceType)sourceType;
- (UIImagePickerControllerCameraCaptureMode) cameraCaptureModeForDevice:(UIImagePickerControllerCameraDevice)device;
- (UIImagePickerControllerQualityType) pickerControllerQualityType;
@end
