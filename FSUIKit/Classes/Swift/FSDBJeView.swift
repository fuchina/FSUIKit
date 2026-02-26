// FSDBJeViewS.swift
// Translated from FSDBJeView.h/m

import UIKit

open class FSDBJeView: UIView {
    
    public lazy var jeTF: FSLabelTextField = {
        let textField = FSLabelTextField(
            frame: CGRect(x: 0, y: 10, width: frame.size.width, height: 44),
            text: "金额",
            textFieldText: nil,
            placeholder: "请输入金额"
        )
        
        textField.textField.keyboardType = .decimalPad
        addSubview(textField)
        textField.label.font = UIFont.systemFont(ofSize: 17)
        textField.label.textColor = .black
        
        let line = UIView(frame: CGRect(x: 15, y: textField.frame.origin.y + textField.frame.height, width: frame.size.width - 15, height: 0.6))
        line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        addSubview(line)

        return textField
    }()
    
    public lazy var bzTF: FSLabelTextField = {
        let textField = FSLabelTextField(
            frame: CGRect(x: 0, y: 10 + 45, width: frame.size.width, height: 44),
            text: "备注",
            textFieldText: nil,
            placeholder: "输入备注"
        )
        textField.textField.keyboardType = .default
        addSubview(textField)
        textField.label.font = UIFont.systemFont(ofSize: 17)
        textField.label.textColor = .black
        
        let line = UIView(frame: CGRect(x: 15, y: textField.frame.origin.y + textField.frame.height, width: frame.size.width - 15, height: 0.6))
        line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        addSubview(line)

        return textField
    }()
    
    public var tapEvent: ((FSDBJeView) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        jeDesignViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        jeDesignViews()
    }
    
    private func jeDesignViews() {
        backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
        
        _ = jeTF
        _ = bzTF
    }
    
    @objc private func tapAction() {
        tapEvent?(self)
    }
}
