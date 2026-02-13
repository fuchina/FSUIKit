// FSLabelTextFieldS.swift
// Translated from FSLabelTextField.h/m

import UIKit

public class FSLabelTextField: UIView {
    
    public lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: frame.size.width / 2, height: frame.size.height))
        addSubview(label)
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    public lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: frame.size.width / 3, y: 0, width: frame.size.width * 2 / 3 - 15, height: frame.size.height))
        let rgb = 16 / 255.0
        textField.textColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1.0)
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textAlignment = .right
        addSubview(textField)
        
        return textField
    }()
    
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
        
        label.text = text
        
        textField.text = textFieldText
        textField.placeholder = placeholder
    }
    
    @objc private func tapClick() {
        tapEvent?(self)
    }
}
