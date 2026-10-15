//
//  FSBaseController.swift
//  FSUIKit
//
//  2026-10-15 退役（全 SwiftUI 化收尾）：
//  原 `open class FSBaseController: UIViewController` 是全项目 UIKit 页面的基类，提供：
//    · 0.95 灰底 + 点空白收键盘（`_back_tap_view` / `tapActionBase`）
//    · `componentWillMount` / `baseHandleDatas` / `baseDesignViews` / `afterViewCreate` 生命周期钩子
//    · `scrollView`（FSTapScrollView）/ `fs_bottomView` / `showWaitView` 三个视图容器
//    · `fitIOS15` 导航栏白底 appearance、`navigationBar.isTranslucent = true`
//    · `checkForLeakIfLeaving()` 内存泄漏自检（投递 FS_BE_LEAK_NOTIFICATION）
//
//  删除前已全量 grep（Private 全部 pod + 主工程）：**无任何子类**（项目已无 UIKit 页面），
//  `fitIOS15System()` 无外部调用，基类成员只被自己使用。
//
//  SwiftUI 等价物：
//    · 灰底 → `View.fsPageBackground()`；收键盘 → `.scrollDismissesKeyboard`
//    · 底部 45pt 白条 → `.safeAreaInset(edge: .bottom, spacing: 0)`
//    · 导航栏白底 → `.toolbarBackground(Color.white, for: .navigationBar)`
//    · wait 转圈 → `@State loading` + `.overlay { ProgressView() }`
//    · **泄漏自检 → `.debugDealloc("XxxScreen")`**（FSKit 的 FSDeallocModifier，
//      同样投递 FS_BE_LEAK_NOTIFICATION / FS_BE_DEBUG_NOTIFICATION，功能等价且更准）
//

import Foundation

import FSKit
