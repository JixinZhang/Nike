//
//  HybridImageClipView.m
//  GoldHybridFramework
//
//  Created by WSCN on 21/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "HybridImageClipView.h"
#import "UIImage+HybrideImage.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HybridImageClipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithImageView:(UIImageView *)imageView clipSize:(CGSize)clipSize {
    CGRect imageViewRect = imageView.frame;
    self = [super initWithFrame:imageViewRect];
    if (self) {
        self.imageView = imageView;
        self.clipRect = CGRectMake((imageViewRect.size.width - clipSize.width) / 2, (imageViewRect.size.height - clipSize.height) / 2, clipSize.width, clipSize.height);
        self.touchPoint = CGPointZero;
        [self setupClipView];
    }
    return self;
}

- (void) setupClipView {
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clipViewTap:)]];
}

- (void)drawRect:(CGRect)rect {
    CGColorRef grayAlpha = [[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.6] CGColor];
    CGContextRef context=UIGraphicsGetCurrentContext();
    //绘制剪裁区域外半透明效果
    CGContextSetFillColorWithColor(context, grayAlpha);
    CGRect r = CGRectMake(0, 0, rect.size.width, self.clipRect.origin.y);
    CGContextFillRect(context, r);
    r = CGRectMake(0, self.clipRect.origin.y, self.clipRect.origin.x, self.clipRect.size.height);
    CGContextFillRect(context, r);
    r = CGRectMake(self.clipRect.origin.x + self.clipRect.size.width, self.clipRect.origin.y, rect.size.width - self.clipRect.origin.x - self.clipRect.size.width, self.clipRect.size.height);
    CGContextFillRect(context, r);
    r = CGRectMake(0, self.clipRect.origin.y + self.clipRect.size.height, rect.size.width, rect.size.height - self.clipRect.origin.y - self.clipRect.size.height);
    CGContextFillRect(context, r);
    
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 0.8f);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddRect(context, self.clipRect);
    CGContextStrokePath(context);
}

- (UIImage *)getClipImage {
    UIImage *originImage  = self.imageView.image;
    CGFloat rate = originImage.size.width / kScreenWidth;
    CGRect rect = CGRectMake(self.clipRect.origin.x * rate, self.clipRect.origin.y * rate, self.clipRect.size.width * rate, self.clipRect.size.height * rate);
    CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, rect);
    UIImage *image = [[UIImage alloc]initWithCGImage:imageRef];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    image = [image setImageWithScaleToSize:CGSizeMake(self.clipRect.size.width * scale, self.clipRect.size.height * scale)];
    return image;
}

#pragma mark - TapGesture

- (void)clipViewTap:(UITapGestureRecognizer *)tap {
    if (self.clipViewTapBlock) {
        self.clipViewTapBlock();
    }
}

#pragma mark - Touchs methods


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect originRect = self.clipRect;
    
    if (point.x >= originRect.origin.x &&
        point.y >= originRect.origin.y &&
        point.x <= CGRectGetMaxX(originRect) &&
        point.y <= CGRectGetMaxY(originRect)) {
        self.clipRect = CGRectMake(point.x - originRect.size.width / 2, point.y - originRect.size.height / 2, originRect.size.width, originRect.size.height);
        [self setNeedsDisplay];
    }
}

@end
