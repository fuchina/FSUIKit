//
//  FSSafeRootController.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

@objc open class FSSafeRootController: FSBaseController, UIGestureRecognizerDelegate {
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // 必须这么做，与下面的gestureRecognizerShouldBegin:配合，解决一个bug：
    // 从这个页面跳转到二级、三级页面后，通过右滑手势退出页面到这页面时，
    // 偶现页面卡死，需要退到后台再回到前台时才会恢复且显示二级页面。
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = navigationController,
              nav.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)),
              gestureRecognizer == nav.interactivePopGestureRecognizer,
              let viewControllers = navigationController?.viewControllers,
              !viewControllers.isEmpty,
              nav.visibleViewController == viewControllers[0] else {
            return true
        }
        return false
    }
}
