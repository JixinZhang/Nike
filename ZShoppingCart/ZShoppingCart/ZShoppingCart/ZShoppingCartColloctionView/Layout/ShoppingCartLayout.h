//
//  ShoppingCartLayout.h
//  ZShoppingCart
//
//  Created by AlexZhang on 24/11/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KScreenWidth [UIScreen mainScreen].bounds.size.width

#define kCommodityWidth [UIScreen mainScreen].bounds.size.width
#define kCommodityHeight 110

#define kRecommendWidth 101
#define kRecommendHeight 216

#define kHeaderWidth [UIScreen mainScreen].bounds.size.width
#define kHeaderHeight 50

@class ShoppingCartLayout;

@protocol ShoppingCartLayoutDataSource <NSObject>

/**
 计算每个item的CGRect.
 
 @param layout ZShoppingCartLayout.
 @param indexPath The index path of the item.
 @return current item's rect.
 */
- (CGRect)shoppingCartLayout:(ShoppingCartLayout *)layout frameForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 计算Header或者Footer的CGRect
 
 @param layout ZShoppingCartLayout.
 @param elementKind a string that identifies the type of the supplementary view.
 @param indexPath The index path of the supplementary view.
 @return current supplementary view's rect.
 */
- (CGRect)shoppingCartLayout:(ShoppingCartLayout *)layout frameForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

/**
 计算CollectionView的conent size.
 
 @param layout ZShoppingCartLayout
 @return the size of collection view.
 */
- (CGSize)collectionViewContentSize:(ShoppingCartLayout *)layout;

@end

@interface ShoppingCartLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<ShoppingCartLayoutDataSource> dataSource;
@property (nonatomic, assign) CGFloat commodityLineSpacing;                 //购买商品的间距，默认为5pt
@property (nonatomic, assign) CGFloat recommendLineSpacing;                 //推荐商品的间距，默认为0pt

@end
