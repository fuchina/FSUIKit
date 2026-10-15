//
//  FSTapScrollView.swift
//  FSUIKit
//
//  2026-10-15 退役（全 SwiftUI 化收尾）：
//  原 `open class FSTapScrollView: UIScrollView`（「点击收起键盘」的可滚动容器），
//  唯一使用者是 `FSBaseController.scrollView`（同批退役）。
//
//  全量 grep（Private 全部 pod + 主工程）确认：除该属性外无任何实例化 / 类型引用，
//  仅一处历史注释提及（FSImageBedSeeController，说明其 contentInsetAdjustmentBehavior 由来）。
//
//  SwiftUI 等价物：`ScrollView` + `.scrollDismissesKeyboard(.immediately)`。
//

import UIKit
