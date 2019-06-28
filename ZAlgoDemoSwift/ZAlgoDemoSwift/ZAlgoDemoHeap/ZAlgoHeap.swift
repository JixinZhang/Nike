//
//  ZAlgoHeap.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/28.
//  Copyright © 2019 zjixin. All rights reserved.
//

import Foundation

/// 堆 heap
///
/// 堆是一个完全二叉树
/// 堆中每个节点的值都必须大于等于（或小于等于）其子节点
/// 此处使用的是大顶堆，父节点大
/// 堆的实现：数组。堆的数据从下标1开始，数组中下标为i的节点的左子节点就是下标为i*2的节点，右子节点就是下标为i*2+1的节点。父节点就是下标为i/2的节点
/// 如果下标从0开始，则数组中下标为i的节点，左子节点的下标就是i*2+1, 右子节点的下标是i*2+2，父节点为(i-1)/2
class ZAlgoHeap: NSObject {
    public var array: Array<Int> = []
    public var capacity: Int = 0
    public var count: Int = 0
    
    public init(capacity: Int) {
        self.capacity = capacity
        self.array = [Int](repeating: 0, count: capacity)
        self.count = 0
    }
    
    public func heap(capacity: Int) -> ZAlgoHeap {
        return ZAlgoHeap.init(capacity: capacity)
    }
    
    /// 向堆里插入一个数据
    ///
    /// 将待插入的值放到数组的最后一个位置，每次和其父节点比较，如果比父节点大，则两者交换，然后重复这个过程，直到查到数组的第0个位置，或者子节点小于父节点
    /// - Parameter value: 插入的值
    public func insert(value: Int) {
        guard count < capacity else {
            return
        }
        array[self.count] = value
        self.count += 1
        var index: Int = self.count - 1
        var parentIndex = (index - 1)/2
        while parentIndex >= 0 && array[index] > array[parentIndex] {
            let temp = array[index]
            array[index] = array[parentIndex];
            array[parentIndex] = temp
            index = parentIndex
            parentIndex = (index - 1)/2
        }
    }
    
    public func removeMax() {
        if count == 0 {
            return
        }
//
//        self.array[0] = self.array[self.count - 1]
//        self.array.removeLast()
//        count -= 1
//        _heapify(array: &self.array, count: count, index: 0)
        let maxValue = self.array.first
        delete(value: maxValue!)
    }
    
    public func delete(value: Int) {
        if self.count == 0 {
            return
        }
        if let index = self.array.firstIndex(of: value) {
            self.array[index] = self.array[self.count - 1]
            self.array.removeLast()
            self.count -= 1
            _heapify(array: &self.array, count: self.count, index: index)
        }
    }
    
    private func _buildHeap(array:inout Array<Int>, count: Int) {
        for index in (0 ... count/2).reversed() {
            _heapify(array: &array, count: count, index: index)
        }
        
    }
    
    /// 堆化
    ///
    /// 从数组第一个开始从上往下。对于不满足父子节点关系的，互换两个节点，并重复这个过程直到父子节点满足大小关系为止
    /// - Parameters:
    ///   - array: 存放堆数据的数组
    ///   - count: 数组的数据
    ///   - index: 开始堆化的位置
    private func _heapify(array:inout Array<Int>, count: Int, index:Int) {
        var index = index
        while true {
            var maxPos = index
            //先判断左子节点
            let leftChildIndex = index * 2 + 1
            if leftChildIndex < count && array[index] < array[leftChildIndex] {
                maxPos = leftChildIndex
            }
            
            let rightChildIndex = index * 2 + 2
            if rightChildIndex < count && array[maxPos] < array[rightChildIndex] {
                maxPos = rightChildIndex
            }
            
            if maxPos == index {
                break
            }
            let temp = array[index]
            array[index] = array[maxPos];
            array[maxPos] = temp
            index = maxPos
        }
    }
    
    ///  堆排序 从数组的下标0到count-1排序
    ///
    /// - Returns: 已排好序的数组
    public func sort() -> [Int] {
        var result = self.array
        _buildHeap(array: &result, count: array.count)
        var k = array.count - 1
        while k > 1 {
            let temp = result[0]
            result[0] = result[k];
            result[k] = temp
            k -= 1
            _heapify(array: &result, count: k, index: 0)
        }
        return result
    }
}
