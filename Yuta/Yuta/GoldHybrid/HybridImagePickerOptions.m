//
//  HybridImagePickerOptions.m
//  GoldHybridFramework
//
//  Created by WSCN on 01/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "HybridImagePickerOptions.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation HybridImagePickerOptions

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.allowEdit = [[dict valueForKey:@"allowEdit"] boolValue];
        self.saveToPhotoAlbum = [[dict valueForKey:@"saveToPhotoAlbum"] boolValue];
        self.callbackId = [dict valueForKey:@"callbackId"];
        self.cameraDirection = [[dict valueForKey:@"cameraDirection"] integerValue];
        self.sourceType = [[dict valueForKey:@"sourceType"] integerValue];
        self.outputType = [[dict valueForKey:@"destinationType"] integerValue];
        self.encodingType = [[dict valueForKey:@"encodingType"] integerValue];
        self.quality = [[dict valueForKey:@"quality"] integerValue];
        self.targetHeight = [[dict valueForKey:@"targetHeight"] integerValue];
        self.targetWidth = [[dict valueForKey:@"targetWidth"] integerValue];
        
        if ([[dict valueForKey:@"mediaType"] integerValue] == 0) {
            self.mediaType = HybridPhotoMediaTypePicture;
        } else if ([[dict valueForKey:@"mediaType"] integerValue] == 1) {
            self.mediaType = HybridPhotoMediaTypeVideo;
        } else if ([[dict valueForKey:@"mediaType"] integerValue] == 2) {
            self.mediaType = HybridPhotoMediaTypeAll;
        }
    }
    return self;
}

- (UIImagePickerControllerSourceType) hybridImagePickerSourceType {
    UIImagePickerControllerSourceType sourceType = 0;
    switch (self.sourceType) {
        case HybridPhotoSourceTypeCamera:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
            
        default:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]){
        return sourceType;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        return UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return UIImagePickerControllerSourceTypeCamera;
    }
    return -1;
}

- (UIImagePickerControllerCameraDevice) cameraDevice {
    UIImagePickerControllerCameraDevice device = 0;
    switch (self.cameraDirection) {
        case HybridCameraDirectionFront:
            device = UIImagePickerControllerCameraDeviceFront;
            break;
        default:
            device = UIImagePickerControllerCameraDeviceRear;
            break;
    }
    if ([UIImagePickerController isCameraDeviceAvailable:device]){
        return device;
    }
    else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
        return UIImagePickerControllerCameraDeviceRear;
    }
    else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
        return UIImagePickerControllerCameraDeviceFront;
    }
    return -1;
}

- (NSArray *) pickerControlerMediaTypesForSourceType:(UIImagePickerControllerSourceType)sourceType {
    NSMutableArray* mediaTypes = [NSMutableArray array];
    NSArray* aviableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if (self.mediaType & HybridPhotoMediaTypePicture && [aviableMediaTypes containsObject:(NSString *)kUTTypeImage]){
        [mediaTypes addObject:(NSString *)kUTTypeImage];
    }
    
    if (self.mediaType & HybridPhotoMediaTypeVideo && [aviableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
        [mediaTypes addObject:(NSString *)kUTTypeMovie];
    }
    return mediaTypes;
}

- (UIImagePickerControllerCameraCaptureMode) cameraCaptureModeForDevice:(UIImagePickerControllerCameraDevice)device {
    UIImagePickerControllerCameraCaptureMode mode = 0;
    switch (self.mediaType) {
        case HybridPhotoMediaTypeVideo:
            mode = UIImagePickerControllerCameraCaptureModeVideo;
            break;
            
        default:
            mode = UIImagePickerControllerCameraCaptureModePhoto;
            break;
    }
    NSArray* captureModes = [UIImagePickerController availableCaptureModesForCameraDevice:device];
    if (![captureModes containsObject:@(mode)]){
        mode = [[captureModes firstObject] integerValue];;
    }
    
    return mode;
}

- (UIImagePickerControllerQualityType) pickerControllerQualityType {
    if (self.quality < 33){
        return UIImagePickerControllerQualityTypeLow;
    }
    else if (self.quality < 66){
        return UIImagePickerControllerQualityTypeMedium;
    }
    else{
        return UIImagePickerControllerQualityTypeHigh;
    }
}

@end
