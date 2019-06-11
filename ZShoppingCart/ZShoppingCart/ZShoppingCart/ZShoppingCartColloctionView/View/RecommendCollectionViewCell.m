//
//  RecommendCollectionViewCell.m
//  ZShoppingCart
//
//  Created by AlexZhang on 23/11/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import "RecommendCollectionViewCell.h"

@implementation RecommendCollectionViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 101, 144);
        self.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.label];
        self.layer.borderColor = [UIColor purpleColor].CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
        _label.textColor = [UIColor blackColor];
        _label.tag = 1000;
    }
    return _label;
}


@end
