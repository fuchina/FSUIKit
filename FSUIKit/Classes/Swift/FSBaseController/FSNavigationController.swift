//
//  FSNavigationController.swift
//  FSUIKit
//
//  2026-10-15 退役（全 SwiftUI 化收尾）：
//  原 `open class FSNavigationController: UINavigationController, UINavigationBarDelegate`
//  只做一件事：对每个非根页自动置 `hidesBottomBarWhenPushed = true`。
//
//  删除前已全量 grep（Private 全部 pod + 主工程）：**无子类、无实例化、无类型引用**
//  （每个 tab 的栈现由 `FSPushStack`（NavigationStack + FSPageRoute）承担）。
//
//  SwiftUI 等价物：`FSPushStack` / `NavigationStack`；「push 二级页是否隐藏 tab bar」
//  由 FSPushStack 的 navigationDestination 统一处理，不需要再靠 UIKit 属性。
//

import UIKit
