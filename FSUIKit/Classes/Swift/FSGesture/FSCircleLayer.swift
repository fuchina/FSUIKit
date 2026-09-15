//
//  FSCircleLayer.swift
//  myhome
//
//  Created by FudonFuchina on 2017/8/31.
//  Copyright © 2017年 fuhope. All rights reserved.
//

import UIKit
import QuartzCore

public class FSCircleLayer: CALayer {
    
    public var index: Int = 0
    
    private var highlighted: Bool = false
    private var subLayer: CALayer?
    
    private static let backColor: CGColor = UIColor.clear.cgColor
    
    private static let innerBackgroundColor: UIColor = UIColor(red: 209/255.0, green: 223/255.0, blue: 234/255.0, alpha: 1.0)
    
    private static let centerBackgroundColor: UIColor = UIColor(red: 54/255.0, green: 133/255.0, blue: 206/255.0, alpha: 1.0)
    
    public func setStatus(_ linked: Bool) {
        highlighted = linked
        setNeedsDisplay()
    }
    
    public override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        if highlighted {
            let circleFrame = bounds
            let circlePath = UIBezierPath(roundedRect: circleFrame, cornerRadius: circleFrame.height / 2.0)
            
            ctx.setFillColor(FSCircleLayer.backColor)
            ctx.addPath(circlePath.cgPath)
            ctx.fillPath()
            
            ctx.setFillColor(FSCircleLayer.backColor)
            ctx.addPath(circlePath.cgPath)
            ctx.fillPath()
            
            if subLayer == nil {
                let width = frame.size.width
                let subWidth = width
                
                let centerLayer = CALayer()
                centerLayer.frame = CGRect(x: subWidth / 2 - 5, y: subWidth / 2 - 5, width: 10, height: 10)
                centerLayer.backgroundColor = FSCircleLayer.centerBackgroundColor.cgColor
                centerLayer.cornerRadius = 5
                addSublayer(centerLayer)
                subLayer = centerLayer
            }
        }
        subLayer?.isHidden = !highlighted
    }
}
