// FSLeftItemS.swift
// Translated from FSLeftItem.h/m

import UIKit

public enum FSItemTitleMode: Int {
    case `default` = 0
    case noChar = 1  // 没有字符
}

@objcMembers
public class FSBackItemView: UIView {
    
    public var mode: FSItemTitleMode = .default
    public var color: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var red: CGFloat = 31 / 255.0
        var green: CGFloat = 143 / 255.0
        var blue: CGFloat = 228.0 / 255.0
        var alpha: CGFloat = 1.0
        
        if let c = color {
            c.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineCap(.round)
        context.setLineWidth(2.5)
        context.setAllowsAntialiasing(true)
        context.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
        
        context.beginPath()
        context.move(to: CGPoint(x: bounds.width * 0.9, y: bounds.width * 0.1))
        context.addLine(to: CGPoint(x: 1, y: frame.height / 2))
        context.addLine(to: CGPoint(x: frame.width * 0.9, y: frame.height * 0.9))
        
        context.strokePath()
    }
}

@objcMembers
public class FSLeftItemS: UIView {
    
    private var backImage: FSBackItemView!
    
    public var mode: FSItemTitleMode = .default {
        didSet {
            guard mode != oldValue else { return }
            backImage.frame = CGRect(x: -5 + 5 * (mode == .noChar ? 1 : 0), y: 12, width: 11, height: 20)
            if mode == .default {
                textLabel?.frame = CGRect(x: backImage.frame.origin.x + backImage.frame.width + 3, y: 7, width: bounds.width - 14, height: 30)
            } else {
                textLabel?.removeFromSuperview()
                textLabel = nil
            }
        }
    }
    
    public var color: UIColor? {
        didSet {
            backImage.color = color
            backImage.setNeedsDisplay()
            textLabel?.textColor = color
        }
    }
    
    public var textLabel: UILabel?
    public var tapBlock: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        leftDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        leftDesignViews()
    }
    
    private func leftDesignViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapActionItem))
        addGestureRecognizer(tap)
        
        backImage = FSBackItemView(frame: CGRect(x: -6.5 + 5 * (mode == .noChar ? 1 : 0), y: 12, width: 11, height: 20))
        addSubview(backImage)
        
        if mode == .default {
            textLabel = UILabel(frame: CGRect(x: backImage.frame.origin.x + backImage.frame.width + 10, y: 7, width: bounds.width, height: 30))
            textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            textLabel?.textColor = UIColor(red: 0, green: 122/255.0, blue: 1, alpha: 1.0)
            addSubview(textLabel!)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 0.28
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        if !frame.contains(currentPoint) {
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    @objc private func tapActionItem() {
        tapBlock?()
    }
}
