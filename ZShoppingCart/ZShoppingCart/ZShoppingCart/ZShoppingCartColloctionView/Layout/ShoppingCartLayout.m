//
//  ShoppingCartLayout.m
//  ZShoppingCart
//
//  Created by AlexZhang on 24/11/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import "ShoppingCartLayout.h"

@implementation ShoppingCartLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.commodityLineSpacing = 5.0f;
    self.recommendLineSpacing = 0;
}

/**
 设置CollectionView的contenSize
 */
- (CGSize)collectionViewContentSize {
    if ([self.dataSource respondsToSelector:@selector(collectionViewContentSize:)]) {
        return [self.dataSource collectionViewContentSize:self];
    }
    return CGSizeZero;
}

/**
 允许CollectionView Bounds发生变化时，重新进行布局。
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/**
 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes= [NSMutableArray array];
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:headerIndexPath]];
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:section]; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}

/**
 返回SectionHeader或者SectionFooter对应的UICollectionViewLayoutAttributes
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        if ([self.dataSource respondsToSelector:@selector(shoppingCartLayout:frameForSupplementaryViewOfKind:atIndexPath:)]) {
            attribute.frame = [self.dataSource shoppingCartLayout:self frameForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
        } else {
            attribute.frame = CGRectZero;
        }
    }
    return attribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(shoppingCartLayout:frameForItemAtIndexPath:)]) {
        attribute.frame = [self.dataSource shoppingCartLayout:self frameForItemAtIndexPath:indexPath];
    }
    return attribute;
}
@end
