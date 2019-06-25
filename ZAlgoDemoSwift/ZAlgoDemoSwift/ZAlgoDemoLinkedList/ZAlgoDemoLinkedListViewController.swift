//
//  ZAlgoDemoLinkedListViewController.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/25.
//  Copyright © 2019 zjixin. All rights reserved.
//

import Foundation
import UIKit

class ZAlgoDemoLinkedListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let array = [1, 5, 3, 2, 4, 2]
        
        //1. test
        let list:ZAlgoList? = createLinkedList(array: array)
//        list?.appendToTail(val: 6)
//        list?.displayAllNodeValue()
//        _ = list?.deleteTail()
        list?.displayAllNodeValue()
        
//        let leftListHead = getLeftList(list?.head, 3)
//        print(leftListHead)
        
        /*2. 题目
         给一个链表和一个值 x，要求将链表中所有小于 x 的值放到左边，所有大于等于 x 的值放到右边。原链表的节点顺序不能变。
         
         例：1->5->3->2->4->②，给定x = 3。则我们要返回1->2->②->5->3->4
         备注由于不能改变原链表的节点顺序，所以5一定是在3的前面
         1. 1->5->3->2->4->②
         2. 左侧：1->2->②->nil, 右侧：5->3->4->nil
         3. 左右合并：1->2->②->5->3->4
         
         再比如以2为目标值，返回: 1->5->3->2->4->②
         执行顺序如下:
         1. 1->5->3->2->4->②
         2. 左侧：1->nil, 右侧：5->3->2->4->②->nil
         3. 1->5->3->2->4->②
         4. 备注：发现以2为目标值返回的值和原始值一样，这没有问题
         
         */
        let newListHead = partitionList(list?.head, 3)
        let newList = ZAlgoList.init()
        newList.head = newListHead
        if hasCycle(newListHead) {
            print("contans cycle")
        }
        newList.displayAllNodeValue()
    }
    
    func createLinkedList(array:Array<Int>) -> ZAlgoList {
        let list = ZAlgoList.init()
        
        for index in 0 ..< array.count {
            let value = array[index]
            list.appendToTail(val: value);
        }
        return list
    }
    
    
    /// 给定一个链表，找出列表中小于给定值的值，原链表节点顺序不能变
    ///
    /// - Parameters:
    ///   - head: 给定链表的头结点
    ///   - target: 目标值
    /// - Returns: 返回新链表的头结点
    func getLeftList(_ head: ZAlgoListNode?, _ target: Int) -> ZAlgoListNode {
        let dummy = ZAlgoListNode.init(0)
        var pre = dummy //引入一个虚拟头结点。最终的返回值是dummy.next
        var node = head
        
        while node != nil {
            if node!.val < target {
                pre.next = node
                pre = node!
            }
            node = node!.next
        }
        //防止构成环
        pre.next = nil
        return (dummy.next ?? nil)!
    }
    
    func partitionList(_ head: ZAlgoListNode?, _ target: Int) -> ZAlgoListNode {
        let leftDummy = ZAlgoListNode.init(0), rightDummy = ZAlgoListNode.init(0);
        var left = leftDummy, right = rightDummy;
        
        var node = head
        
        while node != nil {
            if node!.val < target {
                left.next = node    //将落入左侧链表中的节点追加在以leftDummy为头结点的左侧链表的尾部
                left = node!        //更新左侧链表的尾节点
                
            } else {
                right.next = node   //将落入右侧链表中的节点追加在以rightDummy为头结点的右侧链表的尾部
                right = node!       //更新右侧链表的尾节点
            }
            node = node!.next
        }
        /*
         1. 将右侧链表的尾节点的next置为nil，
         2. 如果右侧链表的尾节点（node）是原来链表的中间, 则node.next肯定不为nil
         3. 那当左右链表合并后，node.next肯定会出现在合并后的链表中
         4. node.next肯定指向了合并后链表中间的某个节点nodeA，此时从nodeA节点开始就形成了环
         5. 如果去掉下面这句代码，返回的链表肯定包含环
         */
        right.next = nil;
        
        //将右侧链表拼接到左侧链表的后面，注意右侧链表的真是数据是从rightDummy.next开始
        left.next = rightDummy.next
        return (leftDummy.next ?? nil)!
    }
    
    
    /*  快行指针
        两个指针访问链表，一个在前一个在后，或者一个移动快另一个移动慢，这就是快行指针
     */
    ///  判断一个链表是否有环
    ///
    /// - Parameter head: 链表的头结点
    /// - Returns: YES：包含环
    func hasCycle(_ head: ZAlgoListNode?) -> Bool {
        var slow = head;
        var fast = head;
        
        while (fast != nil && fast!.next != nil) {
            slow = slow!.next
            fast = fast!.next!.next
            
            if slow === fast {
                return true
            }
        }
        return false
    }
}
