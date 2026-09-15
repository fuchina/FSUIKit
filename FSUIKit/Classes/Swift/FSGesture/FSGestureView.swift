//
//  FSGestureView.swift
//  myhome
//
//  Created by FudonFuchina on 2017/8/31.
//  Copyright © 2017年 fuhope. All rights reserved.
//

import UIKit

public class FSGestureView: UIView {
    
    public var start: (() -> Void)?
    public var result: ((String) -> Void)?
    
    private var points: [FSCircleLayer] = []
    private var values: [FSCircleLayer] = []
    private var currentPoint: CGPoint = .zero
    private let color = UIColor(red: 18/255.0, green: 152/255.0, blue: 233/255.0, alpha: 1)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        gestureDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        gestureDesignViews()
    }
    
    private func gestureDesignViews() {
        backgroundColor = .white
        
        let space: CGFloat = 10
        let layerWidth: CGFloat = 60
        let zone: CGFloat = 100
        
        for x in 0..<9 {
            let circleLayer = FSCircleLayer()
            circleLayer.index = x
            circleLayer.frame = CGRect(
                x: space + Double(x % 3) * zone,
                y: space + Double(x / 3) * zone,
                width: layerWidth,
                height: layerWidth
            )
            circleLayer.cornerRadius = circleLayer.bounds.height / 2
            circleLayer.borderColor = color.cgColor
            circleLayer.borderWidth = 1
            layer.addSublayer(circleLayer)
            points.append(circleLayer)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleTouches(touches)
        start?()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handleTouches(touches)
        setNeedsDisplay()
    }
    
    private func handleTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        currentPoint = point
        
        if let circleLayer = pointInCircle(point), !values.contains(where: { $0 === circleLayer }) {
            values.append(circleLayer)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        resetCircleLayers()
        setNeedsDisplay()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let str = values.map { String($0.index) }.joined()
        result?(str)
        resetCircleLayers()
    }
    
    private func resetCircleLayers() {
        for circleLayer in values {
            circleLayer.setStatus(false)
        }
        values.removeAll()
        setNeedsDisplay()
    }
    
    private func pointInCircle(_ point: CGPoint) -> FSCircleLayer? {
        for circleLayer in points {
            if circleLayer.frame.contains(point) {
                return circleLayer
            }
        }
        return nil
    }
    
    public override func draw(_ rect: CGRect) {
        guard !values.isEmpty else { return }
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let path = UIBezierPath()
        
        UIColor.blue.setFill()
        UIColor.red.setStroke()
        context.setLineWidth(1)
        path.lineJoinStyle = .miter
        color.set()
        
        for (index, circleLayer) in values.enumerated() {
            circleLayer.setStatus(true)
            let size = circleLayer.frame.size
            let origin = circleLayer.frame.origin
            let center = CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
            
            if index == 0 {
                path.move(to: center)
            } else {
                path.addLine(to: center)
            }
        }
        path.addLine(to: currentPoint)
        context.addPath(path.cgPath)
        context.strokePath()
    }
}
