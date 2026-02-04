// FSDBJeViewS.swift
// Translated from FSDBJeView.h/m

import UIKit

@objcMembers
public class FSDBJeView: UIView {
    
    public var jeTF: FSLabelTextField!
    public var bzTF: FSLabelTextField!
    public var tapEvent: ((FSDBJeView) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        jeDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        jeDesignViews()
    }
    
    private func jeDesignViews() {
        backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
        
        let size = frame.size
        for x in 0..<2 {
            let textField = FSLabelTextField(
                frame: CGRect(x: 0, y: 10 + 45 * CGFloat(x), width: size.width, height: 44),
                text: x == 1 ? "备注" : "金额",
                textFieldText: nil,
                placeholder: x == 1 ? "输入备注" : "请输入金额"
            )
            textField.textField.keyboardType = x == 1 ? .default : .decimalPad
            addSubview(textField)
            textField.label.font = UIFont.systemFont(ofSize: 17)
            textField.label.textColor = .black
            
            let line = UIView(frame: CGRect(x: 15, y: textField.frame.origin.y + textField.frame.height, width: size.width - 15, height: 0.6))
            line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            addSubview(line)
            
            if x == 1 {
                bzTF = textField
            } else {
                jeTF = textField
            }
        }
    }
    
    @objc private func tapAction() {
        tapEvent?(self)
    }
}
