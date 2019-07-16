//
//  ZAlgoDemoLeetCodeViewController.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/7/1.
//  Copyright © 2019 zjixin. All rights reserved.
//

import UIKit

let leetCodeIdenfifier = "ZAlgoLeetCodeCell"
let leetCodeHeaderIdentifier = "ZAlgoLettCodeHeader"

/// LeetCode算法
///
/// https://github.com/knightsj/awesome-algorithm-question-solution
///
/// /Users/zjixin/Document/zjixin/Library/awesome-algorithm-question-solution
class ZAlgoDemoLeetCodeViewController: UITableViewController {
    var dataSource:Array<Dictionary<String, Any>>!
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
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: leetCodeHeaderIdentifier)
        self.tableView.tableFooterView = self.textView
        self.tableView.reloadData()
    }
    
    func setupData() {
        self.dataSource = [
            ["section" : "Mathematics",
             "data" : [["title" : "1. two-sum",
                        "action" : "twoSumDemo"],
                       
                       ["title" : "2. 三数和等于0",
                        "action" : "threeSumEqualToZeroDemo"],
                       
                       ["title" : "3. Fibonacci(斐波那契额数列)",
                        "action" : "fibonacciDemo"],
                       
                       ["title" : "4. 是否为质数（素数）",
                        "action" : "isPrimeNumberDemo"],
                       
                       ["title" : "5.1 是否为丑数（质因子仅为2，3，5的数）习惯上数字1为第一个丑数",
                        "action" : "isUglyNumberDemo"],
                       
                       ["title" : "5.2 求第n个丑数",
                        "action" : "nthUglyNumberDemo"]]
            ],
//            ["section" : "Array",
//             "data" : [["title" : "1. two-sum",
//                        "action" : "twoSumDemo"],
//
//                       ["title" : "2. 三数和等于0",
//                        "action" : "threeSumEqualToZeroDemo"],
//
//                       ["title" : "3. Fibonacci(斐波那契额数列)",
//                        "action" : "fibonacciDemo"],
//
//                       ["title" : "4. 是否为质数（素数）",
//                        "action" : "isPrimeNumberDemo"],
//
//                       ["title" : "5.1 是否为丑数（质因子仅为2，3，5的数）习惯上数字1为第一个丑数",
//                        "action" : "isUglyNumberDemo"],
//
//                       ["title" : "5.2 求第n个丑数",
//                        "action" : "nthUglyNumberDemo"]]
//            ],
        ]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict: Dictionary! = self.dataSource[section]
        let data: Array? = dict["data"] as? Array<Dictionary<String, String>>
        return data!.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: UITableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: leetCodeHeaderIdentifier)
        
        if header == nil {
            header = UITableViewHeaderFooterView.init(reuseIdentifier: leetCodeHeaderIdentifier)
        }
        
        let dict: Dictionary! = self.dataSource[section]
        let sectionTitle: String? = dict["section"] as? String
        header?.textLabel?.text = sectionTitle;
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: leetCodeIdenfifier, for: indexPath)
        
        let dict: Dictionary! = self.dataSource[indexPath.section]
        let data: Array? = dict["data"] as? Array<Dictionary<String, String>>
        let item = data![indexPath.row]
        let title = item["title"]
        cell.textLabel?.text = title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict: Dictionary! = self.dataSource[indexPath.section]
        let data: Array? = dict["data"] as? Array<Dictionary<String, String>>
        let item = data![indexPath.row]
        let action:String! = item["action"]
        self.stepCount = 0
        if (action != nil) {
            let sel:Selector! = Selector.init(action)
            if (self.responds(to: sel)) {
                self.perform(sel, with: item)
            }
        }
    }
    
    //MARK: Mathematics
    
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
    
    @objc func isPrimeNumberDemo() {
        
        let number = 1234783763
        let value = isPrimeNumber(num: number)
        var string = #function + "\n"
        string.append(contentsOf: "stepCount = \(self.stepCount)\n")
        string.append(contentsOf: "\(number) " + (value == true ? "is" : "is not") + " a prime number")
        self.textView.text = string
    }
    
    func isPrimeNumber(num: NSInteger) -> Bool {
        let temp = sqrt(Double(num))
        for i in 2 ..< NSInteger(temp + 1) {
            self.stepCount += 1
            if num % i == 0 {
                return false
            }
        }
        return true
    }
    
    @objc func isUglyNumberDemo() {
        let number = 1234783763
        let value = isUglyNumber(num: number)
        var string = #function + "\n"
        string.append(contentsOf: "stepCount = \(self.stepCount)\n")
        string.append(contentsOf: "\(number) " + (value == true ? "is" : "is not") + " a ugly number")
        self.textView.text = string
    }
    /// 判断方法首先除2，直到不能整除为止，然后除5到不能整除为止，然后除3直到不能整除为止。最终判断剩余的数字是否为1，如果是1则为丑数，否则不是丑数
    func isUglyNumber(num: NSInteger) -> Bool {
        var temp = num
        
        if num == 0 {
            return false
        } else if num == 1 {
            return true
        }
        
        while temp % 2 == 0 {
            temp = temp / 2
            self.stepCount += 1
        }
        
        while temp % 5 == 0 {
            temp = temp / 5
            self.stepCount += 1
        }
        
        while temp % 3 == 0 {
            temp = temp / 3
            self.stepCount += 1
        }
        
        if temp == 1 {
            return true
        }
        
        return false
    }
    
    @objc func nthUglyNumberDemo() {
        let number = 10
        let value = nthUglyNumber(n: number)
        var string = #function + "\n"
        string.append(contentsOf: "stepCount = \(self.stepCount)\n")
        string.append(contentsOf: "the \(number)th ugly number is \(value)")
        self.textView.text = string
    }
    
    func nthUglyNumber(n: NSInteger) -> NSInteger {
        if n == 0 {
            return 1
        }
        var array = Array.init(repeating: 0, count: n)
        array[0] = 1
        var index2 = 0
        var index3 = 0
        var index5 = 0
        
        //生成前n个丑数的数组，第n个丑数肯定是前面的某个数*2,或者*3，或者*5得到的。
        //1, 2, 3, 4, 5, 6, 8, 9, 10, 12
        //1, 1*2, 1*3, 2*2, 1*5, 2*3, 4*2, 3*3, 5*2, 6*2
        for index in 1 ..< n {
            let min = MIN(array[index2] * 2, MIN(array[index3] * 3, array[index5] * 5))
            array[index] = min
            while array[index2] * 2 <= min {
                index2 += 1
            }
            
            while array[index3] * 3 <= min {
                index3 += 1
            }
            
            while array[index5] * 5 <= min {
                index5 += 1
            }
            self.stepCount += 1
        }
        
        return array[n - 1]
    }
    
    func MIN(_ a: NSInteger, _ b: NSInteger) -> NSInteger {
        if a <= b {
            return a
        } else {
            return b
        }
    }
    
    //MARK: Array
}
