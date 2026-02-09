//
//  FSViewS.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/29.
//

import Foundation

open class FSView: UIView {
    
    public var  tapBackView                             :   UIView?                             =   nil
    public var  click                                   :   ((FSView, CGPoint) ->  Void)?       =   nil
    
    public var  theTag                                  :   Int                                 =   0
    
    private var _gradientLayer                          :   CAGradientLayer?

    lazy var gradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        g.frame = bounds
        self.layer.insertSublayer(g, at: 0)
        return g
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.tapBackView != nil {
            self.tapBackView?.frame = bounds
        }
        
        if let gradientLayer = _gradientLayer {
            gradientLayer.frame = bounds
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.fs_add_tap_event_in_base_view()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fs_add_tap_event_in_base_view() {
        tapBackView = UIView(frame: bounds)
        self.addSubview(tapBackView!)
        
        let one = UITapGestureRecognizer(target: self, action: #selector(_fs_tap_click_event(_:)))
        tapBackView!.addGestureRecognizer(one)
    }
    
    @objc func _fs_tap_click_event(_ tap: UITapGestureRecognizer) {
        
        if self.click != nil {
            let p = tap.location(in: tapBackView)
            self.click!(self, p)
        }
    }
    
    public static func viewWithTheTag(tag: Int, view: UIView) -> FSView? {
        
        for sub in view.subviews {
            if sub is FSView {
                let subs: FSView = sub as! FSView
                if subs.theTag == tag {
                    return subs
                }
            }
        }
        
        return nil
    }
    
    open func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { f in
            self.removeFromSuperview()
        }
    }
}
