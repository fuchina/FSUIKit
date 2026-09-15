//
//  FSNavigationController.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

@objc public protocol FSNavigationControllerPopDelegate: AnyObject {
    @objc optional func navigationShouldPopOnBackButton() -> Bool
}

@objc open class FSNavigationController: UINavigationController, UINavigationBarDelegate {
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if topViewController != nil {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        var canPop = true
        if let topController = topViewController as? FSNavigationControllerPopDelegate {
            canPop = topController.navigationShouldPopOnBackButton?() ?? true
        }
        return canPop
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if topViewController != nil {
            for viewController in viewControllers {
                if viewController != topViewController {
                    viewController.hidesBottomBarWhenPushed = true
                }
            }
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
}
