// FSSwitchCellS.swift
// Translated from FSSwitchCell.h/m

import UIKit
import FSKit

public class FSSwitchCell: UITableViewCell {
    
    private var _switch: UISwitch!
    
    public var on: Int {
        get { _switch.isOn ? 1 : 0 }
        set { _switch.isOn = newValue != 0 }
    }
    
    public var block: ((UISwitch) -> Void)?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        switchDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        switchDesignViews()
    }
    
    private func switchDesignViews() {
        isUserInteractionEnabled = true
        selectionStyle = .none
        _switch = UISwitch(frame: CGRect(x: WIDTHFC - 71, y: 12, width: 51, height: 31))
        _switch.addAction(UIAction { [weak self] action in
            guard let self else { return }
            self.switchAction(action.sender as! UISwitch)
        }, for: .valueChanged)
        contentView.addSubview(_switch)
    }
    
    private func switchAction(_ s: UISwitch) {
        block?(s)
    }
}
