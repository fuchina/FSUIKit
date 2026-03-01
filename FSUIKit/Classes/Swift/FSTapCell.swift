// FSTapCellS.swift
// Translated from FSTapCell.h/m

import UIKit

public typealias TapCellBlock = (FSTapCell) -> Void

public class FSTapCell: UIView {
    
    private lazy var backTapView: UIView = {
        let v = UIView(frame: bounds)
        addSubview(v)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        v.addGestureRecognizer(tap)

        return v
    }()
    
    public lazy var textLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: frame.width - 30, height: frame.height))
        lbl.textColor = .black
        addSubview(lbl)
        return lbl
    }()
    
    public lazy var detailTextLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 90, y: 0, width: frame.width - 105, height: frame.height))
        lbl.textAlignment = .right
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 14)
        addSubview(lbl)
        return lbl
    }()
    
    public var click: TapCellBlock?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _ = backTapView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _ = backTapView
    }
        
    @objc private func tapAction() {
        backTapView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        backTapView.alpha = 0.2
        UIView.animate(withDuration: 0.25, animations: {
            self.backTapView.alpha = 0.1
        }, completion: { _ in
            self.backTapView.alpha = 1
            self.backTapView.backgroundColor = .clear
        })
        
        click?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backTapView.frame = bounds
        
        textLabel.frame = CGRect(x: 15, y: 0, width: frame.width - 30, height: frame.height)
        detailTextLabel.frame = CGRect(x: 90, y: 0, width: frame.width - 105, height: frame.height)
    }
}
