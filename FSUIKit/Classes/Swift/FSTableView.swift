// FSTableViewS.swift
// Translated from FSTableView.h/m

import UIKit

@objcMembers
public class FSTableView: UITableView {
    
    /// 用来获得tableView reloadData后的时机
    public var layoutedSubviews: ((FSTableView) -> Void)?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutedSubviews?(self)
    }
}
