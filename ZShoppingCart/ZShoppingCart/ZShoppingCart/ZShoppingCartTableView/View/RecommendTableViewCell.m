//
//  RecommendTableViewCell.m
//  ZShoppingCart
//
//  Created by AlexZhang on 11/12/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import "RecommendTableViewCell.h"

@interface RecommendTableViewCellItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation RecommendTableViewCellItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.borderColor = [UIColor purpleColor].CGColor;
        self.layer.borderWidth = 0.5;
        [self addSubview:self.titleLabel];
        
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.bounds), 20)];
    }
    return _titleLabel;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
    }
    return _tapGesture;
}

- (void)itemTapped:(UITapGestureRecognizer *)tapped {
    NSLog(@"tapped");
}

@end

@interface RecommendTableViewCell()

@property (nonatomic, strong) RecommendTableViewCellItemView *leftItemView;
@property (nonatomic, strong) RecommendTableViewCellItemView *middleItemView;
@property (nonatomic, strong) RecommendTableViewCellItemView *rightItemView;
@property (nonatomic, assign) CGFloat cellNumerPerRow;

@end

@implementation RecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (KScreenWidth <768) {
            self.cellNumerPerRow = 3.0;
        } else if (KScreenWidth < 1024) {
            self.cellNumerPerRow = 5.0;
        } else {
            self.cellNumerPerRow = 6.0;
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (RecommendTableViewCellItemView *)itemViewWithFrame:(CGRect)frame {
    RecommendTableViewCellItemView *itemView = [[RecommendTableViewCellItemView alloc] initWithFrame:frame];
    return itemView;
}

- (void)setContentWithModel:(NSArray *)array row:(NSUInteger)row {
    if (!array.count) {
        return;
    }
    
    CGFloat marginLeft = (KScreenWidth - kRecommendWidth * self.cellNumerPerRow) / (self.cellNumerPerRow + 1);
    CGFloat x = marginLeft;
    CGFloat y = 0;
    CGFloat width = kRecommendWidth;
    CGFloat height = kRecommendHeight;
    
    for (NSUInteger index = 0; index < array.count; index++) {
        x = index % (NSInteger)self.cellNumerPerRow * kRecommendWidth + (index % (NSInteger)self.cellNumerPerRow + 1) * marginLeft;
        RecommendTableViewCellItemView *view = [self itemViewWithFrame:CGRectMake(x, y, width, height)];
        view.titleLabel.text = [NSString stringWithFormat:@"(%ld,%ld)", (long)row, (long)index];
        [self.contentView addSubview:view];
    }
}

@end
