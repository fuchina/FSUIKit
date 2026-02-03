// FSTabViewS.swift
// Translated from FSTabView.h/m

import UIKit

@objcMembers
public class FSTabViewS: FSView {
    
    private var _label: UILabel?
    
    public var label: UILabel {
        if _label == nil {
            let lbl = UILabel(frame: bounds)
            lbl.textAlignment = .center
            addSubview(lbl)
            _label = lbl
        }
        return _label!
    }
    
    public var selected: Bool = false {
        didSet {
            selectedState?(self, selected)
        }
    }
    
    public var selectedState: ((FSTabViewS, Bool) -> Void)?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _label?.frame = bounds
    }
}
