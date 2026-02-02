// FSRealViewS.swift
// Translated from FSRealView.h/m

import UIKit

@objcMembers
public class FSRealGridViewS: UIView {
    
    private var _label: UILabel?
    
    public var label: UILabel {
        if _label == nil {
            let lbl = UILabel(frame: bounds)
            addSubview(lbl)
            _label = lbl
        }
        return _label!
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _label?.frame = bounds
    }
    
    public func setLabelDefaultStyle() {
        _label?.textAlignment = .center
        _label?.adjustsFontSizeToFitWidth = true
    }
}

@objcMembers
public class FSRealViewS: UIView {
    
    public func designViews(withRows rows: Int, columns: Int, height: CGFloat, configRow: ((CALayer, UnsafeMutablePointer<CGFloat>, UnsafeMutablePointer<CGFloat>, UnsafeMutablePointer<CGFloat>, Int) -> Void)?, configColumn: ((CALayer, UnsafeMutablePointer<CGFloat>, UnsafeMutablePointer<CGFloat>, UnsafeMutablePointer<CGFloat>, Int) -> Void)?, size: ((UnsafeMutablePointer<CGFloat>, Int, Int) -> Void)?, grid: ((FSRealGridViewS, Int, Int) -> Void)?) {
        
        var rowTop: CGFloat = 0
        for row in 0..<(rows + 1) {
            if let configRow = configRow {
                let rowLine = CALayer()
                layer.addSublayer(rowLine)
                
                var rowLineY: CGFloat = 0
                var rowLineWidth: CGFloat = 0
                var rowLineHeight: CGFloat = 0
                configRow(rowLine, &rowLineY, &rowLineWidth, &rowLineHeight, row)
                rowLine.frame = CGRect(x: 0, y: rowTop, width: rowLineWidth, height: rowLineHeight)
                
                rowTop += rowLineY
            }
        }
        
        var columnX: CGFloat = 0
        for column in 0..<(columns + 1) {
            if let configColumn = configColumn {
                let columnLine = CALayer()
                layer.addSublayer(columnLine)
                
                var columnLineX: CGFloat = 0
                var columnLineHeight: CGFloat = 0
                var columnLineWidth: CGFloat = 0
                configColumn(columnLine, &columnLineX, &columnLineHeight, &columnLineWidth, column)
                
                columnLine.frame = CGRect(x: columnX, y: 0, width: columnLineWidth, height: columnLineHeight)
                
                columnX += columnLineX
            }
        }
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        for row in 0..<rows {
            for column in 0..<columns {
                var width: CGFloat = 0
                size?(&width, row, column)
                
                let frame = CGRect(x: x, y: y, width: width, height: height)
                let gridView = FSRealGridViewS(frame: frame)
                addSubview(gridView)
                grid?(gridView, row, column)
                
                x += width
            }
            
            x = 0
            y += height
        }
    }
}
