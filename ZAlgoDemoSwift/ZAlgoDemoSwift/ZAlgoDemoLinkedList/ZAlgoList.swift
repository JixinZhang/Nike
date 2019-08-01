//
//  ZAlgoList.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/25.
//  Copyright © 2019 zjixin. All rights reserved.
//

import Foundation

/// 单向链表节点
class ZAlgoListNode : NSObject {
    var val:Int
    var next:ZAlgoListNode?
    
    init(_ value:Int) {
        self.val = value
        self.next = nil
    }
    /*  快行指针
     两个指针访问链表，一个在前一个在后，或者一个移动快另一个移动慢，这就是快行指针
     */
    
    /// 判断一个链表是否有环
    ///
    /// - Returns: YES：包含环
    open func hasCycle() -> Bool {
        var slow: ZAlgoListNode? = self
        var fast: ZAlgoListNode? = self
        
        while ((fast != nil) && fast?.next != nil) {
            slow = slow!.next
            fast = fast!.next?.next
            if slow === fast {
                return true
            }
        }
        return false
    }
    
    open func _calculateLinkedListLength() -> Int {
        var count = 0
        var node: ZAlgoListNode? = self
        while node != nil {
            count += 1
            node = node?.next
        }
        return count
    }
    
    open func displayAllNodeValue() {
        var listNode: ZAlgoListNode? = self
        print(self)
        var log = "\t"
        while listNode != nil {
            log += "\(listNode!.val)->"
            listNode = listNode!.next
        }
        print(log)
    }
    
    open func printListReversingly() {
        let node: ZAlgoListNode? = self;
        if node != nil {
            if node!.next != nil {
                node?.next?.printListReversingly()
            }
            print("\(node!.val)")
        }
    }
}

/// 单向链表
class ZAlgoList: NSObject {
    public var head: ZAlgoListNode?
    public var tail: ZAlgoListNode?
    
    override init() {
        
    }
    
    /// 尾插法
    ///
    /// - Parameter val: 插入的value
    open func appendToTail(val: Int) {
        if tail == nil {
            tail = ZAlgoListNode.init(val)
            head = tail
        } else {
            tail!.next = ZAlgoListNode.init(val)
            tail = tail!.next
        }
    }
    
    open func appendNodeToTail(node: ZAlgoListNode?) {
        guard node != nil else {
            return
        }
        
        if tail == nil {
            tail = node
            head = tail
        } else {
            tail!.next = node
            tail = node;
        }
    }
    
    /// 头插法
    ///
    /// - Parameter val: 插入的value
    open func appendToHead(val:Int) {
        if head == nil {
            head = ZAlgoListNode.init(val)
            tail = head
        } else {
            let listNode = ZAlgoListNode.init(val)
            listNode.next = head
            head = listNode
        }
    }
    
    open func deleteTail() -> ZAlgoListNode? {
        if tail == nil {
            return nil
            
        } else {
            var newTailNode:ZAlgoListNode?
            let oldTailNode = self.tail
            var listNode = head
            
            while (listNode != nil) {
                if listNode!.next == self.tail {
                    newTailNode = listNode
                    break
                }
                listNode = listNode!.next
            }
            newTailNode?.next = nil
            self.tail = newTailNode
            return oldTailNode
        }
        
    }
    
    open func reverserList() -> ZAlgoListNode? {
        guard head != nil else {
            return nil
        }
        
        var preNode: ZAlgoListNode?
        var curNode: ZAlgoListNode? = head!
        while curNode != nil {
            let nextNode = curNode!.next
            
            curNode!.next = preNode
            preNode = curNode
            curNode = nextNode
        }
        return preNode
    }
    
    open func displayAllNodeValue() {
        var listNode = head
        print(self)
        var log = "\t"
        while listNode != nil {
            log += "\(listNode!.val)->"
            listNode = listNode!.next
        }
        print(log)
    }
    
    open func deleteDuplicates() -> ZAlgoListNode? {
        guard self.head != nil else {
            return nil;
        }
        
        if self.head!.next == nil {
            return self.head;
        }
        
        var curNode: ZAlgoListNode? = self.head
        while curNode?.next != nil {
            if curNode!.val == curNode!.next!.val {
                curNode!.next = curNode!.next?.next
            } else {
                curNode = curNode!.next;
            }
        }
        return self.head;
    }
}
