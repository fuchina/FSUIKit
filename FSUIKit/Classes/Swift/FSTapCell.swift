// FSTapCellS.swift
// Translated from FSTapCell.h/m

import UIKit

public typealias TapCellBlock = (FSTapCell) -> Void

public class FSTapCell: UIView {
    
    private var _backTapView: UIView!
    private var _textLabel: UILabel?
    private var _detailTextLabel: UILabel?
    
    public var click: TapCellBlock?
    
    public var textLabel: UILabel {
        if _textLabel == nil {
            let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: frame.width - 30, height: frame.height))
            lbl.textColor = .black
            addSubview(lbl)
            _textLabel = lbl
        }
        return _textLabel!
    }
    
    public var detailTextLabel: UILabel {
        if _detailTextLabel == nil {
            let lbl = UILabel(frame: CGRect(x: 90, y: 0, width: frame.width - 105, height: frame.height))
            lbl.textAlignment = .right
            lbl.textColor = .gray
            lbl.font = UIFont.systemFont(ofSize: 14)
            addSubview(lbl)
            _detailTextLabel = lbl
        }
        return _detailTextLabel!
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        _backTapView = UIView(frame: bounds)
        addSubview(_backTapView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        _backTapView.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction() {
        _backTapView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        _backTapView.alpha = 0.2
        UIView.animate(withDuration: 0.25, animations: {
            self._backTapView.alpha = 0.1
        }, completion: { _ in
            self._backTapView.alpha = 1
            self._backTapView.backgroundColor = .clear
        })
        
        click?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _backTapView.frame = bounds
        _textLabel?.frame = CGRect(x: 15, y: 0, width: frame.width - 30, height: frame.height)
        _detailTextLabel?.frame = CGRect(x: 90, y: 0, width: frame.width - 105, height: frame.height)
    }
}
