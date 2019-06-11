//
//  HybridJsManager+Camera.m
//  GoldHybridFramework
//
//  Created by WSCN on 01/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "HybridJsManager+Camera.h"
#import "HybridImagePickerViewController.h"

@implementation HybridJsManager (Camera)

- (void) registerJs_camera_getPicture {
    __weak typeof (self)weakSelf = self;
    [self registerJsApi:[HybridJsApi jsapi:@"camera_getPicture"
                                   handler:^(NSDictionary *data, HybridContext *context, JSApiHandlerReponseCallBack responseCallBack)
                         {
                             if (!data) {
                                 return ;
                             }
                             [weakSelf setupHybridImagePickerWithData:data
                                                              context:context
                                                     responseCallBack:responseCallBack];
                         }]];
}

- (void)registerJs_load_loadImage {
    __weak typeof (self)weakSelf = self;
    [self registerJsApi:[HybridJsApi jsapi:@"load_loadImage"
                                   handler:^(NSDictionary *data, HybridContext *context, JSApiHandlerReponseCallBack responseCallBack) {
                                       NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                                       [dictionary setValue:@"success" forKey:@"message"];
//                                       [dictionary setValue:@{@"data":[NSString stringWithFormat:@"file:/\/\/%@",path]} forKey:@"results"];

                                   }]];
    
}

- (void) setupHybridImagePickerWithData:(NSDictionary *)data
                                context:(HybridContext *)context
                       responseCallBack:(JSApiHandlerReponseCallBack)responseCallBack {
    HybridJsBridge *bridge = [context bridge];
    UIViewController *controller = [bridge controller];
    __block HybridImagePickerOptions *imagePickerOptions = [[HybridImagePickerOptions alloc] initWithDictionary:data];
    if (imagePickerOptions.sourceType == HybridPhotoSourceTypeUndefined) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"相机"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
        {
            imagePickerOptions.sourceType = HybridPhotoSourceTypeCamera;
            HybridImagePickerViewController *imagePicker = [[HybridImagePickerViewController alloc] initWithCameraOptions:imagePickerOptions];
            imagePicker.jsImagePickerDelegate = self;
            imagePicker.bridge = bridge;
            [controller presentViewController:imagePicker animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"相册"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
        {
            imagePickerOptions.sourceType = HybridPhotoSourceTypePhotoLibrary;
            HybridImagePickerViewController *imagePicker = [[HybridImagePickerViewController alloc] initWithCameraOptions:imagePickerOptions];
            imagePicker.jsImagePickerDelegate = self;
            imagePicker.bridge = bridge;
            [controller presentViewController:imagePicker animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        [controller presentViewController:alertController animated:YES completion:nil];
    } else {
        HybridImagePickerViewController *imagePicker = [[HybridImagePickerViewController alloc] initWithCameraOptions:imagePickerOptions];
        imagePicker.jsImagePickerDelegate = self;
        imagePicker.bridge = bridge;
        [controller presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void) imagePickerControllerDidCancel:(HybridImagePickerViewController *)controller userInfo:(HybridImagePickerOptions *)userInfo {

}

- (void) imagePickerController:(HybridImagePickerViewController *)controller didTakeImage:(NSData *)imageData userInfo:(HybridImagePickerOptions *)userInfo {
    NSString* base64Data = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *results = @{@"data" : [NSString stringWithFormat:@"%@",base64Data],
                              @"type" : (userInfo.encodingType == HybridPhotoEncodingTypeJPEG ? @"jpeg" : @"png")};
    NSDictionary* callbackInfo = @{@"message" : @"success",
                                   @"results" : results};
    [controller.bridge invokeCallBackId:controller.options.callbackId response:callbackInfo];
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
