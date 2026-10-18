# FSUIKit 项目长期笔记

## 工程现状

- `FSUIKit/Classes` **100% Swift**，无 `.h/.m`。deployment_target 18.0，swift 5.9。
- 唯一宿主 App：`/Users/dongdongfu/Documents/GitHub/com.fuhope.jinzha/swift`（Podfile 把
  FSJZBus / FSJZKit / FSAccount / FSOldAccount / FSTututu / FSDiary / FSCounter / FSPassword /
  FSToDo / FSOSS / FSBirthday / FSUIKit / FSKit 全挂上）。其它 `*Private` 目录都是 **pod，不是 App**，
  所以「全局浮层挂在哪」永远只需看 `swift/swift/AppRootScreen.swift`。
- `AppRootScreen` 的 overlay 链：`FSToastOverlay` / `FSAlertHost` / `FSLoadingOverlay` /
  `FSDatePickerOverlay` / `FSHalfListOverlay`。**在 pod 里加浮层要记得这里挂一次**，否则渲染不出来。

## 全局浮层模式（2026-10 全 SwiftUI 化）

统一套路：`XxxCenter`（ObservableObject，`@Published current`，可从任意线程调、内部
`MainActor.assumeIsolated` 切主线程）+ `XxxOverlay`（View，观察 center 渲染）。
`FSToastCenter` / `FSAlertCenter` / `FSLoadingCenter` 等都在 **FSKit**（FSUIKit 依赖它，不能反向）。

**自适应宽气泡的通用写法**（2026-10-18 FSToastOverlay 踩坑）：`frame(maxWidth:)` 若挂在
`background` **内侧**（即直接挂在 `Text` 上），`frame` 自身会撑满上限，背景跟着变固定宽；
正确顺序是「`Text` → padding/minHeight/fixedSize → `background` → `clipShape` → `frame(maxWidth:)` 放最外层」。
`Text` 在有限提议下是 tight-fit 的，短文案按内容宽、超长才吃到上限并换行。

## 弹窗（FSAlertCenter，已 100% SwiftUI）

- 对外签名里**没有** UIKit 类型：`style: FSAlertStyle` / `styles: [FSAlertActionStyle]` /
  `handler: ((FSAlertAction) -> Void)?` / 返回 `Void`。`FSAlertAction.title` 刻意保持 `String?`。
- `FSAlertDialog` 自绘（iPad 强制转 alert，`UIDevice.current.userInterfaceIdiom` 换不掉）。
- `FSAlertKeyboard` 只是把 `UIKeyboardType` 藏起来，渲染时映射回去，**内核仍是 UIKit**。
- `alertInput` 的 `to: UIView` / `controller:` 都已成为 `AnyObject?` 甚至被删；已被用户自己改过签名
  （commit a83c078：删掉 `controller:`、参数全加默认值）。**再写 `controller:` 会报 extra argument。**
- 11 个仓库 `.swift` 里 `UIAlertController` / `UIAlertAction` **只剩注释**。

## `@objc` / NSObject 盘点

- 约 20 处 `@objc` 绝大多数是 ObjC 运行时回调入口（`#selector`、`CADisplayLink`、
  `@objc optional` 协议），删了直接编译失败。唯一可省的模式：`#selector` 版通知 → 闭包版
  `addObserver(forName:...)` + token 数组，`deinit` 手动 `removeObserver`（闭包版**不会**自动注销）。
- FSKit 的 21 个 `class: NSObject` 已清 17 个；必须留 4 个：`FSModelCoder`(NSSecureCoding)、
  `FSLocationManager`(delegate)、`_FSDisplayLinkProxy`(CADisplayLink)、`FSEntity`(57 子类)。
- 跨模块**继承**必须 `open`：`public` 只能跨模块用。遇到 `Cannot inherit from non-open class`
  先想「这个子类是不是真的需要」，别急着去 FSKit 加 open（已删过 `FSTapGestureRecognizerS`）。

## 本机环境坑

- **SwiftUI 宏必须 `-disable-sandbox`**：`xcodebuild ... -disable-sandbox`，且
  `-derivedDataPath /tmp/dd-xxx`（默认 DerivedData 沙箱写不进）。`swiftc` 侧加
  `-Xfrontend -disable-sandbox`，否则 `@State` 报 `SwiftUIMacros.StateMacro could not be found`。
  `-quiet` 成功时无输出，用产物时间戳确认。
- **git 写索引命令要 `dangerouslyDisableSandbox: true`**，否则留 `.git/index.lock` 挡死用户后续操作；
  全局选项写在子命令前：`git --no-optional-locks status`。只读 `git log/diff/show` 安全。
  报完 git 状态顺手 `find <repo>/.git -maxdepth 3 -name "*.lock"` 复查。
- 搜代码用 **Grep(ripgrep)**，别用 BSD grep（不支持 `\s`，混合写法静默不匹配）。
- `find` 在 `/Applications/Xcode.app` 下被沙箱挡住（静默空）；`swiftc` 多文件时 zsh 不做词分割，
  用 `FILES=(${(f)"$(...)"})` + `"${FILES[@]}"`。
- 预置 `DerivedData` 里的 `FSKit.swiftmodule` 是旧版，别拿它做检查。
- 统计磁盘占用必须 `du -sm -x`（不加 `-x` 会把挂载的模拟器映像重复算进去，误差 5–10 倍）。
