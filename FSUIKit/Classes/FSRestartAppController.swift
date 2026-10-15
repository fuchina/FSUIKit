//
//  FSRestartAppController.swift
//  FSUIKit
//
//  2026-10-15 全 SwiftUI 化：
//  原 `FSRestartAppController: UIViewController`（白底 + 一个居中的可点 FSTapLabel）
//  → `FSRestartScreen`（SwiftUI 视图）+ `RestartAppBridge`（两种入口）。
//
//  呈现方式仍走 UIKit：① 模态 present（契约边界：模态层不做 SwiftUI 化）
//  ② 直接替换 `window.rootViewController`（SwiftUI 视图同样需要 UIHostingController 承载，
//     这是 SwiftUI 世界的标准接法，不是 UIKit 页面）。
//

import UIKit
import SwiftUI

import FSKit

/// 导入成功后的「请重启 APP」页（原 `FSRestartAppController`）
@MainActor
public struct FSRestartScreen: View {

    public init() {}

    public var body: some View {
        ZStack {
            Color(.systemBackground)

            Text(title)
                .font(.system(size: 20, weight: .bold))
                .multilineTextAlignment(.center)          // 原 numberOfLines = 0
                .foregroundColor(.primary)
                .frame(width: WIDTHFC)                    // 原 frame 宽 WIDTHFC
                // 原 label.y = HEIGHTFC/2 - 30、label 高 80 ⇒ 视觉中心在屏幕中心下方 10pt
                .offset(y: 10)
                .contentShape(Rectangle())
                .onTapGesture {
                    #if targetEnvironment(simulator)
                    // 模拟器上点击即崩溃，用崩溃模拟「重启」
                    let list: [Any] = []
                    _ = list[1]
                    #endif
                }
        }
        .ignoresSafeArea()
        .debugDealloc("FSRestartScreen")
    }

    private var title: String {
        #if targetEnvironment(simulator)
        return "导入成功，请重启APP（模拟器上点击重启）"
        #else
        return "导入成功，请重启APP"
        #endif
    }
}

// MARK: - Bridge

@MainActor
public enum RestartAppBridge {

    /// 以 `.overFullScreen` 模态呈现（原 HAToolController 的用法）
    public static func present(on host: UIViewController? = nil) {
        let vc = UIHostingController(rootView: FSRestartScreen())
        vc.modalPresentationStyle = .overFullScreen
        (host ?? UIApplication.fs_topVC).present(vc, animated: true, completion: nil)
    }

    /// 直接替换 `window.rootViewController`（原 AppDelegate / FSTencentOSSView 的用法）
    public static func setAsRoot() {
        let vc = UIHostingController(rootView: FSRestartScreen())
        FSKit.currentScene()?.keyWindow?.rootViewController = vc
    }
}
