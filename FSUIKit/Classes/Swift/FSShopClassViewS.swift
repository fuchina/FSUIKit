// FSShopClassViewS.swift
// Translated from FSShopClassView.h/m

import UIKit

@objcMembers
public class FSShopClassViewS: UIView {
    
    private var tableView: UITableView!
    private var frontCell: UITableViewCell?
    private var _normalColor: UIColor!
    
    public var selectIndex: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var dataSource: [String]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var selectedBlock: ((FSShopClassViewS, Int) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let rgb: CGFloat = 88 / 255.0
        _normalColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1)
        shopClassDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let rgb: CGFloat = 88 / 255.0
        _normalColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1)
        shopClassDesignViews()
    }
    
    private func shopClassDesignViews() {
        let rgb: CGFloat = 250 / 255.0
        tableView = UITableView(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1)
        addSubview(tableView)
    }
}

extension FSShopClassViewS: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "c"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
            cell?.selectionStyle = .none
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        if indexPath.row == selectIndex {
            cell?.backgroundColor = .clear
            cell?.textLabel?.textColor = .red
        } else {
            cell?.backgroundColor = .white
            cell?.textLabel?.textColor = _normalColor
        }
        
        if let ds = dataSource, ds.count > indexPath.row {
            cell?.textLabel?.text = ds[indexPath.row]
        }
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.5
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectIndex = indexPath.row
        
        if frontCell != cell {
            selectedBlock?(self, indexPath.row)
        }
    }
}
