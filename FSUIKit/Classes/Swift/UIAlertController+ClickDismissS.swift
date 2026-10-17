// UIAlertController+ClickDismissS.swift
// Translated from UIAlertController+ClickDismiss.h/m
//
//  2026-10-17：`FSUIKit` 的弹窗改由 SwiftUI `FSAlertHost` 自绘后，弹窗不再由 UIKit
//  `present`，原实现在 keyWindow 的 `UITransitionView` 上挂手势的路径无处可挂
//  （`guard` 直接 return false）⇒ 全项目「点空白区关闭弹窗」静默失效。
//  现改为：把意图登记给 `FSAlertCenter`，由自绘弹窗在遮罩上执行。

import UIKit
import FSKit

public extension UIAlertController {

    /// 登记「点空白区关闭」。
    ///
    /// 只对**当前正在显示**的那条弹窗生效 —— 认领方式是把 `self`（`FSUIKit` 造的
    /// `UIAlertController` 数据容器）与 `FSAlertCenter` 记录的容器比对。
    /// `clickDismiss` 保留原签名（老调用方会在里面再调一次 `controller.dismiss(...)`，
    /// 在 SwiftUI 路径下已是空操作，不会重复关闭）。
    @discardableResult
    func addTapEvent(_ clickDismiss: ((UIAlertController, CGPoint) -> Void)?) -> Bool {
        let container = self
        FSAlertCenter.shared.enableTapOutsideDismiss(for: container, handler: { point in
            clickDismiss?(container, point)
        })
        return true
    }

    func handleAlertClick() {
        let hasData = textFields?.contains { ($0.text?.count ?? 0) > 0 } ?? false
        if !hasData {
            FSAlertCenter.shared.dismiss()
        }
    }
}
