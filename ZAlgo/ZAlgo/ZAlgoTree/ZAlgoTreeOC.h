//
//  ZAlgoTreeOC.h
//  ZAlgoDemo
//
//  Created by zjixin on 2019/8/29.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZAlgoTreeNodeOC : NSObject

@property (nonatomic, assign) NSInteger val;
@property (nonatomic, strong) ZAlgoTreeNodeOC *left;
@property (nonatomic, strong) ZAlgoTreeNodeOC *right;

/**
 记录是否是第一次访问，用于通过栈后序遍历二叉树
 isFirst == YES, 需要继续遍历其右子节点right
 isFirst == NO, 无需遍历其右子节点right
 */
@property (nonatomic, assign) BOOL isFirst;

- (instancetype)initWithValue:(NSInteger)value;

@end

/**
 二叉搜索树
 
 根节点的值大于左节点，小于右节点
 */
@interface ZAlgoTreeOC : NSObject

@property (nonatomic, strong) ZAlgoTreeNodeOC *root;

- (instancetype)initWithRoot:(ZAlgoTreeNodeOC *)root;

/**
 二叉树的最大深度

 @return 深度
 */
- (NSInteger)maxDepth;


/**
 是否是一个二叉搜索树

 @return result
 */
- (BOOL)isVailBST;


/**
 插入到二叉树中

 @param value 插入的值
 */
- (void)insertWithValue:(NSInteger)value;

/**
 前序遍历--递归

 @return 包含所有节点的数组
 */
- (NSArray<ZAlgoTreeNodeOC *> *)preOrderRecursion;

/**
 前序遍历--以栈的的方式
 
 栈的特性：先入后出(FILO)
 前序：根 左 右
 @return 包含所有节点的数组
 */
- (NSArray<ZAlgoTreeNodeOC *> *)preOrderStack;

/**
 中序遍历--递归

 @return 包含所有节点的数组
 */
- (NSArray<ZAlgoTreeNodeOC *> *)inOrderRecursion;

/**
 中序遍历--以栈的的方式
 
 栈的特性：先入后出(FILO)
 中序：左 根 右
 @return 包含所有节点的数组
 */
- (NSArray<ZAlgoTreeNodeOC *> *)inOrderStack;

/**
 后续遍历--递归

 @return 包含所有节点的数组
 */
- (NSArray<ZAlgoTreeNodeOC *> *)postOrderRecursion;

/**
 后序遍历--以栈的方式--标记量
 后序：左 右 根

 @return 包含所有节点的数组
 */
- (NSArray<ZAlgoTreeNodeOC *> *)postOrderStack;

/**
 后序遍历--以栈的方式--数组记录
 后序：左 右 根
 
 @return 包含所有节点的数组
 */
- (NSArray<ZAlgoTreeNodeOC *> *)postOrderStackWithRecord;

@end

