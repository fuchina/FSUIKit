// FSTapScrollViewS.swift
// Translated from FSTapScrollView.h/m

import UIKit
import FSKit

open class FSTapScrollView: UIScrollView {
    
    public var click: ((FSTapScrollView) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupTap()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTap()
    }
    
    private func setupTap() {
        let tap = FSClosureTapGestureRecognizer.init { [weak self] _ in
            guard let self else { return }
            self.tapActionInTapScrollView()
        }
        addGestureRecognizer(tap)
    }
    
    private func tapActionInTapScrollView() {
        click?(self)
    }
}
