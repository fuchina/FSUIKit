// FSViewS.swift
// Translated from FSView.h/m

import UIKit

@objcMembers
public class FSViewS: UIView {
    
    private var _tapBackView: UIView!
    private var _gradientLayer: CAGradientLayer?
    
    public var tapBackView: UIView { return _tapBackView }
    
    public var click: ((FSViewS) -> Void)?
    public var clickLocation: ((FSViewS, CGPoint) -> Void)?
    
    public var gradientLayer: CAGradientLayer {
        if _gradientLayer == nil {
            let gl = CAGradientLayer()
            gl.frame = bounds
            layer.insertSublayer(gl, at: 0)
            _gradientLayer = gl
        }
        return _gradientLayer!
    }
    
    public var theTag: Int = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        fsAddTapEventInBaseView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fsAddTapEventInBaseView()
    }
    
    private func fsAddTapEventInBaseView() {
        _tapBackView = UIView(frame: bounds)
        addSubview(_tapBackView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(fsTapClickEvent(_:)))
        _tapBackView.addGestureRecognizer(tap)
    }
    
    @objc private func fsTapClickEvent(_ tap: UITapGestureRecognizer) {
        click?(self)
        
        if let clickLoc = clickLocation {
            let p = tap.location(in: _tapBackView)
            clickLoc(self, p)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _tapBackView.frame = bounds
        _gradientLayer?.frame = bounds
    }
    
    public static func view(withTheTag tag: Int, in inView: UIView) -> FSViewS? {
        for sub in inView.subviews {
            if let fsView = sub as? FSViewS, fsView.theTag == tag {
                return fsView
            }
        }
        return nil
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
