//
//  FSShakeBaseController.swift
//  FSUIKit
//
//  2026-10-15 全 SwiftUI 化：本文件已整体退役。
//
//  → 摇一摇统一用 FSKit 的 `View.fsOnShake(_:)`
//    (`FSUIAdapter.swift` 里的 `FSShakeProbe`，零尺寸 UIKit 事件源)。
//  → 「本页重新显示」统一用 FSKit 的 `View.fsOnReturn(includeFirstAppear:_:)`。
//
//  原 `open class FSShakeBaseController` 无任何子类 / 调用点(全项目 grep 证实)，
//  本文件此前临时补的 `FSShakeProbeController` / `FSShakeModifier` / `fsShakeToEdit`
//  也无人调用，一并删除，避免同一能力存在两套实现。
//
