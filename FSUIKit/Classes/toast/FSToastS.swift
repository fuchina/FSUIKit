//
//  FSToastS.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/31.
//

import Foundation

import FSCalculator

open class FSToastS {
    
    public static func toast(text: String, duration: Float, to: UIView) -> UIView {
        
        let font = UIFont.systemFont(ofSize: 14)
        let width = FSCalculator.textWidth(text, font: font, labelHeight: 40)
        
        let x = UIScreen.main.bounds.width / 2 - width / 2
        
        let label = UILabel(frame: CGRectMake(x, 0, width, 40))
        label.textAlignment = .center
        label.font = font
        label.textColor = UIColor.white
        
        let y = to.bounds.size.height / 2 - 20
        let back = UIView(frame: CGRect(x: x - 10, y: y, width: width + 20, height: 40))
        back.backgroundColor = UIColor.init(red: 73.0 / 255, green: 80 / 255.0, blue: 86.0 / 255, alpha: 0.9)
        back.addSubview(label)
        
        to.addSubview(back)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(duration * 1000)), execute: {
            UIView.animate(withDuration: 0.25) {
                to.alpha = 0
            } completion: { Bool in
                to.removeFromSuperview()
            }
        })
        
        return to
    }
}
