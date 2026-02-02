// FSBackgroundViewS.swift
// Translated from FSBackgroundView.h/m

import UIKit

@objcMembers
public class FSBackgroundViewS: UIView {
    
    public var tap: ((FSBackgroundViewS) -> Void)?
    
    deinit {
        #if DEBUG
        print("FSBackgroundViewS dealloc")
        #endif
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backDesignViews()
    }
    
    private func backDesignViews() {
        let backView = UIView(frame: bounds)
        backView.backgroundColor = .black
        backView.alpha = 0.28
        addSubview(backView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backView.addGestureRecognizer(tapGesture)
    }
    
    public func showView(_ view: UIView, completion: ((FSBackgroundViewS, Bool) -> Void)?) {
        view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: view.frame.width, height: view.frame.height)
        
        UIView.animate(withDuration: 0.25, animations: {
            view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - view.frame.height, width: view.frame.width, height: view.frame.height)
        }, completion: { finished in
            completion?(self, finished)
        })
    }
    
    public func dismissView(_ view: UIView, completion: ((FSBackgroundViewS, Bool) -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: view.frame.width, height: view.frame.height)
        }, completion: { finished in
            completion?(self, finished)
        })
    }
    
    @objc public func dismiss() {
        tap?(self)
    }
}
