//
//  ZAlgoDemoSwiftPrefixHeader.swift
//  ZAlgoDemoSwift
//
//  Created by zjixin on 2019/7/16.
//  Copyright © 2019 zjixin. All rights reserved.
//

import UIKit
import Foundation

let KScreenWidth = UIScreen.main.bounds.width
let KScreenHeight = UIScreen.main.bounds.height

let KDevice_iPhoneXSeries = (__CGSizeEqualToSize(CGSize.init(width: 375.0, height: 812.0), UIScreen.main.bounds.size) || __CGSizeEqualToSize(CGSize.init(width: 414.0, height: 896.0), UIScreen.main.bounds.size))

let KNavHeight = CGFloat(KDevice_iPhoneXSeries ? 88.0 : 64.0)
let KTabBarHeight = CGFloat(KDevice_iPhoneXSeries ? 83.0 : 49.0)
let KStatusBarHeight = CGFloat(KDevice_iPhoneXSeries ? 44.0 : 20.0)
let KBottomMargin = CGFloat(KDevice_iPhoneXSeries ? 34.0 : 0)
