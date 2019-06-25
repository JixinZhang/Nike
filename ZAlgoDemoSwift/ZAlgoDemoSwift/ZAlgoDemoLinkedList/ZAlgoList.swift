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
    
    open func displayAllNodeValue() {
        var listNode = head
        print(self)
        while listNode != nil {
            print(listNode!.val)
            listNode = listNode?.next
        }
    }
}
