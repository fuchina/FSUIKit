import UIKit
import SwiftUI
import FSKit

public struct FSAlertInputConfig {
    
    public var tag: Int = 0

    public var placeholder: String = ""

    public var text: String = ""

    public var keyboardType: FSAlertKeyboard = .default

    public var showsClearButton: Bool = false

    public var autocapitalization: TextInputAutocapitalization?

    public init() {}
}

public enum FSUIKit {

    public static func alert(style: FSAlertStyle,
                             title: String = "",
                             message: String = "",
                             actionTitles: [String] = [],
                             styles: [FSAlertActionStyle] = [],
                             handler: ((FSAlertAction) -> Void)? = nil,
                             cancelTitle: String = "取消",
                             cancel: ((FSAlertAction) -> Void)? = nil,
                             completion: (() -> Void)? = nil) {

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
                             title: String = "",
                             message: String = "",
                             actionTitles: [String] = [],
                             styles: [FSAlertActionStyle] = [],
                             handler: ((FSAlertAction) -> Void)? = nil) {

        showAlertSpec(style,
                                 title: title,
                                 message: message,
                                 actionTitles: actionTitles,
                                 styles: styles,
                                 handler: handler)
    }

    static func showAlertSpec(_ style1: FSAlertStyle,
                                         title: String = "",
                                         message: String = "",
                                         actionTitles: [String] = [],
                                         styles: [FSAlertActionStyle] = [],
                                         handler: ((FSAlertAction) -> Void)? = nil,
                                         cancelTitle: String = "取消",
                                         cancel: ((FSAlertAction) -> Void)? = nil) {

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
                                           showsClearButton: cfg.showsClearButton,
                                           autocapitalization: cfg.autocapitalization,
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
