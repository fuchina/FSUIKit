//
//  FSAlertActionS.swift
//  FSUIKit
//
//  Created by pwrd on 2026/1/29.
//
//  2026-10-17：`FSAlertAction` 不再继承 `UIAlertAction`。
//  弹窗早已由 `FSAlertCenter` 用 SwiftUI 自绘，`UIAlertAction` 只在内存里被当数据载体，
//  从没进过任何 `UIAlertController`。现在它是纯 Swift class，`style` 用 FSKit 的
//  `FSAlertActionStyle`（调用点 `.default` / `.destructive` 字面量写法不变）。
//

import Foundation
import FSKit

public class FSAlertActionData {
    
    public var             index               :   Int                                             =   0
    public var             title               :   String                                          =   ""
    public var             style               :   FSAlertActionStyle                              =   .default
    
    /// 点按钮时回调：第一参是本按钮（`data.index` 区分是哪个），第二参是输入框文本（按顺序）
    ///
    /// 2026-10-17：原签名是 `(UIAlertController, UIAlertAction)`，调用方靠
    /// `alert.textFields?.first?.text` 取输入值 —— 而那个 `UIAlertController` 从不上屏，
    /// 只是中介。现直接给 `[String]`。
    public var             click               :   ((FSAlertAction, [String]) -> Void)?            =   nil
}

/// 一个弹窗按钮（`alert` / `alertInput` 的 handler 收到的就是它）
public class FSAlertAction {

    /// 与原来的 `UIAlertAction.title` 同类型（可选），调用点 `action.title ?? ""` 不用改
    public let title: String?
    public let style: FSAlertActionStyle
    public var theTag: Int = 0
    public var data: FSAlertActionData = FSAlertActionData()

    public init(title: String, style: FSAlertActionStyle = .default) {
        self.title = title
        self.style = style
    }
}
