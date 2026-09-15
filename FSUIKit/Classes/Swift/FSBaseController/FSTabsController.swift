//
//  FSTabsController.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

/// 用于少数几个页面的分页控制器，因为不复用，页面多了内存有压力
@objc open class FSTabsController: UITabBarController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let rgb: CGFloat = 245.0 / 255.0
        view.backgroundColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1)
    }
}
