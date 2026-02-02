// FSCurveViewS.swift
// Translated from FSCurveView.h/m

import UIKit

@objcMembers
public class FSCurveModelS: NSObject {
    /// (x,y)坐标点
    public var points: [NSValue] = []
    public var lineColor: UIColor?
    public var lineWidth: CGFloat = 1
    public var lineCapStyle: CGLineCap = .butt
    public var lineJoinStyle: CGLineJoin = .miter
}

@objcMembers
public class FSBezierPathS: UIBezierPath {
    public var model: FSCurveModelS?
    public var index: Int = 0
}

@objcMembers
public class FSCurveViewS: UIView {
    
    public var lines: [FSCurveModelS] = []
    private var _paths: [FSBezierPathS] = []
    
    public var paths: [FSBezierPathS] {
        return _paths
    }
    
    public func findPath(withIndex index: Int) -> FSBezierPathS? {
        return _paths.first { $0.index == index }
    }
    
    public func show() {
        setNeedsDisplay()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let roundColor = UIColor.lightGray.cgColor
        let backColor = UIColor.white.cgColor
        _paths = []
        
        // Check if iPad (simplified check)
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let pointMargin: CGFloat = 15 + (isIPad ? 15 : 0)
        
        for (x, m) in lines.enumerated() {
            let path = FSBezierPathS()
            path.index = x
            
            guard let startValue = m.points.first else { continue }
            let startP = startValue.cgPointValue
            path.move(to: startP)
            
            let addRound = CGFloat(m.points.count) <= pointMargin
            
            for value in m.points {
                let p = value.cgPointValue
                path.addLine(to: p)
                
                // 添加一个小球
                if addRound {
                    let y = p.y - 3
                    if y > 0 {
                        let xPos = p.x - 3
                        if !xPos.isNaN {
                            let layr = CALayer()
                            layr.frame = CGRect(x: p.x - 3, y: y, width: 6, height: 6)
                            layr.cornerRadius = 3
                            layr.backgroundColor = backColor
                            layr.borderColor = roundColor
                            layr.borderWidth = 1
                            layer.addSublayer(layr)
                        }
                    }
                }
            }
            
            path.lineWidth = m.lineWidth
            path.lineCapStyle = m.lineCapStyle
            path.lineJoinStyle = m.lineJoinStyle
            if let color = m.lineColor {
                color.set()
            }
            path.stroke()
            
            _paths.append(path)
        }
    }
}
