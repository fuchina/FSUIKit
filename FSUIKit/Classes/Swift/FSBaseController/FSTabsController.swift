//
//  FSTabsController.swift
//  FSUIKit
//
//  2026-10-15 退役（全 SwiftUI 化收尾）：
//  原 `open class FSTabsController: UITabBarController`（只设 245/255 灰底），
//  供「少数几个页面的分页控制器」使用。
//
//  删除前已全量 grep（Private 全部 pod + 主工程）：**无子类、无实例化、无类型引用**。
//
//  SwiftUI 等价物：`AppRootScreen` 的 `TabView`（tab 数量仍由 `FSJZAPP.VIP()` 决定）。
//

import UIKit
