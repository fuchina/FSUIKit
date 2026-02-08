// FSLabelTextFieldS.swift
// Translated from FSLabelTextField.h/m

import UIKit

public class FSLabelTextField: UIView {
    
    public var label: UILabel!
    public var textField: UITextField!
    public var tapEvent: ((FSLabelTextField) -> Void)?
    
    public convenience init(frame: CGRect, text: String?, textFieldText: String?, placeholder: String?) {
        self.init(frame: frame)
        labelTextFieldDesignViews(text: text, textFieldText: textFieldText, placeholder: placeholder ?? "请输入")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        labelTextFieldDesignViews(text: nil, textFieldText: nil, placeholder: "请输入")
    }
    
    private func labelTextFieldDesignViews(text: String?, textFieldText: String?, placeholder: String) {
        
        let widthSelf = bounds.width
        backgroundColor = .white
        
        label = UILabel(frame: CGRect(x: 15, y: 0, width: widthSelf / 2, height: frame.size.height))
        label.text = text
        addSubview(label)
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        label.addGestureRecognizer(tap)
        
        textField = UITextField(frame: CGRect(x: widthSelf / 3, y: 0, width: widthSelf * 2 / 3 - 15, height: frame.size.height))
        textField.placeholder = placeholder
        let rgb = 16 / 255.0
        textField.textColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1.0)
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.text = textFieldText
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textAlignment = .right
        addSubview(textField)
    }
    
    @objc private func tapClick() {
        tapEvent?(self)
    }
}
