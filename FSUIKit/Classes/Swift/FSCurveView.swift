// FSCurveViewS.swift
// Translated from FSCurveView.h/m
//
// 2026-10-30 全 SwiftUI 化：原 `FSCurveView: UIView` 早已退役，只剩这个纯数据模型。
// `lineColor` 从 `UIColor?` 改成 `Color?` —— 它唯一的消费方是 `FSChartController` 的
// SwiftUI `Canvas`（`.color(line.lineColor)`），存 UIKit 颜色等于让调用方来回转换。

import SwiftUI

public class FSCurveModel: NSObject {
    /// (x,y)坐标点
    public var points: [NSValue] = []
    public var lineColor: Color?
    public var lineWidth: CGFloat = 1
    public var lineCapStyle: CGLineCap = .butt
    public var lineJoinStyle: CGLineJoin = .miter
}

