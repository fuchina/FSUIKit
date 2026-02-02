// FSCloundViewS.swift
// Translated from FSCloundView.h/m

import UIKit

@objcMembers
public class FSCloundViewS: UIView {
    
    public var margin: UIEdgeInsets = .zero
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 0.6
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let currentPoint = touch.location(in: self)
        let prePoint = touch.previousLocation(in: self)
        let offsetX = currentPoint.x - prePoint.x
        let offsetY = currentPoint.y - prePoint.y
        
        transform = transform.translatedBy(x: offsetX, y: offsetY)
        
        guard let superView = superview else { return }
        
        if frame.origin.x < margin.left {
            frame = CGRect(x: margin.left, y: frame.origin.y, width: bounds.width, height: bounds.height)
        }
        if frame.origin.x > (superView.frame.width - margin.right - bounds.width) {
            frame = CGRect(x: superView.frame.width - margin.right - bounds.width, y: frame.origin.y, width: bounds.width, height: bounds.height)
        }
        if frame.origin.y < margin.top {
            frame = CGRect(x: frame.origin.x, y: margin.top, width: bounds.width, height: bounds.height)
        }
        if frame.origin.y > (superView.frame.height - margin.bottom - bounds.height) {
            frame = CGRect(x: frame.origin.x, y: superView.frame.height - margin.bottom - bounds.height, width: bounds.width, height: bounds.height)
        }
    }
}
