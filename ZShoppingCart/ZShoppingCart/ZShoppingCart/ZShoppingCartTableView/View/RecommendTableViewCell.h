//
//  RecommendTableViewCell.h
//  ZShoppingCart
//
//  Created by AlexZhang on 11/12/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRecommendWidth 101
#define kRecommendHeight 216
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface RecommendTableViewCell : UITableViewCell

- (void)setContentWithModel:(NSArray *)array row:(NSUInteger)row;

@end
