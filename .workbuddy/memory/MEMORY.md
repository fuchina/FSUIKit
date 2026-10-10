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

## 本机环境坑

- `find` 在 `/Applications/Xcode.app` 下被沙箱挡住（静默返回空），找 Xcode 内部文件用 `ls`/`Glob`。
- `swiftc` 多文件时 zsh **不做词分割**：必须 `FILES=(${(f)"$(find ...)"})` + `"${FILES[@]}"`，
  直接写 `$FILES` 会把整串文件名当成一个路径 → `File name too long`。
- 预置 `DerivedData` 里的 `FSKit.swiftmodule` 是**旧版**，缺 `currentScene` / `HEIGHTFC`，
  拿它做检查会报假错，别用。
