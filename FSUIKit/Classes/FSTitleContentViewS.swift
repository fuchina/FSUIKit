//
//  FSTitleContentViewS.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/29.
//

import Foundation

open class FSTitleContentView: FSView {
    
    public lazy var label: UILabel = {
        let l = UILabel(frame: bounds)
        self.addSubview(l)
        return l
    }()
    
    public lazy var contentLabel: UILabel = {
        let l = UILabel(frame: bounds)
        l.textAlignment = .right
        self.addSubview(l)
        return l
    }()
    
}
