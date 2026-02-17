// FSTapLabelS.swift
// Translated from FSTapLabel.h/m

import UIKit

public typealias FSTapLabelBlock = (FSTapLabel) -> Void

public class FSTapLabel: UILabel {
    
    public var block: FSTapLabelBlock?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupTap()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTap()
    }
    
    private func setupTap() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapAction() {
        block?(self)
    }
}
