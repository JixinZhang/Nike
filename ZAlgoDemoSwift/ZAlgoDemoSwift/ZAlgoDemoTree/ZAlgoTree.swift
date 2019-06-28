//
//  ZAlgoTree.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/26.
//  Copyright © 2019 zjixin. All rights reserved.
//

import Foundation

/*
                       高度   深度   层
            a           3     0     1
          /   \
         b     c        2     1     2
        / \   / \
       d   e f   g      1     2     3
      / \       /
     h  i      j        0     3     4
 高度：类比站在地面向上看楼房的高度，从0开始；
 深度：累比站在岸边向下看泳池的深度，从0开始；
 层数：层和深度类似，从1开始， 层数 = 深度 + 1。
 
 */

class ZAlgoTreeNode: NSObject {
    public var value: Int
    public var left: ZAlgoTreeNode?
    public var right: ZAlgoTreeNode?
    public var isFisrt: Bool = false
    
    public init(_ value: Int) {
        self.value = value
        self.left = nil
        self.right = nil
    }
}

/// 二叉搜索树
class ZAlgoBinarySearchTree: NSObject {
    public var root: ZAlgoTreeNode?
    
    public init(root: ZAlgoTreeNode) {
        self.root = root
    }
    
    /// 树的最大深度
    ///
    /// - Returns: 树的深度
    public func maxDepth() -> Int {
        return self._maxDepth(node: self.root)
    }
    
    func _maxDepth(node: ZAlgoTreeNode?) -> Int {
        let root = node
        guard (root != nil) else {
            return 0
        }
        let result = max(_maxDepth(node: root?.left), _maxDepth(node: root?.right)) + 1
        return result
    }
    
    /// 当前树是否是一个二叉搜索树
    ///
    /// - Returns: true for is a BST
    public func isValidBST() -> Bool {
        return _isValidBST(node : self.root, nil, nil)
    }
    
    func _isValidBST(node: ZAlgoTreeNode?, _ min: Int?, _ max: Int?) -> Bool {
        guard node != nil  else {
            //空的二叉树，是搜索二叉树
            return true
        }
        
        if let min = min, node!.value < min {
            //如果当前节点的值小于左子节点的值，则不是二叉树
            return false
        }
        
        if let max = max, node!.value > max {
            return false
        }
        return _isValidBST(node: node!.left, min, node!.value) && _isValidBST(node: node!.right, node!.value, max)
    }
    
    /// 查找目标值的节点
    ///
    /// - Parameter value: 目标值
    /// - Returns: 目标值的节点
    public func find(_ value: Int) -> ZAlgoTreeNode? {
        var node = self.root
        while node != nil {
            if node!.value < value {
                node = node?.right
            } else if node!.value > value {
                node = node?.left
            } else {
                return node;
            }
        }
        return nil
    }
    
    /// 插入到二叉搜索树中
    ///
    /// - Parameter value: 插入的值
    public func insert(_ value: Int)  {
        if self.root == nil {
            self.root = ZAlgoTreeNode.init(value)
            return
        }
        
        var pNode = self.root
        while pNode != nil {
            if value > pNode!.value {
                if pNode!.right != nil {
                    pNode = pNode!.right
                } else {
                    pNode?.right = ZAlgoTreeNode.init(value)
                    return
                }
                
            } else {
                if pNode!.left != nil {
                    pNode = pNode!.left
                } else {
                    pNode?.left = ZAlgoTreeNode.init(value)
                    return
                }
            }
        }
    }
    
    /// 二叉查找树的删除操作
    ///
    /// 第一种情况是，如果要删除的节点没有子节点，我们只需要直接将父节点中，指向要删除节点的指针置为 null。
    ///
    /// 第二种情况是，如果要删除的节点只有一个子节点（只有左子节点或者右子节点），我们只需要更新父节点中，指向要删除节点的指针，让它指向要删除节点的子节点就可以了。
    ///
    /// 第三种情况是，如果要删除的节点有两个子节点，这就比较复杂了。我们需要找到这个节点的右子树中的最小节点，把它替换到要删除的节点上。然后再删除掉这个最小节点，因为最小节点肯定没有左子节点（如果有左子结点，那就不是最小节点了），所以，我们可以应用上面第一条和第二条两条规则来删除这个最小节点。
    ///
    /// - Parameter value: 要删除的目标值
    public func delete(value: Int) {
        var node = self.root    //
        var nodeParent:ZAlgoTreeNode?     //当前节点的父节点
        
        //找到值为value的节点，并且记录其父节点
        while node != nil && node!.value != value {
            nodeParent = node
            if value < node!.value {
                node = node!.left
            } else {
                node = node!.right
            }
        }
        
        // 删除的节点有两个子节点
        if node!.left != nil && node!.right != nil {
            //要找到其右子树中最小的节点
            var minNode:ZAlgoTreeNode? = node!.right
            var minNodeParent:ZAlgoTreeNode?            //最小节点的父节点
            while minNode!.left != nil {
                minNodeParent = minNode
                minNode = minNode!.left
            }
            node!.value = minNode!.value    //将最小节点的数据更新到需要删除的节点上，相当于删除了目标节点
            node = minNode                  //记录minNode，下面执行删除
            nodeParent = minNodeParent
        }
        
        //删除节点是叶子节点或者仅有一个子节点
        var child:ZAlgoTreeNode?
        if node!.left != nil {
            child = node!.left
        } else if node!.right != nil {
            child = node!.right
        } else {
            child = nil
        }
        
        if nodeParent == nil {
            //删除的是根节点
            self.root = child
        } else if nodeParent?.left == node {
            nodeParent?.left = child
        } else {
            nodeParent?.right = child
        }
    }
    
    /// 以递归的方式前序遍历二叉搜索树
    ///
    /// - Returns: 包含所有节点的数组
    public func preOrderRecursion() -> Array<ZAlgoTreeNode>? {
        var array: Array<ZAlgoTreeNode>? = Array.init()
        _preOrderRecursion(treeNode: self.root, array: &array)
        return array
    }
    
    /// 前序 根左右
    func _preOrderRecursion(treeNode: ZAlgoTreeNode?, array: inout Array<ZAlgoTreeNode>?) {
        guard treeNode != nil && array != nil else {
            return
        }
        
        let node = treeNode!
        array!.append(node)
        _preOrderRecursion(treeNode: node.left, array: &array)
        _preOrderRecursion(treeNode: node.right, array: &array)
    }
    
    /// 以递归的方式中序遍历二叉搜索树
    ///
    /// - Returns: 包含所有节点的数组
    public func inOrderRecursion() -> Array<ZAlgoTreeNode>? {
        var array: Array<ZAlgoTreeNode>? = Array.init()
        _inOrderRecursion(treeNode: self.root, array: &array)
        return array
    }
    
    /// 中序 左根右
    func _inOrderRecursion(treeNode: ZAlgoTreeNode?, array: inout Array<ZAlgoTreeNode>?) {
        guard treeNode != nil && array != nil else {
            return
        }
        
        let node = treeNode!
        _inOrderRecursion(treeNode: node.left, array: &array)
        array!.append(node)
        _inOrderRecursion(treeNode: node.right, array: &array)
    }
    
    /// 以递归的方式后序遍历二叉搜索树
    ///
    /// - Returns: 包含所有节点的数组
    public func postOrderRecursion() -> Array<ZAlgoTreeNode>? {
        var array: Array<ZAlgoTreeNode>? = Array.init()
        _postOrderRecursion(treeNode: self.root, array: &array)
        return array
    }
    
    /// 后序 左右根
    func _postOrderRecursion(treeNode: ZAlgoTreeNode?, array: inout Array<ZAlgoTreeNode>?) {
        guard treeNode != nil && array != nil else {
            return
        }
        
        let node = treeNode!
        _postOrderRecursion(treeNode: node.left, array: &array)
        _postOrderRecursion(treeNode: node.right, array: &array)
        array!.append(node)
    }
    
    /// 以栈的的方式前序遍历二叉搜索树
    ///
    /// 栈的特性：先入后出(FILO)
    /// 前序：根 左 右
    /// - Returns: 包含所有节点的数组
    public func preOrderStack() ->Array<ZAlgoTreeNode>? {
        //用数组来实现栈
        var stack = Array<ZAlgoTreeNode>.init()
        var result = Array<ZAlgoTreeNode>.init()
        var node = self.root
        
        while !stack.isEmpty || node != nil {
            if node != nil {
                //遇到根节点就记录
                result.append(node!)
                //并且将根节点入栈，后面根节点的右子节点要使用
                stack.append(node!)
                //继续查询左子节点
                node = node!.left
            } else {
                //查询栈顶节点的右子节点
                node = stack.removeLast().right
            }
        }
        return result
    }
    
    /// 以栈的的方式中序遍历二叉搜索树
    ///
    /// 栈的特性：先入后出(FILO)
    /// 中序：左 根 右
    /// - Returns: 包含所有节点的数组
    public func inOrderStack() ->Array<ZAlgoTreeNode>? {
        //用数组来实现栈
        var stack = Array<ZAlgoTreeNode>.init()
        var result = Array<ZAlgoTreeNode>.init()
        var node = self.root
        
        while !stack.isEmpty || node != nil {
            if node != nil {
                //遇到根节点先入栈，后面左子节点处理完后，需要处理当前节点
                stack.append(node!)
                //继续查询左子节点
                node = node!.left
            } else {
                //当没有左子节点时
                node = stack.removeLast()
                //将当前节点记录
                result.append(node!)
                //继续查询右子节点
                node = node!.right
            }
            
        }
        return result
    }
    
    /// 以栈的的方式后序遍历二叉搜索树
    ///
    /// 栈的特性：先入后出(FILO)
    /// 后序：左 右 根
    ///
    /// 在处理后续遍历时总是会遇到这样的问题：当我处理的某节点A的右子节点Ar时回到当前节点A时，由于节点A有右子节点，所以我们需要知道节点A的右子节点是否处理过。
    ///
    /// 解法一：每个节点增加一个标记量 isFirst ，当节点A的isFirst为true时，表示节点A的右子节点已经处理过了，可以直接记录节点A，无需继续查询其右子节点Ar
    ///
    /// 解法二：记录已经查询过右子节点节点，如果当前节点A的右子节点在记录中，则无需继续查询节点A的右子节点Ar
    
    /// - Returns: 包含所有节点的数组
    public func postOrderStack() ->Array<ZAlgoTreeNode>? {
        //用数组来实现栈
        var stack = Array<ZAlgoTreeNode>.init()
        var result = Array<ZAlgoTreeNode>.init()
        var node = self.root
        
        //解法一：增加标记量isFirst
        while !stack.isEmpty || node != nil {
            if node != nil {
                //遇到根节点就标记为isFirst并且入栈
                node?.isFisrt = true
                stack.append(node!)
                //继续查询左子节点
                node = node!.left
            } else {
                //当没有没有左子节点时
                node = stack.removeLast()
                
                if node!.isFisrt && node!.right != nil {
                    //如果当前节点是第一次处理 并且 当前节点有右子节点
                    //标记当前节点不是第一次处理，并将当前节点入栈，然后继续查询右子节点
                    node!.isFisrt = false
                    stack.append(node!)
                    node = node!.right
                } else {
                    //如果当前节点不是第一次处理 或者 当前节点没有右子节点
                    //将当前节点记录
                    result.append(node!)
                    //结束当前节点的查询，继续查询栈顶的节点（代码的第283行 `node = stack.removeLast()`）
                    node = nil
                }
            }
        }
        return result
    }
    
    /// 以栈的的方式后序遍历二叉搜索树
    ///
    /// 栈的特性：先入后出(FILO)
    /// 后序：左 右 根
    ///
    /// 在处理后续遍历时总是会遇到这样的问题：当我处理的某节点A的右子节点Ar时回到当前节点A时，由于节点A有右子节点，所以我们需要知道节点A的右子节点是否处理过。
    /// 解法二：记录已经查询过右子节点节点，如果当前节点A的右子节点在记录中，则无需继续查询节点A的右子节点Ar
    ///
    /// - Returns: 包含所有节点的数组
    public func postOrderStackWithRecord() ->Array<ZAlgoTreeNode>? {
        //用数组来实现栈
        var stack = Array<ZAlgoTreeNode>.init()
        var result = Array<ZAlgoTreeNode>.init()
        var node = self.root
        
        //解法二：记录上次处理的节点
        //一下数组记录已经查询过得右子节点
        var lastNodeArray = Array<ZAlgoTreeNode>.init()
        
        while !stack.isEmpty || node != nil {
            if node != nil {
                //遇到根节点入栈
                stack.append(node!)
                //继续查询左子节点
                node = node!.left
            } else {
                //如果没有左子节点，则从栈顶取出当前节点
                node = stack.removeLast()
                
                //判断当前节点是否有右子节点
                if node!.right != nil {
                    if let index = lastNodeArray.firstIndex(of: node!.right!) {
                        //如果当前节点的右子节点已经处理过（在数组中）
                        //将右子节点的记录移除
                        lastNodeArray.remove(at: index)
                        //记录当前节点
                        result.append(node!)
                        //结束当前节点的查询，继续查询栈顶的节点（代码的第330行 `node = stack.removeLast()`）
                        node = nil
                    } else {
                        lastNodeArray.append(node!.right!)
                        stack.append(node!)
                        node = node!.right
                    }
                } else {
                    //没有右子节点
                    //将当前节点记录
                    result.append(node!)
                    //结束当前节点的查询，继续查询栈顶的节点（代码的第330行 `node = stack.removeLast()`）
                    node = nil
                }
            }
        }
        lastNodeArray.removeAll()
        return result
    }
    
    /// 以队列的方式层级遍历数组
    ///
    /// 队列的特点：先进先出(FIFO)
    /// - Returns: 包含所有节点的二维数组，数组第一层为是树的每一层包含的所有节点的数组
    public func levelOrder() ->[[ZAlgoTreeNode]]? {
        var result = [[ZAlgoTreeNode]].init()
        
        //用数组来实现队列，队列的特点：先进先出FIFO
        var queue = Array<ZAlgoTreeNode>.init()
        
        if let root = self.root {
            queue.append(root)
        }
        
        while queue.count > 0 {
            let size = queue.count
            var level = Array<ZAlgoTreeNode>.init()
            
            //遍历当前层的所有节点
            for _ in 0 ..< size {
                //记录当前已经查询过得节点，并将节点从队列中移除
                let node = queue.removeFirst()
                level.append(node)
                
                //更新当前层的下一层的节点队列
                if let left = node.left {
                    queue.append(left)
                }
                
                //更新当前层的下一层的节点队列
                if let right = node.right {
                    queue.append(right)
                }
            }
            result.append(level)
        }
        return result
    }
    
    
    //MARK: DFS & BFS
    /*
     深度优先搜索（Depth-First-Search，以下简称DFS）
     广度优先搜索（Breadth-First-Search，以下简称BFS）
     
     永远记住：DFS 的实现用递归，BFS 的实现用循环（配合队列）。
     */
}
