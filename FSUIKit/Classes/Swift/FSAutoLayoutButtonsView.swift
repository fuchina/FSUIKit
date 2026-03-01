// FSAutoLayoutButtonsViewS.swift
// Translated from FSAutoLayoutButtonsView.h/m

import UIKit

public class FSAutoLayoutButtonsView: UIView {
    
    private let keyValueButtonTag = 1000
    private var _height: CGFloat = 0
    
    public var texts: [String]? {
        didSet {
            setupButtons()
        }
    }
    
    public var click: ((FSAutoLayoutButtonsView, Int) -> Void)?
    public var configButton: ((UIButton) -> Void)?
    
    public var selfHeight: CGFloat {
        return _height
    }
    
    private func setupButtons() {
        // Remove existing buttons
        for sub in subviews {
            if let button = sub as? UIButton, button.tag > keyValueButtonTag {
                button.isHidden = true
                button.removeFromSuperview()
            }
        }
        
        guard let texts = texts, !texts.isEmpty else { return }
        
        let font = UIFont.systemFont(ofSize: 13, weight: .medium)
        let sw = UIScreen.main.bounds.width
        let lrMargin: CGFloat = 15
        let rightMargin = sw - lrMargin
        var offsetX: CGFloat = lrMargin
        var offsetY: CGFloat = 20
        let bh: CGFloat = 44
        let xSpace: CGFloat = 30
        
        for (index, item) in texts.enumerated() {
            let w = textWidth(item, font: font, labelHeight: 30) + 40
            if (offsetX + w) > rightMargin {
                offsetY += 70
                offsetX = lrMargin
            }
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x: offsetX, y: offsetY, width: w, height: bh)
            button.tag = index + keyValueButtonTag + 1
            button.backgroundColor = .white
            button.setTitle(item, for: .normal)
            button.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            addSubview(button)
            
            offsetX += (w + xSpace)
            
            configButton?(button)
        }
        _height = offsetY + bh
    }
    
    @objc private func btnClick(_ button: UIButton) {
        let index = button.tag - keyValueButtonTag - 1
        click?(self, index)
    }
    
    private func textWidth(_ text: String, font: UIFont, labelHeight: CGFloat) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: labelHeight)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let rect = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return ceil(rect.width)
    }
}
