//
//  ZAlgoDemoLeetCodeViewController.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/7/1.
//  Copyright © 2019 zjixin. All rights reserved.
//

import UIKit

let leetCodeIdenfifier = "ZAlgoLeetCodeCell"

/// LeetCode算法
///
/// https://github.com/knightsj/awesome-algorithm-question-solution
///
/// /Users/zjixin/Document/zjixin/Library/awesome-algorithm-question-solution
class ZAlgoDemoLeetCodeViewController: UITableViewController {
    var dataSource:Array<Dictionary<String, String>>!
    var stepCount:Int = 0
    lazy var textView:UITextView = {
        let textView:UITextView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 200))
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .black
        textView.backgroundColor = .brown
        return textView
    }()
    
    var fibonacciResult: Dictionary<NSInteger, NSInteger>?
    
    override func viewDidLoad() {
        setupData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: leetCodeIdenfifier)
        self.tableView.tableFooterView = self.textView
        self.tableView.reloadData()
    }
    
    func setupData() {
        self.dataSource = [
            ["title" : "1. two-sum",
             "action" : "twoSumDemo"],
            
            ["title" : "2. 三数和等于0",
             "action" : "threeSumEqualToZeroDemo"],
            
            ["title" : "3. Fibonacci(斐波那契额数列)",
             "action" : "fibonacciDemo"],
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: leetCodeIdenfifier, for: indexPath)
        let item = self.dataSource[indexPath.row]
        let title = item["title"]
        cell.textLabel?.text = title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dic:Dictionary = self.dataSource[indexPath.row]
        let action:String! = dic["action"]
        self.stepCount = 0
        if (action != nil) {
            let sel:Selector! = Selector.init(action)
            if (self.responds(to: sel)) {
                self.perform(sel, with: dic)
            }
        }
    }
    
    //MARK: action
    
    @objc func twoSumDemo() {
        
        let nums = [2, 7, 11, 15, -2, -6]
        let target = 9
        
        var string = #function + "\n"
        string.append(contentsOf: "target = \(target)\n")
        string.append(contentsOf: "nums = \(nums)\n")
        
        //第一种方法是通过for循环套for循环
        let resultOne = twoSumNormal(array: nums, target: target)
        string.append(contentsOf: "for in for stepCount = \(self.stepCount)\n")
        string.append(contentsOf: "result one = \(resultOne)\n")
        
        //第二种方法, 通过Dic<value, index>记录已经遍历过得值，如果有等于targe-value的，则从dic中取出对应的index，和当前value的index就为之和为目标值的index
        self.stepCount = 0
        let result = twoSum(array: nums, target: target)
        print(result)
        string.append(contentsOf: "for stepCount = \(self.stepCount)\n")
        string.append(contentsOf: "result two = \(result)")
        
        self.textView.text = string
        
    }
    
    func twoSumNormal(array: Array<Int>, target: Int) -> Array<Array<Int>>{
        var result = Array<Array<Int>>.init()
        for i in 0 ..< array.count - 1 {
            for j in (i + 1) ... (array.count - 1) {
                if target == array[i] + array[j] {
                    result.append([i, j])
                }
                self.stepCount += 1
            }
        }
        return result
    }
    
    func twoSum(array: Array<Int>, target: Int) -> Array<Array<Int>>{
        var recordDic = Dictionary<Int, Int>.init()
        var result = Array<Array<Int>>.init()
        for index in 0 ..< array.count {
            let value = array[index]
            let keys = recordDic.keys
            let contains = keys.contains(target - value)
            if contains && recordDic[target - value] != index {
                result.append([recordDic[target - value] ?? 0, index])
            } else {
                recordDic[value] = index
            }
            self.stepCount += 1
        }
        return result
    }
    
    @objc func threeSumEqualToZeroDemo() {
        let nums = [-1, 0, 1, 2, -1, -4]
        
        var string = #function + "\n"
        string.append(contentsOf: "nums = \(nums)\n")
        
        let resultOne = threeSumEqualToZero(array: nums)
        string.append(contentsOf: "stepCount = \(self.stepCount)\n")
        string.append(contentsOf: "result = \(resultOne)\n")
        
        self.textView.text = string
    }
    
    func threeSumEqualToZero(array: [Int]) -> [[Int]] {
        var array = array.sorted { (a, b) -> Bool in
            return a < b
        }
        var result = [[Int]].init()
        for index in 0 ..< array.count {
            if array[index] > 0 || index >= array.count - 3 {
                break
            }
            if index > 0 && array[index] == array[index - 1] {
                continue
            }
            let target = 0 - array[index]
            var i = index + 1;
            var j = array.count - 1;
            while i < j {
                if array[i] + array[j] == target {
                    result.append([array[index], array[i], array[j]])
                    while i < j && array[i] == array[i + 1] {
                        i += 1
                    }
                    while i < j && array[j] == array[j - 1] {
                        j -= 1
                    }
                    i += 1
                    j -= 1
                } else if array[i] + array[j] < target {
                    i += 1
                } else {
                    j -= 1
                }
                self.stepCount += 1
            }
        }
        return result
    }
    
    @objc func fibonacciDemo() {
        self.fibonacciResult = Dictionary<NSInteger, NSInteger>.init()
        let number = 90
        let value = fibonacci(n: number)
        
        var string = #function + "\n"
        string.append(contentsOf: "stepCount = \(self.stepCount)\n")
        string.append(contentsOf: "fibonacci(\(number)) = \(value)")
        self.textView.text = string
    }
    
    func fibonacci(n: NSInteger) -> NSInteger {
        if n == 0 || n == 1 {
            self.stepCount += 1
            return 1
            
        } else if n > 1 {
            self.stepCount += 1
            if let value = self.fibonacciResult?[n] {
                return value
            } else {
                let result = fibonacci(n: n - 1) + fibonacci(n: n - 2)
                self.fibonacciResult?[n] = result
                return result
            }
            
        } else {
            return 0
            
        }
    }
}
