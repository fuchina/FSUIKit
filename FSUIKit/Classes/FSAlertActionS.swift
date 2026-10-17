//
//  FSAlertActionS.swift
//  FSUIKit
//
//  Created by pwrd on 2026/1/29.
//

import Foundation

public class FSAlertActionData {
    
    public var             index               :   Int                                             =   0
    public var             title               :   String                                          =   ""
    public var             style               :   UIAlertAction.Style                             =   .default
    
    /// 点按钮时回调：第一参是本按钮（`data.index` 区分是哪个），第二参是输入框文本（按顺序）
    ///
    /// 2026-10-17：原签名是 `(UIAlertController, UIAlertAction)`，调用方靠
    /// `alert.textFields?.first?.text` 取输入值 —— 而那个 `UIAlertController` 从不上屏，
    /// 只是中介。现直接给 `[String]`。
    public var             click               :   ((FSAlertAction, [String]) -> Void)?            =   nil
}

public class FSAlertAction: UIAlertAction {
    
    public var             theTag              :   Int                                             =   0
    public var             data                :   FSAlertActionData                               =   FSAlertActionData()
}
