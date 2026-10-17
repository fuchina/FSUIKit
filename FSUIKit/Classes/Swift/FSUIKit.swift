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
    
    @discardableResult
    public static func alert(style: UIAlertController.Style, controller: UIViewController, title: String, message: String, actionTitles: [String], styles: [UIAlertAction.Style], handler: ((UIAlertAction) -> Void)?, cancelTitle: String, cancel: ((UIAlertAction) -> Void)?, completion: (() -> Void)?) -> UIAlertController {
        
        let alertController = self.alertControllerWithStyle(style, title: title, message: message, actionTitles: actionTitles, styles: styles, handler: handler, cancelTitle: cancelTitle, cancel: cancel);
        // 2026-10-15：弹窗已由 FSAlertCenter（SwiftUI 全局弹窗）渲染
        completion?()
        return alertController
    }

    @discardableResult
    public static func alert(style: UIAlertController.Style, controller: UIViewController, title: String, message: String, actionTitles: [String], styles: [UIAlertAction.Style], handler: ((FSAlertAction) -> Void)?) -> UIAlertController {
        
        let ac = self.alertControllerWithStyle(style, title: title, message: message, actionTitles: actionTitles, styles: styles, handler: handler, cancelTitle: "取消", cancel: nil)
        // 2026-10-15：弹窗已由 FSAlertCenter（SwiftUI 全局弹窗）渲染
        return ac
    }
    
    static func alertControllerWithStyle(_ style1: UIAlertController.Style, title:String, message: String, actionTitles: [String], styles: [UIAlertAction.Style], handler: ( (FSAlertAction) -> Void)?, cancelTitle: String, cancel: ((FSAlertAction) -> Void)?) -> UIAlertController {
        
        var style = style1
        if UIDevice.current.userInterfaceIdiom == .pad {
            style = UIAlertController.Style.alert
        }
        
        let count = min(actionTitles.count, styles.count)
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        
        var specs: [FSAlertActionSpec] = []

        // Swift 6 语言模式：`FSAlertAction`（`UIAlertAction` 子类）的 init 是 @MainActor 隔离，
        // 传入的 handler 闭包会被「送」到主隔离域 ⇒ 闭包须为 @Sendable（UIAlertAction 的
        // handler 由 UIKit 在主线程回调），其中捕获的非 Sendable 调用方闭包用
        // FSUncheckedSendable 装箱后跨域携带。本类保持 nonisolated（见 FSAlertCenter 注释）。
        let handlerBox = FSUncheckedSendable(handler)

        for i in 0..<count {
            let action = FSAlertAction(title: actionTitles[i], style: styles[i], handler: { @Sendable act in
                handlerBox.value?(act as! FSAlertAction)
            })
            action.theTag = i
            controller.addAction(action)

            specs.append(FSAlertActionSpec(title: actionTitles[i], style: styles[i]) {
                if handler != nil {
                    handler!(action)
                }
            })
        }
        
        let cancelBox = FSUncheckedSendable(cancel)
        let archiveAction = FSAlertAction(title: cancelTitle, style: .cancel, handler: { @Sendable act in
            cancelBox.value?(act as! FSAlertAction)
        })
        
        controller.addAction(archiveAction)

        specs.append(FSAlertActionSpec(title: cancelTitle, style: .cancel) {
            if cancel != nil {
                cancel!(archiveAction)
            }
        })

        FSAlertCenter.shared.show(FSAlertSpec(isAlert: (style == UIAlertController.Style.alert),
                                              title: title,
                                              message: message,
                                              actions: specs),
                                  container: controller)

        return controller
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

            let act = FSAlertAction(title: data.title, style: data.style, handler: nil)
            act.data = data

            specs.append(FSAlertActionSpec(title: data.title, style: data.style) {
                // 输入文本取自中心：`FSAlertDialog.run` 已先 commit、后 dismiss，
                // 且 `dismiss` 不清 `inputTexts` ⇒ 这里读到的就是用户刚输入的值。
                if data.click != nil {
                    data.click!(act, FSAlertCenter.shared.inputTexts)
                }
            })
        }

        FSAlertCenter.shared.show(FSAlertSpec(isAlert: true,
                                              title: title,
                                              message: message,
                                              actions: specs,
                                              inputs: inputs,
                                              tapOutsideToDismiss: tapOutsideToDismiss,
                                              tapOutsideCanDismiss: tapOutsideCanDismiss))
    }
    
    public static func showAlertWithMessage(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        self.showAlertWithTitle(title: "温馨提示", message: message, ok: "确定", handler: handler)
    }
    
    public static func showAlertWithTitle(title: String, message: String, ok: String, handler: ((UIAlertAction) -> Void)? = nil) {
        // 2026-10-15 全 SwiftUI 化：改走 FSAlertCenter
        let action = UIAlertAction(title: ok, style: .default, handler: nil)
        FSAlertCenter.shared.show(FSAlertSpec(isAlert: true,
                                              title: title,
                                              message: message,
                                              actions: [FSAlertActionSpec(title: ok, style: .default) {
                                                  handler?(action)
                                              }]))
    }
    
}
