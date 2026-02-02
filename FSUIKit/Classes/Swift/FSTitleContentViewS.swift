// FSTitleContentViewS.swift
// Translated from FSTitleContentView.h/m

import UIKit

@objcMembers
public class FSTitleContentViewSS: FSViewS {
    
    private var _label: UILabel?
    private var _contentLabel: UILabel?
    
    public var label: UILabel {
        if _label == nil {
            let lbl = UILabel(frame: bounds)
            addSubview(lbl)
            _label = lbl
        }
        return _label!
    }
    
    public var contentLabel: UILabel {
        if _contentLabel == nil {
            let lbl = UILabel(frame: bounds)
            lbl.textAlignment = .right
            addSubview(lbl)
            _contentLabel = lbl
        }
        return _contentLabel!
    }
}
