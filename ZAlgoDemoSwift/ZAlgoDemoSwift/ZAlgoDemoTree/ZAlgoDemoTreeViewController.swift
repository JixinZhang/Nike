//
//  ZAlgoDemoTreeViewController.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/26.
//  Copyright © 2019 zjixin. All rights reserved.
//

import UIKit

let treeIdentifier = "ZAlgoDemoTreeCell"

class ZAlgoDemoTreeViewController: UITableViewController {
    var dataSource:Array<Dictionary<String, String>>!
    var originalArray:Array<Int>!
    var stepCount:Int = 0
    var tree:ZAlgoBinarySearchTree?
    
    
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
        
        self.subtitle = "subtitle"
    }
    
    func setupData() {
        self.dataSource = [
            ["title" : "1. 生成二叉树",
             "action" : "generateBinarySearchTree"],
            
            ["title" : "2.1 前序遍历(根左右) -- 递归",
             "action" : "bstPreOrderRecursionDemo"],
            ["title" : "2.2 前序遍历(根左右) -- 栈",
             "action" : "preOrderStackDemo"],
            
            ["title" : "3.1 中序遍历(左根右) -- 递归",
             "action" : "inOrderRecursionDemo"],
            ["title" : "3.2 中序遍历(左根右) -- 栈",
             "action" : "inOrderStackDemo"],
        
            ["title" : "3.1 后序遍历(左右根) -- 递归",
             "action" : "postOrderRecursionDemo"],
            ["title" : "3.2 后序遍历(左右根) -- 栈 -- 标记量",
             "action" : "postOrderStackDemo"],
            ["title" : "3.3 后序遍历(左右根) -- 栈 -- 记录",
             "action" : "postOrderStackWithRecordDemo"],
            
            ["title" : "4. 层级遍历 -- 队列",
             "action" : "levelOrderDemo"],
            
            ["title" : "5. 删除二叉树中的节点",
             "action" : "deleteDemo"],
            
            
        ]
        
        self.originalArray = [33, 17, 13, 16, 18, 25, 19, 27, 50, 34, 58, 66, 51, 55];
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
    @objc func generateBinarySearchTree() {
        self.originalArray = [33, 17, 13, 16, 18, 25, 19, 27, 50, 34, 58, 66, 51, 55];
        let rootValue = self.originalArray.first!
        self.originalArray.removeFirst()
        let treeRoot = ZAlgoTreeNode.init(rootValue);
        let tree:ZAlgoBinarySearchTree? = ZAlgoBinarySearchTree.init(root: treeRoot)
        for element in self.originalArray {
            tree?.insert(element)
        }
        self.tree = tree
        
        let maxDepth = self.tree?.maxDepth()
        let isBST: Bool! = self.tree?.isValidBST()
        
        var string:String = "\noriginalData = [\(rootValue),"
        for element in self.originalArray {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\nThe tree ")
        string.append(contentsOf: isBST ? "Is a BST" : "is Not a BST")
        string.append(contentsOf: "\nmax depth = \(maxDepth ?? 0)\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func bstPreOrderRecursionDemo() {
        let result = self.tree?.preOrderRecursion()
        var array:Array<Int> = Array.init()
        if result != nil {
            for node in result! {
                array.append(node.value)
            }
        }
        
        var string:String = "\npreOrder = ["
        for element in array {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func inOrderRecursionDemo() {
        let result = self.tree?.inOrderRecursion()
        var array:Array<Int> = Array.init()
        if result != nil {
            for node in result! {
                array.append(node.value)
            }
        }
        
        var string:String = "\ninOrder = ["
        for element in array {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func postOrderRecursionDemo() {
        let result = self.tree?.postOrderRecursion()
        var array:Array<Int> = Array.init()
        if result != nil {
            for node in result! {
                array.append(node.value)
            }
        }
        
        var string:String = "\npostOrder = ["
        for element in array {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func preOrderStackDemo() {
        let result = self.tree?.preOrderStack()
        var array:Array<Int> = Array.init()
        if result != nil {
            for node in result! {
                array.append(node.value)
            }
        }
        
        var string:String = "\npreOrder = ["
        for element in array {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func inOrderStackDemo() {
        let result = self.tree?.inOrderStack()
        var array:Array<Int> = Array.init()
        if result != nil {
            for node in result! {
                array.append(node.value)
            }
        }
        
        var string:String = "\ninOrder = ["
        for element in array {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func postOrderStackDemo() {
        let result = self.tree?.postOrderStack()
        var array:Array<Int> = Array.init()
        if result != nil {
            for node in result! {
                array.append(node.value)
            }
        }
        
        var string:String = "\npostOrder = ["
        for element in array {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func postOrderStackWithRecordDemo() {
        let result = self.tree?.postOrderStackWithRecord()
        var array:Array<Int> = Array.init()
        if result != nil {
            for node in result! {
                array.append(node.value)
            }
        }
        
        var string:String = "\npostOrder = ["
        for element in array {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func levelOrderDemo() {
        let result = self.tree?.levelOrder()
        var array = [String].init()
        guard result != nil else {
            return
        }
        for element in result! {
            for node in element {
                let leftVal: String! = (node.left != nil) ? String.init(format: "%d", node.left!.value) : "#"
                let righttVal: String! = (node.right != nil) ? String.init(format: "%d", node.right!.value) : "#"
                let string = String.init(format: "%d -> %@, %@", node.value, leftVal ,righttVal)
                array.append(string)
            }
        }
        
        var string:String = "\n层级遍历：\n格式 root -> leftValue, rightValue\n"
        string.append(contentsOf: "'#'表示子节点不存在\n")
        for element in array {
            string.append(contentsOf: "\(element), \n")
        }
        string.append(contentsOf: "\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func deleteDemo() {
        let targe = 50//13
        self.tree?.delete(value: targe)
        preOrderStackDemo()
    }
}

private var subtitleNameKey = "subtitleNameKey"

// MARK: - 分类，类扩展
extension ZAlgoDemoTreeViewController {
    var subtitle: String? {
        get {
            return objc_getAssociatedObject(self, &subtitleNameKey) as? String
        }
        
        set {
            return objc_setAssociatedObject(self, &subtitleNameKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
