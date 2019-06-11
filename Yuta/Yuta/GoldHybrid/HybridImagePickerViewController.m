//
//  HybridImagePickerViewController.m
//  GoldHybridFramework
//
//  Created by WSCN on 01/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "HybridImagePickerViewController.h"
#import "HybridImageClipView.h"
#import "UIImage+HybrideImage.h"
#import <GoldLogFramework/GoldLogFramework.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HybridImagePickerViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIImage *shootImage;
@property (nonatomic, strong) UIToolbar* toolBar;
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UIImageView *shootImageView;
@property (nonatomic, strong) HybridImageClipView *clipView;
@property (nonatomic, assign) BOOL showOverlayView;

@end

@implementation HybridImagePickerViewController

- (instancetype)initWithCameraOptions:(HybridImagePickerOptions *)options {
    self = [super init];
    if (self) {
        self.options = options;
        self.sourceType = [self.options hybridImagePickerSourceType];
        self.allowsEditing = self.options.allowEdit;
        
        UIImagePickerControllerCameraDevice device = [self.options cameraDevice];
        if (self.sourceType == UIImagePickerControllerSourceTypeCamera && device >= 0){
            self.cameraDevice = device;
            NSArray* mediaTypes = [self.options pickerControlerMediaTypesForSourceType:self.sourceType];
            if (mediaTypes.count > 0){
                self.mediaTypes = mediaTypes;
            }
            self.cameraCaptureMode = [self.options cameraCaptureModeForDevice:device];
            self.videoQuality = [self.options pickerControllerQualityType];
            if (self.options.targetHeight > 0 && self.options.targetWidth > 0){
                self.showOverlayView = YES;
                self.showsCameraControls = NO;
            } else {
                self.showOverlayView = NO;
            }
        }
    }
    return self;
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}

- (UIView *)borderView {
    if (!_borderView) {
        CGFloat scale = [UIScreen mainScreen].scale;
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.options.targetWidth / scale, self.options.targetHeight / scale)];
        _borderView.userInteractionEnabled = NO;
        _borderView.layer.borderWidth = 2.0f;
        _borderView.layer.borderColor = [UIColor greenColor].CGColor;
        _borderView.center = CGPointMake(self.overlayView.bounds.size.width / 2, self.overlayView.bounds.size.width / 0.75 / 2);
    }
    return _borderView;
}

- (UIImageView *)shootImageView {
    if (!_shootImageView) {
        _shootImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.borderView.bounds, 2, 2)];
    }
    return _shootImageView;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 55)];
        _toolBar.barStyle = UIBarStyleBlackOpaque;
        [_toolBar setItems:[self photoToolBarItemsWhen:NO]];
    }
    return _toolBar;
}

- (UIView *)naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 20, 44, 44);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelOverlayViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:cancelButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(kScreenWidth - 44, 20, 44, 44);
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:confirmButton];
        
        _naviView.backgroundColor = [UIColor blackColor];
        _naviView.hidden = YES;
    }
    return _naviView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self __setup];
}

- (void)__setup {
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera &&
        self.showOverlayView) {
        [self.overlayView addSubview:self.toolBar];
        [self.overlayView addSubview:self.borderView];
        self.cameraOverlayView = self.overlayView;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([self.jsImagePickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:userInfo:)]){
        [self.jsImagePickerDelegate imagePickerControllerDidCancel:self userInfo:self.options];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        picker.delegate = nil;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.showOverlayView) {
        self.overlayView.backgroundColor = [UIColor blackColor];
        CGFloat scale = [UIScreen mainScreen].scale;
        UIImage *editImage = [originImage fixedOrientationImage];
        CGFloat editImageScale = editImage.size.width / editImage.size.height;
        
        CGRect cropFrame;
        if (editImageScale <= 1) {
            //宽<=高
            cropFrame.size.width = ((self.options.targetWidth / scale * editImage.size.width) /kScreenWidth);
            cropFrame.size.height = ((self.options.targetHeight / scale * editImage.size.height) / (kScreenWidth / editImageScale));
        } else {
            //宽>高
            cropFrame.size.width = ((self.options.targetHeight / scale * editImage.size.height) / (kScreenWidth / editImageScale));
            cropFrame.size.height = ((self.options.targetWidth / scale * editImage.size.width) /kScreenWidth);
            
            CGRect borderViewFrame = self.borderView.frame;
            borderViewFrame.size.width = self.options.targetHeight / scale;
            borderViewFrame.size.height = self.options.targetWidth / scale;
            borderViewFrame.origin.x = (kScreenWidth - borderViewFrame.size.width) / 2 ;
            borderViewFrame.origin.y = (kScreenWidth -  (self.overlayView.bounds.size.width / editImageScale) / 2);
            self.borderView.frame = borderViewFrame;
            self.borderView.frame = borderViewFrame;

        }
        cropFrame.origin.x = (editImage.size.width - cropFrame.size.width) / 2;
        cropFrame.origin.y = (editImage.size.height - cropFrame.size.height) / 2;

        UIImage* image = [editImage subImageWithRect:cropFrame];
        self.shootImageView.image = image;
        [self.borderView addSubview:self.shootImageView];
        CGFloat xFactor = image.size.width / (self.borderView.bounds.size.width * scale);
        image = [image setImageWithScaleToSize:CGSizeMake(self.borderView.bounds.size.width * scale, image.size.height / xFactor)];
        self.shootImage = image;
        self.toolBar.items = [self photoToolBarItemsWhen:YES];
    } else {
        //不裁剪图片
        if (self.allowsEditing) {
            self.shootImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            self.shootImage = originImage;
        }
        self.shootImage = [self.shootImage fixedOrientationImage];
        [self setupOverlayAndClipView];
    }
}

#pragma mark - 裁剪从相册获取的图片

- (void)setupOverlayAndClipView {
    self.shootImageView.image = self.shootImage;
    CGFloat rate = self.shootImage.size.width / kScreenWidth;
    CGFloat height = self.shootImage.size.height / rate;
    self.shootImageView.frame = CGRectMake(0, (kScreenHeight - height) / 2, kScreenWidth, height);
    [self.overlayView addSubview:self.shootImageView];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize clipSize = CGSizeMake(self.options.targetWidth / scale, self.options.targetHeight / scale);
    self.clipView = [[HybridImageClipView alloc] initWithImageView:self.shootImageView
                                                          clipSize:clipSize];
    [self.overlayView addSubview:self.clipView];
    
    __weak typeof (self)weakSelf = self;
    self.clipView.clipViewTapBlock = ^(){
        weakSelf.naviView.hidden = !weakSelf.naviView.hidden;
    };
    self.naviView.hidden = NO;
    [self.overlayView addSubview:self.naviView];
    
    self.overlayView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.overlayView];
}

- (IBAction)cancelOverlayViewAction:(id)sender {
    [self.overlayView removeFromSuperview];
}

- (IBAction)confirmButtonAction:(id)sender {
    self.shootImage = [self.clipView getClipImage];
    [self prepareForUsePicture];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (NSData *) imageDataForShootImage{
    switch (self.options.outputType) {
        case HybridPhotoOutputTypeData:
            break;
            
        default:
            break;
    }
    NSData* data = nil;
    NSString* encodingTypeString = nil;
    switch (self.options.encodingType) {
        case HybridPhotoEncodingTypeJPEG:
            encodingTypeString = @"jpg";
            data = UIImageJPEGRepresentation(self.shootImage, self.options.quality / 100);
            break;
            
        case HybridPhotoEncodingTypePNG:
            encodingTypeString = @"png";
            data = UIImagePNGRepresentation(self.shootImage);
            break;
            
        default:
            break;
    }
    return data;
}

#pragma mark - toolbar for camera

- (NSArray *) photoToolBarItemsWhen:(BOOL)hasTakePicture{
    if (hasTakePicture){
        return [NSArray arrayWithObjects:
                [[UIBarButtonItem alloc] initWithTitle:@"重拍" style:UIBarButtonItemStyleDone target:self action:@selector(retakePictureButtonClicked:)],
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                [[UIBarButtonItem alloc] initWithTitle:@"使用" style:UIBarButtonItemStyleDone target:self action:@selector(usePictureButtonClicked:)],
                nil];
    }
    else{
        return [NSArray arrayWithObjects:
                [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClicked:)],
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                [[UIBarButtonItem alloc] initWithTitle:@"拍照" style:UIBarButtonItemStyleDone target:self action:@selector(takePictureButtonClicked:)],
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                [[UIBarButtonItem alloc] initWithTitle:@"翻转" style:UIBarButtonItemStyleDone target:self action:@selector(switchCamera:)],
                nil];
    }
}

#pragma mark - button action

- (void) retakePictureButtonClicked:(id)sender{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect borderViewFrame = self.borderView.frame;
    borderViewFrame.size.width = self.options.targetWidth / scale;
    borderViewFrame.size.height = self.options.targetHeight / scale;
    self.borderView.frame = borderViewFrame;
    self.borderView.center = CGPointMake(self.overlayView.bounds.size.width / 2, self.overlayView.bounds.size.width / 0.75 / 2);
    self.overlayView.backgroundColor = [UIColor clearColor];
    self.shootImageView.image = nil;
    self.toolBar.items = [self photoToolBarItemsWhen:NO];
}

- (void) takePictureButtonClicked:(id)sender{
    [self takePicture];
}

- (void) usePictureButtonClicked:(id)sender{
    [self prepareForUsePicture];
    [self dismissViewControllerAnimated:YES completion:^{
        self.delegate = nil;
    }];
}

- (void) switchCamera:(id)sender{
    if (self.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

- (void) cancelButtonClicked:(id)sender{
    
    if ([self.jsImagePickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:userInfo:)]){
        [self.jsImagePickerDelegate imagePickerControllerDidCancel:self userInfo:self.options];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        self.delegate = nil;
    }];
}

- (void) prepareForUsePicture{
    if (self.options.sourceType != HybridPhotoSourceTypePhotoLibrary && self.options.saveToPhotoAlbum) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(self.shootImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    }
    NSData *imageData = [self imageDataForShootImage];
    if ([self.jsImagePickerDelegate respondsToSelector:@selector(imagePickerController:didTakeImage:userInfo:)]){
        [self.jsImagePickerDelegate imagePickerController:self didTakeImage:imageData userInfo:self.options];
    }
}

#pragma mark - save picture result

- (void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            DEBUGLOG(@"保存到相册成功");
        });
    }
}

@end
