// FSPlaceholderViewS.swift
// Translated from FSPlaceholderView.h/m

import UIKit
import FSKit

public class FSPlaceholderView: UIView {
    
    private var _label: UILabel?
    
    public var label: UILabel {
        if _label == nil {
            let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: bounds.width - 15, height: bounds.height))
            lbl.textColor = .lightGray
            lbl.font = UIFont.systemFont(ofSize: 15)
            lbl.numberOfLines = 0
            addSubview(lbl)
            _label = lbl
        }
        return _label!
    }
    
    public var click: ((FSPlaceholderView) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        placeholderDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        placeholderDesignViews()
    }
    
    private func placeholderDesignViews() {
        let tap = FSClosureTapGestureRecognizer.init { [weak self] _ in
            guard let self else { return }
            self.clickEvent()
        }
        addGestureRecognizer(tap)
    }
    
    private func clickEvent() {
        click?(self)
    }
}
