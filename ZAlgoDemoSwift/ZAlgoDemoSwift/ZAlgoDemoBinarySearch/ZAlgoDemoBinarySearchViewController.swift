//
//  ZAlgoDemoBinarySearchViewController.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/26.
//  Copyright © 2019 zjixin. All rights reserved.
//

import UIKit

let binarySearchIdentifier:String = "ZAlgoDemoBinarySearchCell"

/// 二分查找 https://time.geekbang.org/column/article/42733?code=ypgWw7inxxp2CWvtelI31Hifyl7ACEuJN7Ig-4lhOqI%3D
class ZAlgoDemoBinarySearchViewController: UITableViewController {
    var dataSource:Array<Dictionary<String, String>>!
    var originalArray:Array<Int>!
    var stepCount:Int = 0
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: binarySearchIdentifier)
        
        self.tableView.reloadData()
    }
    
    func setupData() {
        self.dataSource = [
            ["title" : "1. 查找 第一个等于给定值的元素",
             "action" : "binarySearchForTheFirstMatched"],
            ["title" : "2. 查找 最后一个等于给定值的元素",
             "action" : "binarySearchForTheLastMatched"],
            ["title" : "3. 查找 第一个大于等于给定值的元素",
             "action" : "binarySearchForTheFirstBiggerOrEqual"],
            ["title" : "4. 查找 最后一个小于等于等于给定值的元素",
             "action" : "binarySearchForTheLastSmallerOrEqual"],
        ]
        
        self.originalArray = [1, 3, 4, 5, 6, 8, 8, 8, 11, 18];
    }
    
    //MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: binarySearchIdentifier, for: indexPath)
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
            var target = 8
            
            var string:String = "\narray = ["
            for element in self.originalArray {
                string.append(contentsOf: "\(element), ")
            }
            string.append(contentsOf: "]\n\n")
            var result: Int = -1
            if action == "binarySearchForTheFirstMatched" {
                result = binarySearchForTheFirstMatched(self.originalArray, target: target)
                
            } else if action == "binarySearchForTheLastMatched" {
                result = binarySearchForTheLastMatched(self.originalArray, target: target)
                
            } else if action == "binarySearchForTheFirstBiggerOrEqual" {
                target = 7
                result = binarySearchForTheFirstBiggerOrEqual(self.originalArray, target: target)
                
            } else if action == "binarySearchForTheLastSmallerOrEqual" {
                target = 10
                result = binarySearchForTheLastSmallerOrEqual(self.originalArray, target: target)
                
            }
            
            string.append(contentsOf: "result = \(result)\n\n")
            string.append(contentsOf: "target = \(target)\n\n")
            textView.text = string
        }
    }
    
    //MARK: Binary search
    @objc
    func binarySearchForTheFirstMatched(_ array:Array<Int>, target:Int) -> Int {
        var low = 0, high = array.count - 1
        while low <= high {
            let mid = low + (high - low)>>1
            if array[mid] > target {
                high = mid - 1
            } else if (array[mid] < target) {
                low = mid + 1
            } else {
                if mid == 0 || array[mid - 1] != target {
                    return mid
                } else {
                    high = mid - 1;
                }
            }
        }
        return -1
    }
    
    @objc
    func binarySearchForTheLastMatched(_ array: Array<Int>, target:Int) -> Int {
        var low = 0, high = array.count - 1
        while low <= high {
            let mid = low + (high - low)>>1
            if array[mid] > target {
                high = mid - 1
            } else if array[mid] < target {
                low = mid + 1
            } else {
                if mid == 0 || array[mid + 1] != target {
                    return mid
                } else {
                    low = mid + 1
                }
            }
        }
        return -1
    }
    
    @objc
    func binarySearchForTheFirstBiggerOrEqual(_ array: Array<Int>, target:Int) -> Int {
        var low = 0, high = array.count - 1
        while low <= high {
            let mid = low + (high - low)>>1
            if array[mid] >= target {
                if mid == 0 || array[mid - 1] < target {
                    return mid
                } else {
                    high = mid - 1
                }
            } else {
                low = mid + 1
            }
        }
        return -1
    }
    
    @objc
    func binarySearchForTheLastSmallerOrEqual(_ array: Array<Int>, target:Int) -> Int {
        var low = 0, high = array.count - 1
        while low <= high {
            let mid = low + (high - low)>>1
            if array[mid] <= target {
                if mid == 0 || array[mid + 1] > target {
                    return mid
                } else {
                    low = mid + 1
                }
            } else {
                high = mid - 1
            }
        }
        return -1
    }
}
