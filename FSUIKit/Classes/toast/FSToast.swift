//
//  FSToast.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/31.
//

import Foundation
import FSKit

open class FSToast: NSObject {

    //  2026-10-15 全 SwiftUI 化：
    //  `toast(_:)` / `toast(_:duration:)` 原来要构造 UIView 加到 window 上，必须有 UIView 宿主；
    //  现改为把文案塞进 `FSToastCenter`（SwiftUI 全局浮层，由 AppRootScreen 的
    //  `FSToastOverlay` 渲染）。⇒ 全项目调用点无需改动，也不再依赖 UIView / UIViewController。
    //
    //  2026-10-18 最后一个 UIKit 实现也清掉了：
    //  `toast(_:duration:to:)` 原来自己造 UILabel + UIView、量文字宽度、addSubview 到宿主、
    //  再跑两段 UIView 动画 —— 与上面两条走的是两套渲染，效果和位置都对不齐。
    //  现在它只是把文案转给 `FSToastCenter`，**与不带 `to:` 的调用完全同一条路径**。
    //
    //  `to:` 参数保留只为源码兼容（93 处调用点一行不用改），**内容已被忽略**：
    //  Toast 统一显示在屏幕居中（原先是宿主 view 居中），类型从 `UIView` 放宽为 `AnyObject?`。
    //  待这些调用点自然淘汰后可整条重载删掉。

    public static func toast(_ text: String) {
        self.toast(text, duration: 2)
    }

    public static func toast(_ text: String, duration: Float) {
        FSToastCenter.shared.show(text, duration: Double(duration))
    }

    /// 兼容旧重载：`to:` 已无意义（不再定位到该 UIView），仅为不改调用点而保留。
    public static func toast(_ text: String, duration: Float, to host: AnyObject?) {
        FSToastCenter.shared.show(text, duration: Double(duration))
    }
}
