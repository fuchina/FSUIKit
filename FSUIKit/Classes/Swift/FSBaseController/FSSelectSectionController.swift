//
//  FSSelectSectionController.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

public typealias FSSelectSectionBlock = (FSSelectSectionController, [[String]], Int, Int) -> Void

@objc open class FSSelectSectionController: FSBaseController, UITableViewDataSource, UITableViewDelegate {
    
    @objc public var array: [[String]] = []
    @objc public var block: FSSelectSectionBlock?
    
    open override func componentWillMount() {
        super.componentWillMount()
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "i"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = array[indexPath.section][indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        block?(self, array, indexPath.section, indexPath.row)
    }
}
