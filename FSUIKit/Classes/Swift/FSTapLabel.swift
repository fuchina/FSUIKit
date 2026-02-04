// FSTapLabelS.swift
// Translated from FSTapLabel.h/m

import UIKit

public typealias FSTapLabelBlockS = (FSTapLabelS) -> Void

@objcMembers
public class FSTapLabel: UILabel {
    
    public var block: FSTapLabelBlockS?
    
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
