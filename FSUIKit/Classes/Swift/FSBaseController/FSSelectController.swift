//
//  FSSelectController.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

open class FSSelectModel: NSObject {
    
    public var selected: Bool = false
    public var content_id: String = ""
    public var content_show: String = ""
    
    public static func fastModels(withTexts texts: [String]?) -> [FSSelectModel]? {
        guard let texts = texts else { return nil }
        
        var list: [FSSelectModel] = []
        for txt in texts {
            let m = FSSelectModel()
            m.content_id = txt
            m.content_show = txt
            list.append(m)
        }
        return list
    }
    
    public static func selectedModels(from models: [FSSelectModel]?) -> [FSSelectModel] {
        guard let models = models else { return [] }
        return models.filter { $0.selected }
    }
}

public typealias FSSelectControllerBlock = (FSSelectController, IndexPath, [FSSelectModel]) -> Void

open class FSSelectController: FSBaseController, UITableViewDelegate, UITableViewDataSource {
    
    @objc public var models: [FSSelectModel] = []
    @objc public var configCell: ((UITableViewCell, IndexPath, [FSSelectModel]) -> Void)?
    @objc public var block: FSSelectControllerBlock?
    @objc public var multiSelectCallback: ((FSSelectController, [FSSelectModel]) -> Void)?
    
    private var tableView: UITableView!
    
    @objc func confirmSelected() {
        multiSelectCallback?(self, FSSelectModel.selectedModels(from: models))
    }
    
    open override func componentWillMount() {
        super.componentWillMount()
        
        let bbi = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(confirmSelected))
        navigationItem.rightBarButtonItem = bbi
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "i"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
            cell?.accessoryType = .disclosureIndicator
        }
        
        configCell?(cell!, indexPath, models)
        
        let m = models[indexPath.row]
        cell?.textLabel?.text = m.content_show
        cell?.accessoryType = m.selected ? .checkmark : .none
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let m = models[indexPath.row]
        m.selected = !m.selected
        tableView.reloadRows(at: [indexPath], with: .none)
        
        block?(self, indexPath, FSSelectModel.selectedModels(from: models))
    }
}
