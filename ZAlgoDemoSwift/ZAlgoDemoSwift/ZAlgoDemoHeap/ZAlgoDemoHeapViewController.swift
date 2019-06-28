//
//  ZAlgoDemoHeapViewController.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/28.
//  Copyright © 2019 zjixin. All rights reserved.
//

import UIKit

let heapIdentifier = "ZAlgoDemoHeapCell"

class ZAlgoDemoHeapViewController: UITableViewController {
    var dataSource:Array<Dictionary<String, String>>!
    var originalArray:Array<Int>!
    var stepCount:Int = 0
    var heap:ZAlgoHeap?
    
    
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: heapIdentifier)
        self.tableView.reloadData()
    }
    
    func setupData() {
        self.dataSource = [
            ["title" : "1. 生成堆 -- 大顶堆",
             "action" : "generateHeap"],
            
            ["title" : "2.1 移除堆顶值",
             "action" : "removeMaxDemo"],
            ["title" : "2.2 移除指定值",
             "action" : "removeValueDemo"],
            
            ["title" : "3. 堆排序",
             "action" : "heapSortDemo"],
        ]
        
        self.originalArray = [33, 17, 13, 16, 18, 25, 19, 27, 50, 34, 58, 66, 51, 55];
    }
    
    //MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: heapIdentifier, for: indexPath)
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
    @objc func generateHeap() {
        self.heap = ZAlgoHeap.init(capacity: self.originalArray.count)
        for element in self.originalArray {
            self.heap?.insert(value: element)
        }
        
        let array = self.heap?.array
        
        var string:String = "\nheap's array = ["
        for element in array! {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func removeMaxDemo() {
        self.heap?.removeMax()
        let array = self.heap?.array
        
        var string:String = "\nheap's array = ["
        for element in array! {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func removeValueDemo() {
        self.heap?.delete(value: 13)
        let array = self.heap?.array
        
        var string:String = "\nheap's array = ["
        for element in array! {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
    
    @objc func heapSortDemo() {
        let array = self.heap?.sort()
        guard array != nil else {
            return
        }
        var string:String = "\nsorted array = ["
        for element in array! {
            string.append(contentsOf: "\(element), ")
        }
        string.append(contentsOf: "]\n\n")
        string.append(#function)
        self.textView.text = string
    }
}
