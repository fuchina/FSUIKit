// FSUIKitS.swift
// Translated from FSUIKit.h/m
//
//  2026-10-15 全 SwiftUI 化：`alert / alertInput / showAlertWithMessage` 原来构造
//  UIAlertController 后 `controller.present(...)`，必须有 UIViewController 宿主；
//  现改为交给 `FSAlertCenter`（SwiftUI 全局弹窗，由根视图渲染）。
//  签名保持不变、`controller` 参数被忽略 ⇒ 全项目 343 处调用点一行都不用改。
//
//  2026-10-17 `alertInput` 摘掉 UIKit 中介：原实现造一个**不上屏**的 UIAlertController，
//  靠 `addTextField` 跑调用方的 `textFieldConfig`，再把 placeholder / keyboardType / text
//  读回来塞进 `FSAlertInputSpec` —— 容器和输入框全程只当中介。
//  现改为纯数据 `FSAlertInputConfig`，`click` 直接拿 `[String]`，
//  `completion` 里的 `addTapEvent` 收敛成 `tapOutsideToDismiss`。
//  ⚠️ 这是 breaking change：10 处调用点同步改了（FSJZBus）。

import UIKit

import FSKit

/// 输入弹窗的输入框配置（原 `textFieldConfig: (UITextField) -> Void`）
///
/// 属性名与 `UITextField` 对齐，调用方只改闭包标签、不疑属性写法。
public struct FSAlertInputConfig {

    /// 第几个输入框（0 起，对应原 `UITextField.tag`）——
    /// `number > 1` 时调用方靠它区分「这是表名框还是字段值框」。
    /// 由 `alertInput` 在回调前写入，调用方只读。
    public var tag: Int = 0

    public var placeholder: String = ""
    /// 初始文本（原 `tf.text` 预填）
    public var text: String = ""
    public var keyboardType: UIKeyboardType = .default
    /// `.never` = 不显示清除按钮（原 `tf.clearButtonMode`）
    public var clearButtonMode: UITextField.ViewMode = .never
    public var autocapitalizationType: UITextAutocapitalizationType = .sentences

    public init() {}
}

public class FSUIKit: NSObject {

    /// 普通弹窗（alert / actionSheet）
    ///
    /// 2026-10-17：返回 `Void`（原来返回只是数据容器的 `UIAlertController`，无人使用）；
    /// `handler` / `cancel` 的入参从 `UIAlertAction` 换成纯 Swift 的 `FSAlertAction`
    /// （`title` / `style` 照旧可读）；`style` / `styles` 换成 FSKit 的
    /// `FSAlertStyle` / `FSAlertActionStyle`，调用点 `.alert` / `.destructive` 字面量不用改。
    ///
    /// - Parameter controller: 已无作用（弹窗由根视图渲染），保留只为不破坏调用点。
    public static func alert(style: FSAlertStyle,
                             controller: UIViewController?,
                             title: String,
                             message: String,
                             actionTitles: [String],
                             styles: [FSAlertActionStyle],
                             handler: ((FSAlertAction) -> Void)?,
                             cancelTitle: String,
                             cancel: ((FSAlertAction) -> Void)?,
                             completion: (() -> Void)?) {

        showAlertSpec(style,
                                 title: title,
                                 message: message,
                                 actionTitles: actionTitles,
                                 styles: styles,
                                 handler: handler,
                                 cancelTitle: cancelTitle,
                                 cancel: cancel)
        // 2026-10-15：弹窗已由 FSAlertCenter（SwiftUI 全局弹窗）渲染
        completion?()
    }

    /// 普通弹窗（省略取消按钮与 completion 的便捷版）
    public static func alert(style: FSAlertStyle,
                             controller: UIViewController?,
                             title: String,
                             message: String,
                             actionTitles: [String],
                             styles: [FSAlertActionStyle],
                             handler: ((FSAlertAction) -> Void)?) {

        showAlertSpec(style,
                                 title: title,
                                 message: message,
                                 actionTitles: actionTitles,
                                 styles: styles,
                                 handler: handler,
                                 cancelTitle: "取消",
                                 cancel: nil)
    }

    static func showAlertSpec(_ style1: FSAlertStyle,
                                         title: String,
                                         message: String,
                                         actionTitles: [String],
                                         styles: [FSAlertActionStyle],
                                         handler: ((FSAlertAction) -> Void)?,
                                         cancelTitle: String,
                                         cancel: ((FSAlertAction) -> Void)?) {

        // iPad 上 actionSheet 强制转 alert（原 `UIAlertController` 的做法）
        let style: FSAlertStyle = UIDevice.current.userInterfaceIdiom == .pad ? .alert : style1

        let count = min(actionTitles.count, styles.count)
        var specs: [FSAlertActionSpec] = []

        for i in 0..<count {
            let action = FSAlertAction(title: actionTitles[i], style: styles[i])
            action.theTag = i

            specs.append(FSAlertActionSpec(title: actionTitles[i], style: styles[i]) {
                handler?(action)
            })
        }

        let archiveAction = FSAlertAction(title: cancelTitle, style: .cancel)

        specs.append(FSAlertActionSpec(title: cancelTitle, style: .cancel) {
            cancel?(archiveAction)
        })

        FSAlertCenter.shared.show(FSAlertSpec(style: style,
                                              title: title,
                                              message: message,
                                              actions: specs))
    }
    
    /// 输入弹窗（纯 SwiftUI 渲染，不再构造 `UIAlertController` / `UITextField`）
    ///
    /// - Parameters:
    ///   - buttonConfig: 逐个配置按钮（同原签名）
    ///   - inputConfig: 输入框配置（原 `textFieldConfig: (UITextField) -> Void`）
    ///   - tapOutsideToDismiss: 点遮罩是否关闭。原 `completion` 里那 10 处
    ///     `alert.addTapEvent { controller.dismiss(...) }` 收敛到这里 ——
    ///     回调内容本就只是 dismiss，在 SwiftUI 路径下已是空操作。
    ///   - tapOutsideCanDismiss: 点遮罩时的附加条件，返回 false 则不关。
    ///     原 `UIAlertController.handleAlertClick()` 的「有内容就不关」用它表达。
    public static func alertInput(number: Int,
                                  title: String,
                                  message: String,
                                  buttons: Int,
                                  buttonConfig: (FSAlertActionData) -> Void,
                                  inputConfig: (inout FSAlertInputConfig) -> Void = { _ in },
                                  tapOutsideToDismiss: Bool = true,
                                  tapOutsideCanDismiss: (([String]) -> Bool)? = nil) {

        let count = (1...5).contains(number) ? number : 1

        var inputs: [FSAlertInputSpec] = []
        for i in 0..<count {
            var cfg = FSAlertInputConfig()
            cfg.tag = i
            inputConfig(&cfg)
            inputs.append(FSAlertInputSpec(placeholder: cfg.placeholder,
                                           keyboardType: cfg.keyboardType,
                                           text: cfg.text,
                                           showsClearButton: cfg.clearButtonMode != .never,
                                           autocapitalization: cfg.autocapitalizationType,
                                           commit: { _ in }))
        }

        var specs: [FSAlertActionSpec] = []

        for i in 0..<buttons {
            let data = FSAlertActionData()
            data.index = i
            data.style = .default

            buttonConfig(data)

            let act = FSAlertAction(title: data.title, style: data.style)
            act.data = data

            specs.append(FSAlertActionSpec(title: data.title, style: data.style) {
                // 输入文本取自中心：`FSAlertDialog.run` 已先 commit、后 dismiss，
                // 且 `dismiss` 不清 `inputTexts` ⇒ 这里读到的就是用户刚输入的值。
                if data.click != nil {
                    data.click!(act, FSAlertCenter.shared.inputTexts)
                }
            })
        }

        FSAlertCenter.shared.show(FSAlertSpec(style: .alert,
                                              title: title,
                                              message: message,
                                              actions: specs,
                                              inputs: inputs,
                                              tapOutsideToDismiss: tapOutsideToDismiss,
                                              tapOutsideCanDismiss: tapOutsideCanDismiss))
    }
    
    public static func showAlertWithMessage(_ message: String, handler: ((FSAlertAction) -> Void)? = nil) {
        self.showAlertWithTitle(title: "温馨提示", message: message, ok: "确定", handler: handler)
    }
    
    public static func showAlertWithTitle(title: String, message: String, ok: String, handler: ((FSAlertAction) -> Void)? = nil) {
        // 2026-10-15 全 SwiftUI 化：改走 FSAlertCenter
        let action = FSAlertAction(title: ok, style: .default)
        FSAlertCenter.shared.show(FSAlertSpec(style: .alert,
                                              title: title,
                                              message: message,
                                              actions: [FSAlertActionSpec(title: ok, style: .default) {
                                                  handler?(action)
                                              }]))
    }
    
}
