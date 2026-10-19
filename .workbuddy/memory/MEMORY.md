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

## iOS 26 系统 alert 的硬指标（2026-10-18 实测，iPhone 17 Pro / iOS 26.5 模拟器）

自绘想「完全像系统」时按这张表对，别再凭截图猜：

- 面板 **320 × 264**，圆角 **34**；垂直位置是**安全区内居中**（874 屏 → y=319）。
  ⚠️ SwiftUI 的 `ZStack` **本来就在安全区内居中**，别再手动加 `(safeTop - safeBottom)/2` 的偏移。
- 按钮排布（实测确认）：**2 个横排**（各 140×48、间距 8、左右边距 16、圆角 24 胶囊），
  且 `.cancel` **强制在左**（即使 addAction 时把它放在最后）；**3 个及以上竖排**，`.cancel` 落在**最下**。
- 输入行高 **48**（当前代码写 45），输入块圆角 ≈ 16，左右边距 16。
- 遮罩 = 黑色 0.2（背景 200 → 160），`view.alpha` 0→1。
- **键盘避让要自己接管**：`ZStack` 加 `.ignoresSafeArea(.keyboard)` 关掉系统避让，键盘首次弹出时
  算一次 `lift = -(键盘高 - 底部安全区) / 2`（实测 137 = (308-34)/2，与系统避让量精确等价），
  之后 `liftDone` 锁死。否则切换输入框（数字键盘 ↔ 全键盘）时系统会重新居中，面板上下跳。
- 入场 **没有缩放**（面板 transform 恒 1.0），只有 opacity；曲线是
  `CASpringAnimation damping=45.71 stiffness=522.35 mass=1 v0=0 duration=0.404`（ζ=1.0，不过冲）。
  SwiftUI 等价：`.interpolatingSpring(stiffness: 522.35, damping: 45.71)`。
- 面板亮度 rgb(201)，**边缘有 ~19pt 的高光带 rgb(228)** —— 这是 Liquid Glass 的私有折射，SwiftUI 复刻不了。
- **按钮/输入块比面板亮得多**：按钮 **238**、输入块 **236**，面板只有 201（差 37，肉眼一眼能看出来）。
  ⚠️ 采样时**先确认面板的实际 y**，否则很容易打到键盘按键上——键盘键是 rgb(200,202,205)，
  和面板 201 几乎同色，会得出「按钮只比面板亮 4」的错误结论（踩过一次）。
- 材质实测（灰背景 + 0.2 遮罩）：`regularMaterial` 232 / `thinMaterial` 213 / `ultraThinMaterial` 190 /
  `glassEffect(.clear)` 185 / `white.opacity(0.43)` 201。**没有一档能同时对上亮度和模糊。**
  目前选 `thinMaterial` + 5% 黑（≈203），深色模式不压黑。

⇒ 结论：自绘最多做到「像」，要做到「完全一致」只能用 `UIAlertController` 本尊（present 层级）。
探针工程与手法见 `2026-10-18.md`。

## 原生 UIAlertController 的层级与「点外关闭」（2026-10-19 实测，iOS 26.5 + 18.5）

- `alert.view` **就是面板矩形**（iOS 26: 320×172/264/320，圆角 34；iOS 18: **270×141/198/257**）。
  ⚠️ 自绘的 320 宽 / 34 圆角只在 iOS 26 成立，iOS 18 设备上差一截（270 / 约 14）。
- 遮罩是 `presentationController.containerView`（全屏 `UITransitionView`）里的一个 `bg=black@0.20` 的 UIView，
  **不是** alert.view 的一部分。`modalPresentationStyle = .overFullScreen`。
- 点外关闭：手势必须挂 **containerView**（挂 alert.view 收不到，hitTest 直接 nil）；
  delegate 用 `!touch.view.isDescendant(of: alert.view)` 判定，免疫几何/transform/私有类名；
  `cancelsTouchesInView = false`。
- **present 必须串行**：alert 在显示时 present 第二条会**静默失败**（无 completion、view.window == nil、无 warning）。
  在 dismiss completion 里 present 可靠。⇒ 需要 pending 队列。
- alert 在主 window 的 `UITransitionView` 里，层级**高于** rootViewController.view
  ⇒ SwiftUI 的 toast/loading overlay 会被遮罩盖住（换原生后要接受的回归）。

## 弹窗现状（2026-10-19 起）

- `FSAlertCenter` 的 **alert 后端已换成 `UIAlertController`**（`FSAlertDialog` 自绘保留但不再被引用）。
  `actionSheet` 仍走 SwiftUI `confirmationDialog`。`FSAlertHost` 只剩 actionSheet。
- 队列：`pending` + `activeAlert`，50ms 重试上限 5s；present 必须串行（不串行会**静默失败**）。
- `FSUIKit.alert` / `alertInput` / `showAlertWith*` / `.fsAlert` **签名与可调用性均保持原样**
  （曾试过标 `@available(*, unavailable)`，用户要求「接口保留、直接接到新实现」，已撤销）。
  内部统一走 `FSAlertCenter` → `UIAlertController`，370 处调用点零改动。
- 点外关闭：`tapOutsideToDismiss` 是总开关，`tapOutsideCanDismiss` 只是附加条件。
  **2026-10-19 起默认 `true`**（`FSAlertSpec.init` 的默认值），即所有 alert 都能点空白区关闭；
  危险确认类弹窗可显式传 `false`。


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
