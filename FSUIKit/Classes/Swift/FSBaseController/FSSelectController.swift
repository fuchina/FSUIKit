//
//  FSSelectController.swift
//  FSUIKit
//
//  2026-10-15 全 SwiftUI 化：
//  → `FSSelectScreen`（List + toolbar「确定」）。
//  `FSSelectModel` 数据模型保留（调用方仍在用 `fastModels(withTexts:)`）。
//

import UIKit
import SwiftUI

open class FSSelectModel: NSObject {

    public var selected: Bool = false
    public var content_id: String = ""
    public var content_show: String = ""

    public static func fastModels(withTexts texts: [String]?) -> [FSSelectModel]? {
        guard let texts = texts else { return nil }

        var list: [FSSelectModel] = []
        for txt in texts {
            let m = FSSelectModel()
            m.content_id = txt
            m.content_show = txt
            list.append(m)
        }
        return list
    }

    public static func selectedModels(from models: [FSSelectModel]?) -> [FSSelectModel] {
        guard let models = models else { return [] }
        return models.filter { $0.selected }
    }
}

// MARK: - Screen

/// 单选/多选列表（原 `FSSelectController`）
public struct FSSelectScreen: View {

    let models: [FSSelectModel]
    /// 自定义行内容（默认 Text(content_show)）；原 configCell 的 SwiftUI 化
    var rowContent: ((FSSelectModel) -> AnyView)?
    /// 原 block：点击某行（含 indexPath.row）
    var onSelect: (Int) -> Void
    /// 原 multiSelectCallback：「确定」时回调已选项
    var onConfirm: (() -> Void)?

    public init(models: [FSSelectModel],
                rowContent: ((FSSelectModel) -> AnyView)? = nil,
                onSelect: @escaping (Int) -> Void,
                onConfirm: (() -> Void)? = nil) {
        self.models = models
        self.rowContent = rowContent
        self.onSelect = onSelect
        self.onConfirm = onConfirm
    }

    public var body: some View {
        List {
            ForEach(Array(models.enumerated()), id: \.offset) { idx, m in
                Button {
                    // 原 didSelectRowAt：toggle selected + 回调
                    m.selected = !m.selected
                    onSelect(idx)
                } label: {
                    HStack {
                        if let rowContent {
                            rowContent(m)
                        } else {
                            Text(m.content_show)
                        }
                        Spacer()
                        // 原 accessoryType = m.selected ? .checkmark : .none
                        if m.selected {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .buttonStyle(.plain)
                .frame(height: 55)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color(.systemBackground))
            }
        }
        .listStyle(.plain)
        .background(Color(.systemGroupedBackground))
        // 原 navigationItem.rightBarButtonItem「确定」
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("确定") {
                    onConfirm?()
                }
            }
        }
    }
}
