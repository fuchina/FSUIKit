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

    /// 关闭自动更正（拼音简写 / 编码类输入，默认关）
    public var autocorrectionDisabled: Bool = true

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

    /// 「纯按钮菜单」：居中 alert，**不追加取消按钮**，靠点空白区关闭。
    ///
    /// 与 `alert(style: .alert, ...)` 的唯一差别就是不生成取消按钮。
    /// 别去改 `alert` 的默认值 —— 全项目 113 处调用依赖「默认有取消」。
    public static func alertMenu(title: String = "",
                                 message: String = "",
                                 actionTitles: [String] = [],
                                 styles: [FSAlertActionStyle] = [],
                                 handler: ((FSAlertAction) -> Void)? = nil) {

        showAlertSpec(.alert,
                      title: title,
                      message: message,
                      actionTitles: actionTitles,
                      styles: styles,
                      handler: handler,
                      cancelTitle: "")
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

        // cancelTitle 传空 = 不要取消按钮（点空白区即可关闭，见 FSAlertSpec.tapOutsideToDismiss）。
        // 原来无条件 append，传空会渲染成一个空白按钮。
        if cancelTitle.isEmpty == false {
            let archiveAction = FSAlertAction(title: cancelTitle, style: .cancel)

            specs.append(FSAlertActionSpec(title: cancelTitle, style: .cancel) {
                cancel?(archiveAction)
            })
        }

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
                                           autocorrectionDisabled: cfg.autocorrectionDisabled,
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
        showAlert(title: "温馨提示", message: message, ok: "确定", handler: handler)
    }
    
    public static func showAlertWithTitle(title: String, message: String, ok: String, handler: ((FSAlertAction) -> Void)? = nil) {
        showAlert(title: title, message: message, ok: ok, handler: handler)
    }

    /// 上面两个 `showAlertWith...` 门面的**实际实现**。
    /// 门面签名保持原样（业务方照旧调用），实现统一收在这里。
    static func showAlert(title: String, message: String, ok: String, handler: ((FSAlertAction) -> Void)?) {

        let action = FSAlertAction(title: ok, style: .default)
        FSAlertCenter.shared.show(FSAlertSpec(style: .alert,
                                              title: title,
                                              message: message,
                                              actions: [FSAlertActionSpec(title: ok, style: .default) {
                                                  handler?(action)
                                              }]))
    }
}

// MARK: - SwiftUI 修饰器版 alert（对应系统 `.alert(_:isPresented:actions:message:)`）
//
// 系统 `.alert` 是 UIKit 渲染在系统弹窗层级上的，**加不了"点空白区关闭"** —— 那条路是封死的。
// 这里给一个形状几乎一样的替代品，多一个 `tapOutsideToDismiss`，**默认 true**。
//
// ⚠️ 和系统 API 的唯一差别：内容区不能用 SwiftUI 的 `Button` / `TextField`。
// 系统那个 `.alert { TextField(...); Button(...) }` 之所以能工作，是因为 SwiftUI 内部有一套
// 私有机制从 ViewBuilder 里"抠"出这些声明；闭包返回的是 `some View`，第三方拿不到里面的东西。
// 所以这里用 `FSAlertButton` / `FSAlertTextField` —— 名字、参数、尾随闭包都照着系统写，
// 调用点基本可以整段搬过来。

/// 按钮语义（对应 `ButtonRole`，只保留弹窗用得到的两个）
public enum FSAlertButtonRole {
    case cancel
    case destructive
}

public extension FSAlertKeyboard {

    /// 从 `UIKeyboardType` 转过来。只覆盖弹窗里常见的几种，其余（`.phonePad` / `.emailAddress` …）
    /// 一律退回 `.default` —— 需要的话往 `FSAlertKeyboard` 里加 case 即可。
    init(_ type: UIKeyboardType) {
        switch type {
        case .asciiCapable:            self = .asciiCapable
        case .alphabet:                self = .alphabet
        case .numbersAndPunctuation:   self = .numbersAndPunctuation
        case .numberPad:               self = .numberPad
        case .decimalPad:              self = .decimalPad
        default:                       self = .default
        }
    }
}

/// alert 内容区的一条声明（按钮 / 输入框）
public protocol FSAlertElement {}

/// 弹窗按钮，用法对齐 SwiftUI 的 `Button(_:role:action:)`
public struct FSAlertButton: FSAlertElement {

    let title: String
    let role: FSAlertButtonRole?
    let action: () -> Void

    public init(_ title: String,
                role: FSAlertButtonRole? = nil,
                action: @escaping () -> Void = {}) {
        self.title = title
        self.role = role
        self.action = action
    }
}

/// 弹窗输入框，用法对齐 SwiftUI 的 `TextField(_:text:)`
public struct FSAlertTextField: FSAlertElement {

    var placeholder: String
    var text: Binding<String>
    var keyboard: FSAlertKeyboard = .default
    var clearButton: Bool = false

    public init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self.text = text
    }

    /// 名字故意和 `View.keyboardType` 一致，调用点原样搬过来就行。
    /// （`FSAlertTextField` 不是 View，不会和 SwiftUI 那个同名方法打架）
    public func keyboardType(_ keyboard: FSAlertKeyboard) -> Self {
        var copy = self
        copy.keyboard = keyboard
        return copy
    }

    /// 有内容时右侧显示清除按钮
    public func showsClearButton(_ on: Bool = true) -> Self {
        var copy = self
        copy.clearButton = on
        return copy
    }
}

/// 把内容区的声明收集成数组
@resultBuilder
public enum FSAlertContentBuilder {

    public static func buildBlock(_ components: [FSAlertElement]...) -> [FSAlertElement] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ element: FSAlertButton) -> [FSAlertElement] { [element] }
    public static func buildExpression(_ element: FSAlertTextField) -> [FSAlertElement] { [element] }

    public static func buildOptional(_ component: [FSAlertElement]?) -> [FSAlertElement] { component ?? [] }
    public static func buildEither(first component: [FSAlertElement]) -> [FSAlertElement] { component }
    public static func buildEither(second component: [FSAlertElement]) -> [FSAlertElement] { component }
    public static func buildArray(_ components: [[FSAlertElement]]) -> [FSAlertElement] { components.flatMap { $0 } }
}

public extension View {

    /// 自绘 alert 的 SwiftUI 入口，形状对齐系统 `.alert`。
    ///
    /// ```swift
    /// .fsAlert(input.title, isPresented: $showInput, message: input.message) {
    ///     FSAlertTextField(input.placeholder, text: $inputText)
    ///         .keyboardType(input.keyboard)
    ///     FSAlertButton("取消", role: .cancel) { }
    ///     FSAlertButton(input.confirmTitle) { applyInput() }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - tapOutsideToDismiss: **点遮罩是否关闭，默认 true**（系统 `.alert` 永远是 false，这就是要它的原因）
    ///   - tapOutsideCanDismiss: 附加条件，返回 false 时这一次不关（例如"有内容就不关"）
    func fsAlert(_ title: String,
                 isPresented: Binding<Bool>,
                 message: String = "",
                 tapOutsideToDismiss: Bool = true,
                 tapOutsideCanDismiss: (([String]) -> Bool)? = nil,
                 @FSAlertContentBuilder content: () -> [FSAlertElement]) -> some View {
        modifier(FSAlertPresenter(title: title,
                                  message: message,
                                  tapOutsideToDismiss: tapOutsideToDismiss,
                                  tapOutsideCanDismiss: tapOutsideCanDismiss,
                                  elements: content(),
                                  isPresented: isPresented))
    }
}

/// 把 `isPresented` 和 `FSAlertCenter` 的全局弹窗状态双向同步
private struct FSAlertPresenter: ViewModifier {

    let title: String
    let message: String
    let tapOutsideToDismiss: Bool
    let tapOutsideCanDismiss: (([String]) -> Bool)?
    let elements: [FSAlertElement]

    @Binding var isPresented: Bool

    @ObservedObject private var center = FSAlertCenter.shared
    /// 这一次是我们弹的那条，用来区分"我们被关了"和"别人弹了新的"
    @State private var showingID: UUID?

    func body(content: Content) -> some View {
        content
            .onAppear {
                // 挂载时 isPresented 已经是 true 的情况（例如从别的页面带过来的状态）
                if isPresented, center.current == nil { present() }
            }
            .onChange(of: isPresented) { _, wanted in
                if wanted {
                    if center.current == nil { present() }
                } else if showingID != nil {
                    // 调用方主动置 false：跟着关
                    showingID = nil
                    center.dismiss()
                }
            }
            .onChange(of: center.current?.id) { _, id in
                guard let showing = showingID, id != showing else { return }
                // 我们这条已经不在屏幕上了（点按钮 / 点遮罩 / 别处 dismiss）
                showingID = nil
                writeBackInputs()
                if isPresented { isPresented = false }
            }
    }

    // MARK: 弹

    private func present() {
        var actions: [FSAlertActionSpec] = []
        var inputs: [FSAlertInputSpec] = []

        for element in elements {
            if let button = element as? FSAlertButton {
                actions.append(FSAlertActionSpec(title: button.title, style: style(of: button.role)) {
                    button.action()
                })
            } else if let field = element as? FSAlertTextField {
                let binding = field.text
                inputs.append(FSAlertInputSpec(placeholder: field.placeholder,
                                               keyboardType: field.keyboard,
                                               text: binding.wrappedValue,
                                               showsClearButton: field.clearButton,
                                               commit: { text in binding.wrappedValue = text }))
            }
        }

        let spec = FSAlertSpec(style: .alert,
                               title: title,
                               message: message,
                               actions: actions,
                               inputs: inputs,
                               tapOutsideToDismiss: tapOutsideToDismiss,
                               tapOutsideCanDismiss: tapOutsideCanDismiss)
        // 先记 id 再 show，否则 onChange 会以为是别人的弹窗
        showingID = spec.id
        center.show(spec)
    }

    /// 点遮罩关闭时不会走 `commit`，这里把弹窗里的文本补写回各 Binding
    private func writeBackInputs() {
        let texts = center.inputTexts
        var index = 0
        for element in elements {
            guard let field = element as? FSAlertTextField else { continue }
            if index < texts.count { field.text.wrappedValue = texts[index] }
            index += 1
        }
    }

    private func style(of role: FSAlertButtonRole?) -> FSAlertActionStyle {
        switch role {
        case .cancel:      return .cancel
        case .destructive: return .destructive
        case nil:          return .default
        }
    }
}
