// FSButtonViewS.swift
// Translated from FSButtonView.h/m

import UIKit

public class FSButtonView: UIView {
    
    private var _backView: UIView!
    private var _button: UIButton?
    
    public var tap: ((FSButtonView) -> Void)?
    
    public var button: UIButton {
        if _button == nil {
            let btn = UIButton(type: .system)
            btn.frame = CGRect(x: 5, y: frame.height / 2 - 18, width: frame.width - 10, height: 36)
            btn.layer.cornerRadius = 18
            btn.addTarget(self, action: #selector(tapClick), for: .touchUpInside)
            addSubview(btn)
            _button = btn
        }
        return _button!
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        buttonDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buttonDesignViews()
    }
    
    private func buttonDesignViews() {
        _backView = UIView(frame: bounds)
        addSubview(_backView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        _backView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapClick() {
        tap?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _button?.frame = CGRect(x: 5, y: frame.height / 2 - 18, width: frame.width - 10, height: 36)
    }
}
