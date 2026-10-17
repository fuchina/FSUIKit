import UIKit
import FSKit

public struct FSAlertInputConfig {

    public var tag: Int = 0

    public var placeholder: String = ""

    public var text: String = ""

    public var keyboardType: UIKeyboardType = .default

    public var clearButtonMode: UITextField.ViewMode = .never

    public var autocapitalizationType: UITextAutocapitalizationType = .sentences

    public init() {}
}

/// 组件对外 API 的命名空间（纯 `static`，无实例状态）
///
/// 2026-10-17：原来继承 `NSObject`，只为「可能被 ObjC 调用」的历史包袱 ——
/// 实际全项目无一处 ObjC 调用、无 `@objc` 成员、无实例化，`NSObject` 全无作用。
/// 改成无 case 的 `enum`：天然不可实例化，也没有 ObjC 运行时开销。
public enum FSUIKit {

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
        completion?()
    }

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

        let action = FSAlertAction(title: ok, style: .default)
        FSAlertCenter.shared.show(FSAlertSpec(style: .alert,
                                              title: title,
                                              message: message,
                                              actions: [FSAlertActionSpec(title: ok, style: .default) {
                                                  handler?(action)
                                              }]))
    }
    
}
