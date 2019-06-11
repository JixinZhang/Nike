//
//  UIImage+HybrideImage.h
//  GoldHybridFramework
//
//  Created by WSCN on 21/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HybrideImage)

/**
 放大或缩小图片

 @param size 指定的size
 @return 放大或缩小后的图片
 */
-(UIImage *)setImageWithScaleToSize:(CGSize)size;

/**
 裁剪图片中的指定部分

 @param rect 制定的rect
 @return 裁剪后的图片
 */
-(UIImage *)subImageWithRect:(CGRect)rect;

/**
 修复图拍摄图片会偏转90度

 @return 修正后的图片
 */
- (UIImage *) fixedOrientationImage;
@end
