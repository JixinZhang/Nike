//
//  HybridImageClipView.h
//  GoldHybridFramework
//
//  Created by WSCN on 21/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClipViewTapBlock)();

@interface HybridImageClipView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect clipRect;
@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, copy) ClipViewTapBlock clipViewTapBlock;

- (instancetype)initWithImageView:(UIImageView *)imageView clipSize:(CGSize)clipSize;

/**
 获取裁剪区域的图图片

 @return 裁剪后的图片
 */
- (UIImage *)getClipImage;

@end
