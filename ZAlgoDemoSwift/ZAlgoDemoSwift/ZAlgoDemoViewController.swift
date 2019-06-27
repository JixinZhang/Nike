//
//  ZAlgoDemoViewController.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/6/24.
//  Copyright © 2019 zjixin. All rights reserved.
//

import Foundation
import UIKit

class ZAlgoDemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds)
        tableView.delegate = self;
        tableView.dataSource = self;
        return tableView
    }()
    var dataSource:Array<Dictionary<String, String>>!
    var subVC:UIViewController!
    
    var tableFooterView: UIImageView!
    
    override func viewDidLoad() {
        self.title = "algorithm by swift"
        
        self.dataSource = [
            ["title": "1. 排序算法",
             "subtitle":"",
             "viewController":"ZAlgoDemoSortViewController"],
            
            ["title": "2. 链表(linked list)",
             "subtitle":"",
             "viewController":"ZAlgoDemoLinkedListViewController"],
            
            ["title": "3. 二分查找(Binary search)",
             "subtitle":"",
             "viewController":"ZAlgoDemoBinarySearchViewController"],
            
            ["title": "4. 二叉搜索树(Binary Search tree)",
             "subtitle":"",
             "viewController":"ZAlgoDemoTreeViewController"],
            
            
            ["title" : "0. 其他",
            "subtitle": "",
            "viewController":"ZAlgoDemoStringViewController"],
        ];
        
        self.view.addSubview(self.tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ZAlgoDemoSwiftCell")
        
        self.tableFooterView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 200))
        self.tableFooterView.backgroundColor = .white
        self.tableView.tableFooterView = self.tableFooterView
        
        DispatchQueue.global().async {
            let url = URL.init(string: "https://images.shobserver.com/news/690_390/2017/4/17/7abba2ae-b988-4c15-afeb-ebc7b042b61f.jpg")
            var imageData: Data?
            do {
                try imageData =  Data.init(contentsOf: url!)
            } catch  {
                imageData = nil;
            }
            DispatchQueue.main.async {
                self.tableFooterView.image = UIImage.init(data: imageData!, scale: UIScreen.main.scale)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZAlgoDemoSwiftCell", for: indexPath)
        let dic:Dictionary = self.dataSource[indexPath.row]
        let title:String = dic["title"]!
        let subtitle:String = dic["subtitle"]!
        cell.textLabel?.text = title + " -- " + subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDemo(model: self.dataSource[indexPath.row])
    }
    
    func showDemo(model: Dictionary<String, String>) {
        let vcClassName:String = (model["viewController"] ?? nil)!
        let title:String = (model["title"] ?? nil)!
        
        if (vcClassName == "ZAlgoDemoStringViewController") {
            subVC = ZAlgoDemoStringViewController.init()
        } else if (vcClassName == "ZAlgoDemoSortViewController") {
            subVC = ZAlgoDemoSortViewController.init()
        } else if (vcClassName == "ZAlgoDemoLinkedListViewController") {
            subVC = ZAlgoDemoLinkedListViewController.init()
        } else if (vcClassName == "ZAlgoDemoBinarySearchViewController") {
            subVC = ZAlgoDemoBinarySearchViewController.init()
        } else if (vcClassName == "ZAlgoDemoTreeViewController") {
            subVC = ZAlgoDemoTreeViewController.init()
        } else if (vcClassName == "") {
            
        }
        
        subVC.title = title
        self.navigationController?.pushViewController(subVC, animated: true)
    }

}
