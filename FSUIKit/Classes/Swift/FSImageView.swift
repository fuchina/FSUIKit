// FSImageViewS.swift
// Translated from FSImageView.h/m

import UIKit
import FSKit

public class FSImageView: UIImageView {
    
    private var _backTapView: UIView!
    
    public var click: ((FSImageView) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        fsAddTapEventInBaseView()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        fsAddTapEventInBaseView()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        fsAddTapEventInBaseView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fsAddTapEventInBaseView()
    }
    
    private func fsAddTapEventInBaseView() {
        isUserInteractionEnabled = true
        _backTapView = UIView(frame: bounds)
        addSubview(_backTapView)
        
        let tap = FSClosureTapGestureRecognizer.init { [weak self] tap in
            guard let self else { return }
            self.fsTapClickEvent(tap)
        }
        _backTapView.addGestureRecognizer(tap)
    }
    
    private func fsTapClickEvent(_ tap: UITapGestureRecognizer) {
        click?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _backTapView.frame = bounds
    }
}
