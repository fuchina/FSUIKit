// FSCurveViewS.swift
// Translated from FSCurveView.h/m

import UIKit

public class FSCurveModel: NSObject {
    /// (x,y)坐标点
    public var points: [NSValue] = []
    public var lineColor: UIColor?
    public var lineWidth: CGFloat = 1
    public var lineCapStyle: CGLineCap = .butt
    public var lineJoinStyle: CGLineJoin = .miter
}

