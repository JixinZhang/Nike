//
//  ZAlgoDemoSortViewController.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/24.
//  Copyright © 2019 zjixin. All rights reserved.
//

import Foundation
import UIKit

let identifier:String = "ZAlgoDemoSwiftCell"

class ZAlgoDemoSortViewController: UITableViewController {
    var dataSource:Array<Dictionary<String, String>>!
    var originalArray:Array<Int>!
    var stepCount:Int = 0
    
    override func viewDidLoad() {
        setupData()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        self.tableView.reloadData()
        
        let count:Int = 1000;
        self.originalArray = [Int](repeating: 0, count: count)
        for index in 0 ..< self.originalArray.count {
            let value:Int = Int(arc4random()) % count
            self.originalArray[index] = value
        }
//        self.originalArray = [6, 1, 2, 7, 9, 3, 4, 5, 10, 8, 6]
    }
    
    func setupData() {
        self.dataSource = [
            ["title" : "1. 冒泡排序",
             "subtitle": "(O(n^2))",
             "action" : "bubbleSortDemo"],
            ["title" : "2. 选择排序",
              "subtitle": "(O(n^2))",
              "action" : "selectSortDemo"],
            ["title" : "3. 插入排序",
             "subtitle": "(O(n^2))",
             "action" : "insertSortDemo"],
//            ["title" : "4. 希尔排序",
//              "subtitle": "(O(n))",
//              "action" : "<#action#>"],
            ["title" : "5.1 归并排序--自顶向下",
             "subtitle": "(O(nlogn))",
             "action" : "mergeSortDemo"],
            ["title" : "5.2 归并排序--自底向上",
             "subtitle": "(O(nlogn))",
             "action" : "mergeBottomToTopDemo"],
            ["title" : "6. 快速排序",
             "subtitle": "(O(nlogn))",
             "action" : "quickSortDemo"],
//            ["title" : "7. 堆排序",
//              "subtitle": "(O(<#n#>))",
//              "action" : "<#action#>"],
//            ["title" : "8. 计数排序",
//              "subtitle": "(O(<#n#>))",
//              "action" : "<#action#>"],
//            ["title" : "9. 桶排序",
//              "subtitle": "(O(<#n#>))",
//              "action" : "<#action#>"],
//            ["title" : "10. 基数排序",
//              "subtitle": "(O(<#n#>))",
//              "action" : "<#action#>"],
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let dic:Dictionary = self.dataSource[indexPath.row]
        let title:String = dic["title"]!
        let subtitle:String = dic["subtitle"]!
        cell.textLabel?.text = title + "--" + subtitle
        
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
    
    @objc
    func bubbleSortDemo() {
        /* 冒泡排序
         1.比较当前的元素和其下一个元素，第一个比第二个大则交换；
         2.一个迭代后最后一个元素是最大
         3.重复上一步，除了最后一个数（最后一个数已经是最大的）
         4.直到没有任何数可以比较
        */
        var temp:Array = self.originalArray
        for i in 0 ..< temp.count - 1 {
            for j in 0 ..< temp.count - 1 - i {
                if temp[j + 1] < temp[j] {
                    let tempValue:Int = temp[j]
                    temp[j] = temp[j + 1]
                    temp[j + 1] = tempValue
                    self.stepCount += 1
                }
            }
        }
        let string:String = #function + " step = " + String.init(format: "%ld", self.stepCount)
        print(string)
        print(temp)
    }
    
    @objc
    func selectSortDemo() {
        /*选择排序是冒泡排序的改进
         1.首先找到最小（最大）的元素放到排序序列的起始位置
         2.再从剩下的未排序序列中找到最小（最大）的元素，放到已排序序列的末尾
         3.重复第二步，直到所有元素均已排序
         */
        var temp:Array = self.originalArray
        for i in 0 ..< temp.count {
            for j in i+1 ..< temp.count {
                if temp[j] < temp[i] {
                    let tempValue:Int = temp[i]
                    temp[i] = temp[j]
                    temp[j] = tempValue
                    self.stepCount += 1
                }
            }
        }
        let string:String = #function + " step = " + String.init(format: "%ld", self.stepCount)
        print(string)
        print(temp)
    }
    
    @objc
    func insertSortDemo() {
        /* 插入排序
         1.将未排序序列的第一个元素作为有序序列，把第二个元素到最后一个元素当做未排序序列
         2.从头到尾一次扫描未排序序列，将每个元素插入到适当的位置（相等，则插入到相等元素的后面）
         */
        var temp:Array = self.originalArray
        for index in 1 ..< temp.count {
            let tempValue = temp[index] //待插入的数
            var j = index - 1;
            
            while(j >= 0 && tempValue < temp[j]) {
                //如果有序数列中的当前数字比tempValue大，则往后移动一位，空出位置给tempValue
                temp[j + 1] = temp[j]
                j -= 1;
                self.stepCount += 1
            }
            temp[j + 1] = tempValue
        }
        let string:String = #function + " step = " + String.init(format: "%ld", self.stepCount)
        print(string)
        print(temp)

    }
    
    @objc
    func quickSortDemo() {
        // https://blog.csdn.net/vayne_xiao/article/details/53508973
        var temp:Array = self.originalArray
        quickSort(array: &temp, left: 0, right: temp.count - 1)
        
        let string:String = #function + " step = " + String.init(format: "%ld", self.stepCount)
        print(string)
        print(temp)
        
    }
    
    func quickSort(array: inout Array<Int>, left:Int, right:Int) {
        if (left > right) {
            return;
        }
        
        var i = left;
        var j = right;
        let key = array[left];
        
        while i < j {
            //让哨兵j从右向左查找小于 key 的值的下标
            while (i < j && key <= array[j]) {
                //当右侧的值大于等于key时，继续查找
                j -= 1;
            }
            
            //让哨兵i从左向右查找大于 key 的值的下标
            while (i < j && key >= array[i]) {
                //当左侧的值小于等于key时，继续查找
                i += 1;
            }
            
            if (i < j) {
                let temp = array[i]
                array[i] = array[j]
                array[j] = temp;
                self.stepCount += 1;
            }
        }
        
        array[left] = array[i]
        array[i] = key
        quickSort(array: &array, left: left, right: i - 1)
        quickSort(array: &array, left: i + 1, right: right)
    }
    
    @objc
    func mergeSortDemo() {
        // https://www.jianshu.com/p/77ba54a46ad7
        var temp:Array = self.originalArray
        mergeSort(array: &temp, left: 0, right: temp.count - 1)
        
        let string:String = #function + " step = " + String.init(format: "%ld", self.stepCount)
        print(string)
        print(temp)
    }
    
    func mergeSort(array: inout Array<Int>, left: Int, right: Int) {
        if (left >= right) {
            return
        }
        let middle = (right + left) / 2;
        mergeSort(array: &array, left: left, right: middle);
        mergeSort(array: &array, left: middle + 1, right: right);
        merge(array: &array, left: left, middle: middle, right: right)
    }
    
    func merge(array: inout Array<Int>, left: Int, middle:Int, right: Int) {
        var middle = middle;
        if middle >= array.count {
            middle = array.count - 1
        }
        var leftArray = [Int](repeating: 0, count: middle - left + 1)
        for index in left ..< middle + 1 {
            let i = index - left;
            leftArray[i] = array[index];
        }
        
        var rightArray = [Int](repeating: 0, count: right - middle)
        for index in middle + 1 ..< right + 1 {
            let i = index - (middle + 1);
            rightArray[i] = array[index]
        }
        
        var i = 0, j = 0
        
        //从左侧left 开始 到最右侧right，将leftArray和rightArray的值按大小顺序放到array中
        for k in left ..< right + 1 {
            
            if i >= leftArray.count {
                //如果leftArray已经全部取完，则直接取rightArray
                array[k] = rightArray[j];
                j += 1;
                
            } else if j >= rightArray.count {
                //如果rightArray已经全部取完，则直接取leftArray
                array[k] = leftArray[i];
                i += 1;
                
            } else if leftArray[i] <= rightArray[j] {
                array[k] = leftArray[i];
                i += 1;
                
            } else if leftArray[i] > rightArray[j] {
                array[k] = rightArray[j]
                j += 1;
            }
            self.stepCount += 1;
        }
    }
    
    @objc
    func mergeBottomToTopDemo() {
        var temp:Array = self.originalArray
        
        var size = 1;
        var i = 0;
        while size < temp.count {
            while i < temp.count {
                let middle = i + size - 1
                merge(array: &temp, left: i, middle: middle, right: min(temp.count - 1, i+2*size-1))
                i += size * 2;
            }
            size += size;
            i = 0;
        }
        
        let string:String = #function + " step = " + String.init(format: "%ld", self.stepCount)
        print(string)
        print(temp)

    }
}
