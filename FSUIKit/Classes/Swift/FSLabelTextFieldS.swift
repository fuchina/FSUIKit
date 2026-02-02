// FSLabelTextFieldS.swift
// Translated from FSLabelTextField.h/m

import UIKit

@objcMembers
public class FSLabelTextFieldS: UIView {
    
    public var label: UILabel!
    public var textField: UITextField!
    public var tapEvent: ((FSLabelTextFieldS) -> Void)?
    
    public convenience init(frame: CGRect, text: String?, textFieldText: String?, placeholder: String?) {
        self.init(frame: frame)
        labelTextFieldDesignViews(text: text, textFieldText: textFieldText, placeholder: placeholder ?? "请输入")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        labelTextFieldDesignViews(text: nil, textFieldText: nil, placeholder: "请输入")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        labelTextFieldDesignViews(text: nil, textFieldText: nil, placeholder: "请输入")
    }
    
    private func labelTextFieldDesignViews(text: String?, textFieldText: String?, placeholder: String) {
        let widthSelf = bounds.width
        let heightSelf = bounds.height
        backgroundColor = .white
        
        label = UILabel(frame: CGRect(x: 15, y: 0, width: widthSelf / 2, height: heightSelf))
        label.text = text
        addSubview(label)
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        label.addGestureRecognizer(tap)
        
        textField = UITextField(frame: CGRect(x: widthSelf / 3, y: 0, width: widthSelf * 2 / 3 - 15, height: heightSelf))
        textField.placeholder = placeholder
        textField.textColor = UIColor(red: 16/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
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
