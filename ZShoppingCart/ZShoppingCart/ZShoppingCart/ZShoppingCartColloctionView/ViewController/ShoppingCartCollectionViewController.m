//
//  ShoppingCartCollectionViewController.m
//  ZShoppingCart
//
//  Created by AlexZhang on 23/11/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import "ShoppingCartCollectionViewController.h"
#import "CommodityCollectionViewCell.h"
#import "RecommendCollectionViewCell.h"
#import "ADHeaderView.h"
#import "ShoppingCartLayout.h"

typedef NS_ENUM(NSInteger, ShoppingCartCellType) {
    ShoppingCartCellTypeCommodity = 0,
    ShoppingCartCellTypeRecommend
};

@interface ShoppingCartCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ShoppingCartLayoutDataSource>
@property (nonatomic, strong) ShoppingCartLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat cellNumerPerRow;

@end

@implementation ShoppingCartCollectionViewController

static NSString * const reuseIdentifierCommodity = @"CommodityCell";
static NSString * const reuseIdentifierRecommend = @"RecommendCell";
static NSString * const reuseIdentifierHeader = @"Header";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ShoppingCart CollectionView";
    [self setContent];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (ShoppingCartLayout *)layout {
    if (!_layout) {
        _layout = [[ShoppingCartLayout alloc] init];
        _layout.dataSource = self;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CommodityCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierCommodity];
        [_collectionView registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierRecommend];
        [_collectionView registerClass:[ADHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:reuseIdentifierHeader];
    }
    return _collectionView;
}

- (void)setContent {
    self.dataArray = [NSMutableArray array];
    NSMutableArray *commodityArray = [NSMutableArray array];
    NSMutableArray *recommendArray = [NSMutableArray array];
    NSInteger rand = random() % 5;
    for (NSInteger index = 0; index < 15; index++) {
        if (index < rand) {
            [commodityArray addObject:@{@"type" : @(ShoppingCartCellTypeCommodity)}];
        } else {
            [recommendArray addObject:@{@"type" : @(ShoppingCartCellTypeRecommend)}];
        }
    }
    [self.dataArray addObject:commodityArray];
    [self.dataArray addObject:recommendArray];
    
    if (KScreenWidth <768) {
        self.cellNumerPerRow = 3.0;
    } else if (KScreenWidth < 1024) {
        self.cellNumerPerRow = 5.0;
    } else {
        self.cellNumerPerRow = 6.0;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor orangeColor];
    }
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    NSDictionary *dict = array[indexPath.row];
    NSNumber *type = [dict objectForKey:@"type"];
    
    UICollectionViewCell *cell;
    if (type.integerValue == ShoppingCartCellTypeRecommend) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierRecommend forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCommodity forIndexPath:indexPath];
    }
    UILabel *label = [cell viewWithTag:1000];
    label.text = [NSString stringWithFormat:@"(%ld, %ld)", indexPath.section, indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>


#pragma mark - ShoppingCartLayoutDataSource


- (CGSize)collectionViewContentSize:(ShoppingCartLayout *)layout {
    if (self.dataArray.count > 2) {
        return CGSizeZero;
    }
    NSArray *commodityArray = self.dataArray.firstObject;
    NSArray *recommendArray = self.dataArray.lastObject;
    NSUInteger commodityCount = commodityArray.count;
    NSUInteger recommendCount = recommendArray.count;
    CGFloat baseY = 0;
    CGFloat height = 0;
    baseY = kHeaderHeight + layout.commodityLineSpacing;
    
    //如果购物车为空，section0只有一个值
    CGFloat commoityHeight = kCommodityHeight;
    commodityCount = commodityCount;
    //section0的全部高度
    CGFloat section1Height = (commodityCount * (commoityHeight + layout.commodityLineSpacing)) + layout.commodityLineSpacing + layout.recommendLineSpacing;
    
    //section1的全部高度
    CGFloat section2Height = 0;
    if (recommendCount) {
        section2Height = kHeaderHeight + layout.recommendLineSpacing + (ceilf(recommendCount/self.cellNumerPerRow) * (kRecommendHeight + layout.recommendLineSpacing));
    }
    height = baseY + section1Height + section2Height;
    CGSize size = CGSizeMake(KScreenWidth, height);
    return size;
}

- (CGRect)shoppingCartLayout:(ShoppingCartLayout *)layout frameForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > 2) {
        return CGRectZero;
    }
    NSArray *commodityArray = self.dataArray.firstObject;
    NSArray *recommendArray = self.dataArray.lastObject;
    NSUInteger commodityCount = commodityArray.count;
    NSUInteger recommendCount = recommendArray.count;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = kHeaderWidth;
    CGFloat height = kHeaderHeight;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            height = kHeaderHeight;
        } else {
            if (!recommendCount) {
                return CGRectZero;
            }
            CGFloat commoityHeight = kCommodityHeight;
            commodityCount = commodityCount;
            y = kHeaderHeight + commodityCount * (commoityHeight + layout.commodityLineSpacing) + layout.commodityLineSpacing + layout.recommendLineSpacing;
        }
    }
    return CGRectMake(x, y, width, height);
}

- (CGRect)shoppingCartLayout:(ShoppingCartLayout *)layout frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > 2) {
        return CGRectZero;
    }
    NSArray *commodityArray = self.dataArray.firstObject;
    NSArray *recommendArray = self.dataArray.lastObject;
    NSUInteger commodityCount = commodityArray.count;
    NSUInteger recommendCount = recommendArray.count;
    CGFloat marginLeft = (KScreenWidth - kRecommendWidth * self.cellNumerPerRow) / (self.cellNumerPerRow + 1);
    
    CGFloat commoityHeight = kCommodityHeight;
    commodityCount = commodityCount;
    
    CGFloat x = marginLeft;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    if (indexPath.section == 0) {
        width = kCommodityWidth;
        height = commoityHeight;
        x = 0;
        y = kHeaderHeight + layout.commodityLineSpacing + indexPath.row * commoityHeight + indexPath.row * layout.commodityLineSpacing;
    } else {
        width = kRecommendWidth;
        height = kRecommendHeight;
        x = indexPath.row % (NSInteger)self.cellNumerPerRow * kRecommendWidth + (indexPath.row % (NSInteger)self.cellNumerPerRow + 1) * marginLeft;
        CGFloat baseY = 0;
        baseY = kHeaderHeight + layout.commodityLineSpacing + commodityCount * (commoityHeight + layout.commodityLineSpacing) + layout.recommendLineSpacing + kHeaderHeight + layout.recommendLineSpacing;
        
        y = baseY + floor(indexPath.row / self.cellNumerPerRow) * kRecommendHeight + (floor(indexPath.row / self.cellNumerPerRow)) *layout.recommendLineSpacing;
    }
    return CGRectMake(x, y, width, height);
}

@end
