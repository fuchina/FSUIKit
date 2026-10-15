//
//  FSTextViewController.swift
//  FSUIKit
//
//  2026-10-15 全 SwiftUI 化：
//  → `FSTextViewScreen`（TextEditor + toolbar「确认」）。
//
//  顺带修复已知缺陷：UIKit 版被 `UIViewControllerRepresentable` 承载时，
//  `navigationItem.rightBarButtonItem`（确认）在 SwiftUI 导航栏下不显示
//  ⇒ `completion` 触发不到（备注改不进去）。SwiftUI 版无此问题。
//
//  说明：原 `canPop` / `navigationShouldPopOnBackButton`（防误触返回丢输入）依赖
//  `FSNavigationController` 的返回拦截，SwiftUI NavigationStack 无对应 API，不再复刻；
//  返回不丢输入，行为更稳妥。
//

import UIKit
import SwiftUI

/// 长文本输入页（原 `FSTextViewController`）
public struct FSTextViewScreen: View {

    public var text: String?
    public var onDone: (String?) -> Void

    @Environment(\.fsNavRouter) private var router
    @State private var editing: String
    @FocusState private var focused: Bool

    public init(text: String? = nil, onDone: @escaping (String?) -> Void) {
        self.text = text
        self.onDone = onDone
        _editing = State(initialValue: text ?? "")
    }

    public var body: some View {
        ZStack {
            TextEditor(text: $editing)
                .font(.system(size: 16))
                .focused($focused)
                .padding(.horizontal, 12)
                .scrollDismissesKeyboard(.never)
        }
        .fsPageBackground()
        .navigationTitle("请输入")
        // 原 navigationItem.rightBarButtonItem「确认」
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("确认") {
                    onDone(editing)
                }
            }
        }
        // 原 textView.becomeFirstResponder()（进入即聚焦）
        .onAppear { focused = true }
    }
}
