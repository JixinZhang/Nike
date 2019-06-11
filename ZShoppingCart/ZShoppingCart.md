最近业务上需要完成一个购物车，其页面的UI和天猫、淘宝类似。

[GitHub传送门](https://github.com/JixinZhang/ZShoppingCart)

**包含以下内容：**
	
* 已选购商品；
* 推荐商品；
* 广告

下面是天猫的购物车页面，上面半部分是一个cell（已选购商品），下面半部分是两个cell（推荐商品）并列。

![image.png](http://upload-images.jianshu.io/upload_images/2409226-db34fb95df469857.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


******************
####可以用UICollectionView和UITableView两种方式实现。
******************

##一、UICollectionView实现

用UICollectionView实现，主要是需要自定义Layout和手动计算每个Cell、SupplementaryView的Frame。

###1.UICollectionViewFlowLayout

####1)自定义一个ShoppingCartLayout（继承于UICollectionViewFlowLayout），在ShoppingCartLayout中主要关注五个方法：


```
1. 设置CollectionView的contenSize

- (CGSize)collectionViewContentSize;

2. return YES ：允许CollectionView Bounds发生变化时，重新进行布局。

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;

3. 返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 返回值决定了rect范围内所有元素的排布（frame）
 
 - (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;

 4. 返回SectionHeader或者SectionFooter对应的UICollectionViewLayoutAttributes

 - (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath

 5. 返回每个Cell对应的UICollectionViewLayoutAttributes

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath

```

####2)上述五个方法中的1，4，5需要手动计算Size、Frame，为此我们给ShoppingCartLayout添加一个代理方法：`ShoppingCartLayoutDataSource`并在CollectionViewCotroller中实现该协议的三个方法。

```
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

```

####3)实现计算Collection的ContentSize

```

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

```

####4)实现sectionHeader\sectionfooter frame的计算

```
//特别注意在计算section ==1 的header时，其origin.y 需要加上section0的MaxY
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

```

####5)计算每个cell的frame 

```
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

```

####6) 结果展示

![ShoppingCart collectionView](https://upload-images.jianshu.io/upload_images/2409226-1cb7604825a93ab8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##二、UITablviewView实现

最开始以为无法用UITableView实现，后来看到Tmall的购物车的cell可以左滑删除，就判定Tmall时用UITableView实现的，所以后用Reveal看了Tmall的购物车的View结构，如下：


![TmallCart.png](http://upload-images.jianshu.io/upload_images/2409226-2fb4300e11b8fd99.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###天猫购物车页面UI结构图

![TmallCartViews.png](http://upload-images.jianshu.io/upload_images/2409226-e6adbbf05a3404b7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
1. 购物车列表：AliCartTabelView;
2. 商铺View：	TMCartShopCell;
3. 已选商品View：TMCartContextCell;
4. 还有一些分割线View：AliCartItemSeparateCell, AliCartFlexibleCell
5. 推荐商品的view：看了View的结构图可以在一个UITableViewCell中放置两个推荐商品View

```

<font color = 'red'>(看了结构，对TangramDoubleColumnLayout这个“View”不是很懂，那位路过的大神懂的话，指导一下)</font>

###1.数据处理

####1）已选商品和商铺
我提供的[Demo](https://github.com/JixinZhang/ZShoppingCart)中做了简化处理，只包含已选商品；

####2）推荐商品

```
self.cellNumerPerRow = 3; //每行三个推荐
NSMutableArray *finalRecommendArray = [NSMutableArray array];
NSMutableArray *mutaArray = [NSMutableArray arrayWithCapacity:3];
for (NSInteger idx = 0; idx < recommendArray.count; idx++) {
    [mutaArray addObject:recommendArray[idx]];
    if (mutaArray.count == self.cellNumerPerRow ||
        idx == recommendArray.count - 1) {
        [finalRecommendArray addObject:[mutaArray copy]];
        [mutaArray removeAllObjects];
    }
}

[self.dataArray addObject:commodityArray];
[self.dataArray addObject:finalRecommendArray];

```

####3) 结果展示

![ShoppingCart TableView](https://upload-images.jianshu.io/upload_images/2409226-57a0ade237885c03.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


