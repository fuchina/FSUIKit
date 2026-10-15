//
//  FSSafeRootController.swift
//  FSUIKit
//
//  2026-10-15 退役（全 SwiftUI 化收尾）：
//  都是 UIKit 导航栈专属：
//    · viewWillAppear 里接管 `interactivePopGestureRecognizer.delegate`；
//    · `gestureRecognizerShouldBegin` 修「从二/三级页右滑退回根页时偶现卡死」的
//      UIKit bug（visibleViewController == viewControllers[0] 时禁止手势开始）。
//  SwiftUI `NavigationStack` 的边缘返回由系统实现，不经过
//  `UINavigationController.interactivePopGestureRecognizer`，该 bug 在 SwiftUI 下不存在，
//  无需等价物。
//
//  删除前已全量 grep（Private 全部 pod + 主工程）：无任何子类 / 实例化 / 类型引用，
//  仅两处历史注释提及（HAToolController / ARPersonController 均早已转纯 SwiftUI）。
//
