// FSTapLabelS.swift
// Translated from FSTapLabel.h/m

import UIKit
import FSKit

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
        let tap = FSTapGestureRecognizer.init { [weak self] _ in
            guard let self else { return }
            self.tapAction()
        }
        addGestureRecognizer(tap)
    }
    
    private func tapAction() {
        block?(self)
    }
}
