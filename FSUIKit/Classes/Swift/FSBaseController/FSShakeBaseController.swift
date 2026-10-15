//
//  FSShakeBaseController.swift
//  FSUIKit
//
//  2026-10-15 全 SwiftUI 化：
//  → `View.fsShakeToEdit(_:)` modifier（零尺寸探针接管 first responder）。
//  原 open class 无任何子类 / 调用点（全项目 grep 证实），随本次迁移移除。
//

import UIKit
import SwiftUI

// MARK: - 摇一摇探针（唯一保留的 UIKit 触点，调用方完全 SwiftUI）

/// 零尺寸承载 VC：`canBecomeFirstResponder = true` + `motionEnded` 回调。
/// 对齐原 `FSShakeBaseController` 的 `applicationSupportsShakeToEdit` / `becomeFirstResponder` 行为。
private final class FSShakeProbeController: UIViewController {

    var onShake: () -> Void = {}

    override var canBecomeFirstResponder: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.applicationSupportsShakeToEdit = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            onShake()
        }
    }
}

private struct FSShakeProbe: UIViewControllerRepresentable {

    var onShake: () -> Void

    func makeUIViewController(context: Context) -> FSShakeProbeController {
        let vc = FSShakeProbeController()
        vc.onShake = onShake
        return vc
    }

    func updateUIViewController(_ uiViewController: FSShakeProbeController, context: Context) {
        uiViewController.onShake = onShake
    }
}

// MARK: - SwiftUI Modifier

/// 摇一摇编辑 modifier（原 `FSShakeBaseController.shakeEndActionFromShakeBase` 的 SwiftUI 化）
public struct FSShakeModifier: ViewModifier {

    var onShake: () -> Void

    public func body(content: Content) -> some View {
        content.background(
            FSShakeProbe(onShake: onShake)
                .frame(width: 0, height: 0)
        )
    }
}

public extension View {

    /// 摇一摇结束回调（原 `FSShakeBaseController` 的 `shakeEndActionFromShakeBase`）
    func fsShakeToEdit(_ onShake: @escaping () -> Void) -> some View {
        modifier(FSShakeModifier(onShake: onShake))
    }
}
