//
//  ZAlgoTreeOC.m
//  ZAlgoDemo
//
//  Created by zjixin on 2019/8/29.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZAlgoTreeOC.h"

#pragma mark -- ZAlgoTreeNodeOC

@implementation ZAlgoTreeNodeOC

- (instancetype)initWithValue:(NSInteger)value {
    self = [super init];
    if (self) {
        self.val = value;
        self.left = nil;
        self.right = nil;
    }
    return self;
}

@end

#pragma mark -- ZAlgoTreeOC

@interface ZAlgoTreeOC (){
    NSMutableArray *_result;
}

@end

@implementation ZAlgoTreeOC

- (instancetype)initWithRoot:(ZAlgoTreeNodeOC *)root {
    self = [super init];
    if (self) {
        self.root = root;
    }
    return self;
}

- (NSInteger)maxDepth {
    return [self _maxDepthWithRoot:self.root];
}

- (NSInteger)_maxDepthWithRoot:(ZAlgoTreeNodeOC *)root {
    if (!root) {
        return 0;
    }
    NSInteger result = MAX([self _maxDepthWithRoot:root.left], [self _maxDepthWithRoot:root.right]) + 1;
    return result;
}

- (BOOL)isVailBST {
    return [self _isVailBST:self.root];
}

- (BOOL)_isVailBST:(ZAlgoTreeNodeOC *)node {
    if (!node) {
        return YES;
    }
    
    if (node.left && node.val < node.left.val) {
        return NO;
    }
    
    if (node.right && node.val > node.right.val) {
        return NO;
    }
    
    return [self _isVailBST:node.left] && [self _isVailBST:node.right];
}

- (void)insertWithValue:(NSInteger)value {
    if (!self.root) {
        ZAlgoTreeNodeOC *root = [[ZAlgoTreeNodeOC alloc] initWithValue:value];
        self.root = root;
        return;
    }
    
    ZAlgoTreeNodeOC *pNode = self.root;
    while (pNode) {
        if (value > pNode.val) {
            if (pNode.right) {
                pNode = pNode.right;
            } else {
                pNode.right = [[ZAlgoTreeNodeOC alloc] initWithValue:value];
                return;
            }
            
        } else {
            if (pNode.left) {
                pNode = pNode.left;
            } else {
                pNode.left = [[ZAlgoTreeNodeOC alloc] initWithValue:value];
                return;
            }
        }
    }
}

#pragma mark -- preOrder

- (NSArray<ZAlgoTreeNodeOC *> *)preOrderRecursion {
    _result = [NSMutableArray array];
    [self _preOrderRecursion:self.root];
    return [_result copy];
}

- (void)_preOrderRecursion:(ZAlgoTreeNodeOC *)node {
    if (!node) {
        return;
    }
    if (!_result) {
        _result = [NSMutableArray array];
    }
    
    [_result addObject:node];
    [self _preOrderRecursion:node.left];
    [self _preOrderRecursion:node.right];
}

- (NSArray<ZAlgoTreeNodeOC *> *)preOrderStack {
    NSMutableArray<ZAlgoTreeNodeOC *> *stack = [NSMutableArray array];
    NSMutableArray<ZAlgoTreeNodeOC *> *result = [NSMutableArray array];
    ZAlgoTreeNodeOC *node = self.root;
    
    while (stack.count > 0 || node) {
        if (node) {
            //遇到根节点就记录
            [result addObject:node]; //中 左
            [stack addObject:node];
            node = node.left;
        } else {
            node = stack.lastObject.right;  //右
            [stack removeLastObject];
        }
    }
    return [result copy];
}

#pragma mark -- inOrder

- (NSArray<ZAlgoTreeNodeOC *> *)inOrderRecursion {
    _result = [NSMutableArray array];
    [self _inOrderRecursion:self.root];
    return [_result copy];
}

- (void)_inOrderRecursion:(ZAlgoTreeNodeOC *)node {
    if (!node) {
        return;
    }
    if (!_result) {
        _result = [NSMutableArray array];
    }
    
    [self _inOrderRecursion:node.left];
    [_result addObject:node];
    [self _inOrderRecursion:node.right];
}

- (NSArray<ZAlgoTreeNodeOC *> *)inOrderStack {
    NSMutableArray<ZAlgoTreeNodeOC *> *stack = [NSMutableArray array];
    NSMutableArray<ZAlgoTreeNodeOC *> *result = [NSMutableArray array];
    ZAlgoTreeNodeOC *node = self.root;
    
    while (stack.count > 0 || node) {
        if (node) {
            [stack addObject:node];
            node = node.left;
        } else {
            node = stack.lastObject;
            [stack removeLastObject];
            [result addObject:node];    //左，中
            node = node.right;          //右
        }
    }
    return [result copy];
}

#pragma mark -- postOrder

- (NSArray<ZAlgoTreeNodeOC *> *)postOrderRecursion {
    _result = [NSMutableArray array];
    [self _postOrderRecursion:self.root];
    return [_result copy];

}

- (void)_postOrderRecursion:(ZAlgoTreeNodeOC *)node {
    if (!node) {
        return;
    }
    
    if (!_result) {
        _result = [NSMutableArray array];
    }
    [self _postOrderRecursion:node.left];
    [self _postOrderRecursion:node.right];
    [_result addObject:node];
}

- (NSArray<ZAlgoTreeNodeOC *> *)postOrderStack {
    NSMutableArray<ZAlgoTreeNodeOC *> *stack = [NSMutableArray array];
    NSMutableArray<ZAlgoTreeNodeOC *> *result = [NSMutableArray array];
    ZAlgoTreeNodeOC *node = self.root;
    
    while (stack.count || node) {
        if (node) {
            //根节点标记为isFirst并且入栈
            node.isFirst = YES;
            [stack addObject:node];
            //继续查询左子节点
            node = node.left;
        } else {
            //当没有没有左子节点时
            node = stack.lastObject;
            [stack removeLastObject];
            
            if (node.isFirst && node.right) {
                //如果当前节点是第一次处理 并且 当前节点有右子节点
                //标记当前节点不是第一次处理，并将当前节点入栈，然后继续查询右子节点
                node.isFirst = NO;
                [stack addObject:node];
                node = node.right;
            } else {
                //如果当前节点不是第一次处理 或者 当前节点没有右子节点
                //将当前节点记录
                [result addObject:node];
                //结束当前节点的查询，继续查询栈顶的节点
                node = nil;
            }
        }
    }
    return [result copy];
}

- (NSArray<ZAlgoTreeNodeOC *> *)postOrderStackWithRecord {
    NSMutableArray<ZAlgoTreeNodeOC *> *stack = [NSMutableArray array];
    NSMutableArray<ZAlgoTreeNodeOC *> *result = [NSMutableArray array];
    NSMutableArray<ZAlgoTreeNodeOC *> *record = [NSMutableArray array];
    ZAlgoTreeNodeOC *node = self.root;
    
    while (stack.count || node) {
        if (node) {
            [stack addObject:node];
            node = node.left;
        } else {
            //当没有没有左子节点时
            node = stack.lastObject;
            [stack removeLastObject];
            if (node.right) {
                if ([record containsObject:node.right]) {
                    //如果当前节点的右子节点已经处理过（在数组中）
                    //将右子节点的记录移除
                    [record removeObject:node.right];
                    [record addObject:node];
                    node = nil;
                    
                } else {
                    [record addObject:node.right];
                    [stack addObject:node];
                    node = node.right;
                }
            } else {
                //没有右子节点
                //将当前节点记录
                [result addObject:node];
                node = nil;
            }
        }
    }
    
    return result;
}

@end
