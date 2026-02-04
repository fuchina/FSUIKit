// FSTapScrollViewS.swift
// Translated from FSTapScrollView.h/m

import UIKit

@objcMembers
public class FSTapScrollView: UIScrollView {
    
    public var click: ((FSTapScrollView) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupTap()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTap()
    }
    
    private func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapActionInTapScrollView))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapActionInTapScrollView() {
        click?(self)
    }
}
