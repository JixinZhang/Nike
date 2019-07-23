//
//  ZAlgoDemoLinkedListViewController.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/25.
//  Copyright © 2019 zjixin. All rights reserved.
//

import Foundation
import UIKit
/// 链表算法
///
/// https://github.com/knightsj/awesome-algorithm-question-solution
///
/// /Users/zjixin/Documents/zjixin/Library/awesome-algorithm-question-solution/
class ZAlgoDemoLinkedListViewController: UITableViewController {
    var dataSource:Array<Dictionary<String, String>>!
    var originalArray:Array<Int>!
    var stepCount:Int = 0
    var tree:ZAlgoBinarySearchTree?
    var list:ZAlgoList? = nil
    
    lazy var textView:UITextView = {
        let textView:UITextView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 200))
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .black
        textView.backgroundColor = .brown
        return textView
    }()
    
    override func viewDidLoad() {
        setupData()
        self.tableView.tableFooterView = textView
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: treeIdentifier)
        
        self.tableView.reloadData()
    }
    
    func setupData() {
        self.dataSource = [
            ["title" : "1. 链表",
             "action" : "createLinkedList"],
            ["title" : "2.2. 小于目标值x的放在链表左侧，大于x的放在链表右侧，原链表节点顺序不能变",
             "action" : "partitionListDemo"],
            ["title" : "3. 链表是否有环",
             "action" : "listHasCycleDemo"],
            ["title" : "4. 两个链表相交的第一个节点",
             "action" : "getIntersectionNodeDemo"],
            ["title" : "5. 链表反转",
             "action" : "reverseListDemo"],
            ["title" : "6.1 链表合并（while循环）",
             "action" : "mergeListDemo"],
            ["title" : "6.2 链表合并（递归）",
             "action" : "mergeListWithRecursionDemo"],
            ["title" : "7. 找到倒数第k个节点",
             "action" : "findKthNodeToTailDemo"],
        ]
    }
    
    //MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: treeIdentifier, for: indexPath)
        let dic:Dictionary = self.dataSource[indexPath.row]
        let title:String = dic["title"]!
        cell.textLabel?.text = title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.stepCount = 0
        let dic:Dictionary = self.dataSource[indexPath.row]
        let action:String! = dic["action"]
        if (action != nil) {
            let sel:Selector! = Selector.init(action)
            if (self.responds(to: sel)) {
                self.perform(sel, with: dic)
            }
        }
    }
    
    //MARK: Binary search
    
    @objc func createLinkedList() {
        let array = [1, 5, 3, 2, 4, 2]
        list = createLinkedList(array: array)
        list?.displayAllNodeValue()
    }
    
    @objc func partitionListDemo() {
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
        if newListHead.hasCycle() {
            print("contans cycle")
        }
        newList.displayAllNodeValue()
    }
    
    @objc func listHasCycleDemo() {
        let newListHead = partitionList(list?.head, 3)
        let newList = ZAlgoList.init()
        newList.head = newListHead
        if newListHead.hasCycle() {
            print("contans cycle")
        }
        newList.displayAllNodeValue()
    }
    
    @objc func getIntersectionNodeDemo() {
        let array = [1, 5, 3, 2, 4, 2]
        list = createLinkedList(array: array)
        list?.displayAllNodeValue()
        
        let arrayB = [10, 12, 19]
        let listB: ZAlgoList = createLinkedList(array: arrayB)
        
        let arrayC = [20, 21, 23, 24]
        for item in arrayC {
            let node = ZAlgoListNode.init(item)
            list?.appendNodeToTail(node: node)
            listB.appendNodeToTail(node: node)
        }
        
        let resultNode: ZAlgoListNode? = getIntersectionNode(headA: list?.head, headB: listB.head)
        if resultNode != nil {
            print("listA 和 listB 相交的第一个节点val = \(resultNode!.val)");
        } else {
            print("listA 和 listB 没有相交的节点")
        }
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
    
    func getIntersectionNode(headA: ZAlgoListNode?, headB: ZAlgoListNode?) -> ZAlgoListNode? {
        guard headA != nil else {
            return nil
        }
        
        guard headB != nil else {
            return nil
        }
        
        let lengthA = headA!._calculateLinkedListLength()
        let lengthB = headB!._calculateLinkedListLength()
        
        let result: Int = lengthA - lengthB
        
        var nodeA: ZAlgoListNode? = headA!
        var nodeB: ZAlgoListNode? = headB!
        
        for _ in 0 ..< abs(result) {
            if result > 0 {
                nodeA = nodeA?.next
            } else {
                nodeB = nodeB?.next
            }
        }
        
        while nodeA != nil && nodeB != nil {
            if nodeA === nodeB {
                return nodeA
            }
            
            nodeA = nodeA?.next
            nodeB = nodeB?.next
        }
        return nil
    }
    
    @objc func reverseListDemo() {
        let array = [1, 2, 3, 4, 5, 6]
        list = createLinkedList(array: array)
        list?.displayAllNodeValue()
        let newList = ZAlgoList.init()
        newList.head = list?.reverserList()
        newList.displayAllNodeValue()
    }
    
    @objc func mergeListDemo() {
        let array = [1, 2, 4];
        list = createLinkedList(array: array)
        print("originalA:");
        list?.displayAllNodeValue()
        let arrayB = [1, 3, 4];
        let listB: ZAlgoList? = createLinkedList(array: arrayB)
        print("originalB:");
        listB?.displayAllNodeValue()
        let headC: ZAlgoListNode? = mergeList(l1: list?.head, l2: listB?.head)
        headC?.displayAllNodeValue()
    }
    
    func mergeList(l1: ZAlgoListNode?, l2: ZAlgoListNode?) -> ZAlgoListNode? {
        let list: ZAlgoList = ZAlgoList.init()
        
        var curHead1: ZAlgoListNode? = l1;
        var curHead2: ZAlgoListNode? = l2;
        
        while curHead1 != nil && curHead2 != nil {
            if curHead1 != nil && curHead2 == nil {
                list.appendNodeToTail(node: curHead1)
            } else if curHead1 == nil && curHead2 != nil {
                list.appendNodeToTail(node: curHead2)
            } else {
                if curHead1!.val <= curHead2!.val {
                    list.appendToTail(val: curHead1!.val)
                    curHead1 = curHead1!.next
                } else {
                    list.appendToTail(val: curHead2!.val)
                    curHead2 = curHead2!.next
                }
            }
        }
        return list.head
    }
    
    @objc func mergeListWithRecursionDemo() {
        let array = [1, 2, 4];
        list = createLinkedList(array: array)
        print("originalA:");
        list?.displayAllNodeValue()
        let arrayB = [1, 3, 4];
        let listB: ZAlgoList? = createLinkedList(array: arrayB)
        print("originalB:");
        listB?.displayAllNodeValue()
        let headC: ZAlgoListNode? = mergeTwoListsWithRecursion(l1: list?.head, l2: listB?.head)
        headC?.displayAllNodeValue()
    }
    
    func mergeTwoListsWithRecursion(l1: ZAlgoListNode?, l2: ZAlgoListNode?) -> ZAlgoListNode? {
        guard l1 != nil else {
            return l2;
        }
        
        guard l2 != nil else {
            return l1;
        }
        
        var resultHead: ZAlgoListNode!
        if l1!.val <= l2!.val {
            resultHead = ZAlgoListNode.init(l1!.val)
            resultHead.next = mergeTwoListsWithRecursion(l1: l1!.next, l2: l2!)
        } else {
            resultHead = ZAlgoListNode.init(l2!.val)
            resultHead.next = mergeTwoListsWithRecursion(l1: l1!, l2: l2!.next)
        }
        return resultHead
    }
    
    @objc func findKthNodeToTailDemo() {
        let array = [1, 2, 4, 5, 9, 10, 13, 25, 34, 49, 51, 62, 70];
        list = createLinkedList(array: array)
        print("originalA:");
        list?.displayAllNodeValue()
        let kthNode = findKthNodeToTail(head: list?.head, k: 5)
        print("5th to tail is \(String(describing: kthNode?.val))")
    }
    
    func findKthNodeToTail(head: ZAlgoListNode?, k: Int) -> ZAlgoListNode? {
        guard head != nil else {
            return nil
        }
        
        var pAhead: ZAlgoListNode? = head
        var pBehind: ZAlgoListNode? = nil
        for _ in 0 ..< k - 1 {
            if pAhead?.next != nil {
                pAhead = pAhead?.next
            } else {
                return nil;
            }
        }
        
        pBehind = head
        while pAhead?.next != nil {
            pAhead = pAhead?.next
            pBehind = pBehind?.next
        }
        return pBehind
    }
}
