//
//  FSSelectSectionController.swift
//  FSUIKit
//
//  2026-10-15 全 SwiftUI 化：
//  → `FSSelectSectionScreen`（List grouped + Section）。
//

import UIKit
import SwiftUI

/// 分组选择列表（原 `FSSelectSectionController`）
public struct FSSelectSectionScreen: View {

    public var array: [[String]] = []
    /// 原 FSSelectSectionBlock：点击 (array, section, row)
    var onSelect: (Int, Int) -> Void

    public init(array: [[String]], onSelect: @escaping (Int, Int) -> Void) {
        self.array = array
        self.onSelect = onSelect
    }

    public var body: some View {
        List {
            ForEach(Array(array.enumerated()), id: \.offset) { section, rows in
                Section {
                    ForEach(Array(rows.enumerated()), id: \.offset) { row, title in
                        Button {
                            onSelect(section, row)
                        } label: {
                            HStack {
                                Text(title)
                                Spacer()
                                // 原 accessoryType = .disclosureIndicator
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color(.systemBackground))
                    }
                }
            }
        }
        .listStyle(.grouped)
        // 原 estimatedSectionHeaderHeight = 0（空 Section 头不占位）
        .environment(\.defaultMinListHeaderHeight, 0)
    }
}
