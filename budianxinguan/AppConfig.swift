//
//  appConfig.swift
//  budianxinguan
//
//  Created by yjj on 2020/12/19.
//  Copyright © 2020 budianxinguan. All rights reserved.
//

import UIKit

let kScreenWidth:CGFloat = UIScreen.main.bounds.size.width
let kScreenHeight:CGFloat = UIScreen.main.bounds.size.height
enum riskLevel:NSInteger {
    case high = 0
    case low
    case custom
}
enum status {
    case clicked
    case unClicked
    case virus
    case mark
}

//底部的安全距离
let bottomSafeAreaHeight:CGFloat =  UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
//顶部的安全距离
let topSafeAreaHeight:CGFloat = (bottomSafeAreaHeight == 0 ? 0 : 24)
//状态栏高度
let statusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height;
//导航栏高度
let navigationHeight:CGFloat = (bottomSafeAreaHeight == 0 ? 64 : 88)
//tabbar高度
let tabBarHeight:CGFloat = (bottomSafeAreaHeight + 49)

