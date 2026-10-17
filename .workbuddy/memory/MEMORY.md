# FSUIKit 项目长期笔记

## 工程现状

- 组件本体 `FSUIKit/Classes` **100% Swift**，无 `.h/.m`。`FSUIKitSample` 里的 ObjC 是历史残留。
- 依赖：MJRefresh / WechatOpenSDK / **FSKit**（本地源码 `/Users/dongdongfu/Documents/GitHub/Private/FSKit`，纯 Swift）。
  实际还隐式用到 Pods 里的 FSCalculator / FSWindow（如 `FSView`），podspec 未声明。
- deployment_target = 18.0，swift_version = 5.9。

## `@objc` 盘点结论（2026-10-10）

全组件约 20 处 `@objc`，**不能全去掉**：绝大多数是 ObjC 运行时回调入口
（`#selector` 版 gesture / addTarget / NotificationCenter、`CADisplayLink`、`@objc optional` 协议前提）。
删 `#selector` 指的方法会直接编译失败。

`FSTextViewController.swift` 已把 2 处 `@objc` **全部去掉**（2026-10-10）：
协议实现那处直接删（自动推断）；`keyboardActionInPropertyBase` 那处改成
**闭包版 `addObserver(forName:object:queue:using:)` + token 数组**，`deinit` 里手动 `removeObserver(token)`。
⚠️ 闭包版**不会**自动注销（selector 版 iOS 9+ 会自动），必须手动清理，否则块常驻通知中心。
→ 能省掉 `@objc` 的模式就这一个，其它 18 处要换成闭包需要额外包装类，收益不大。

## 跨模块继承：FSKit 的类是 `public`，不是 `open`（2026-10-10）

FSUIKit 里继承 FSKit 的类会报
`Cannot inherit from non-open class 'X' outside of its defining module` ——
`public` 只保证跨模块**可用**，跨模块**继承**必须 `open`。

**先判断父类在不在本模块**：
- 在 FSUIKit 自己模块内（`FSView.swift`、`FSBaseController/FSBaseController.swift`）⇒ `public` 也能继承，不报错。
- 在 FSKit 里（目前只有 `FSTapGestureRecognizer`）⇒ 报错。

已解决 1 例：`FSTapGestureRecognizerS`（`UIAlertController+ClickDismissS.swift`）**整个子类删掉** ——
父类本就有 `onTap` 闭包，子类多加的 `clickBack` 是多余的。**不动 FSKit**。
⇒ 以后再遇到，先想「这个子类是不是真的需要」，再考虑要不要去 FSKit 加 `open`。

## 脱离 Xcode 做真 `-typecheck` 的可行路子（已验证）

1. FSKit 全量 `-emit-module` 会死在 SwiftUI 宏上（`FSDeallocModifier.swift`、`FSLikeCellClick.swift`
   用了 `@State`，脱离 Xcode 时宏插件解析失败）⇒ **排除这 2 个文件**即可构建出可用 `FSKit.swiftmodule`。
2. FSKit 会给引用方带 UIKit；手搓 module 不会 ⇒ 引用方（`FSBaseController.swift` 只 import Foundation+FSKit）
   会报 `cannot find type 'UIView' in scope`，**加 `-import-objc-header`**（头里 `#import <UIKit/UIKit.h>`）解决。
3. 全量 45 文件仍会被 `FSView` 等隐式依赖挡住。**够用的最小闭环**：只检查关心的文件 + 用
   `/tmp/stub_base.swift`（`open class FSBaseController: UIViewController { open func componentWillMount() {} }`）
   顶替基类，再带上 `FSNavigationController.swift`。

命令见 `2026-10-10.md`。**校验通过 ≠ 工程能构建**，结论要写明「纯源码校验，未跑构建」。

## `alertInput` 已彻底摘掉 UIKit 中介（2026-10-17）

旧实现：造一个**不上屏**的 `UIAlertController`，用 `addTextField` 跑调用方的
`textFieldConfig`，再把 placeholder/keyboardType/text 读回来塞进 `FSAlertInputSpec`——
容器和输入框全程只当中介。

新签名（`FSUIKit.alertInput`）：

```swift
alertInput(number:title:message:buttons:
           buttonConfig: (FSAlertActionData) -> Void,
           inputConfig: (inout FSAlertInputConfig) -> Void = { _ in },
           tapOutsideToDismiss: Bool = true,
           tapOutsideCanDismiss: (([String]) -> Bool)? = nil)      // 返回 Void，无返回值
```

- `FSAlertInputConfig`：`tag`（=原 `tf.tag`，多输入框靠它分框）、`placeholder`、`text`、
  `keyboardType`、`clearButtonMode`、`autocapitalizationType`。
- `FSAlertActionData.click`：`((UIAlertController, UIAlertAction) -> Void)?` →
  **`((FSAlertAction, [String]) -> Void)?`**（第二参直接给输入文本，按顺序）。
- `completion` 里的 `addTapEvent` 收敛成 `tapOutsideToDismiss`；原 `completion: nil` 的两处
  （`FSAccountController` 配置图/透明度）显式传 `tapOutsideToDismiss: false`。
- 「有内容就不关」（原 `UIAlertController.handleAlertClick`）用
  `tapOutsideCanDismiss: { $0.allSatisfy { $0.isEmpty } }` 表达，FSKit 里配套加了
  `FSAlertSpec.tapOutsideCanDismiss`。

⚠️ **62 处调用点已全部迁移**（FSJZBus 10 / FSJZKit 14 / Tututu 12 / FSCounter 10 /
FSAccount 9 / FSPassword 2 / FSToDo 2 / FSOSS 1 / oldaccount 2），净减约 270 行。
以后再写 `textFieldConfig:` / `alert.textFields` / `completion: { $0.addTapEvent }` 都已编不过。

**行为降级 1 处**：`FSPMController.handleAlertClick(_:point:)` 原来点遮罩会按点击位置切换
输入框焦点（借 `isFirstResponder` / `becomeFirstResponder`，UIKit 专有）。SwiftUI 自绘弹窗
里没有这层 API，现简化为「有内容不关、无内容关」，丢掉焦点切换；用户可直接点输入框换焦点。
`FSPMController` 里 `handleAlertClick` / `isClickUp` 与 `FSPMListController.handleAlertClick` 已删。

**保留未动**：`UIAlertController+ClickDismissS.swift` 的 `addTapEvent`（FSAccount / Tututu /
FSOSS 等对普通 `alert()` 仍在用），只对 `alertInput` 这条路径失效。

## `-Xfrontend -disable-sandbox` 能救 SwiftUI 宏（2026-10-17）

脱离 Xcode 用 `swiftc` 编 FSKit 时，只要文件里有 `@State` / `@FocusState` 就报
`external macro implementation type 'SwiftUIMacros.StateMacro' could not be found` /
`swift-plugin-server produced malformed response`。原来靠「排除那几个文件」绕开，
但 FSAlertCenter 等文件也用了 `@State` 后就绕不开了。

**正解**：加 `-Xfrontend -disable-sandbox`，全量 41 文件一次过，不用排除任何文件。
（与 `xcodebuild -disable-sandbox` 是同一个根因：swift-plugin-server 不能套第二层 sandbox。）

## 本机环境坑

- `find` 在 `/Applications/Xcode.app` 下被沙箱挡住（静默返回空），找 Xcode 内部文件用 `ls`/`Glob`。
- `swiftc` 多文件时 zsh **不做词分割**：必须 `FILES=(${(f)"$(find ...)"})` + `"${FILES[@]}"`，
  直接写 `$FILES` 会把整串文件名当成一个路径 → `File name too long`。
- 预置 `DerivedData` 里的 `FSKit.swiftmodule` 是**旧版**，缺 `currentScene` / `HEIGHTFC`，
  拿它做检查会报假错，别用。
