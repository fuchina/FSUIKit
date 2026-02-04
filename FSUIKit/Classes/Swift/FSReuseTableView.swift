// FSReuseTableViewS.swift
// Translated from FSReuseTableView.h/m
// Note: MJRefresh dependency removed - use native UIRefreshControl instead

import UIKit

@objcMembers
public class FSReuseTableView: UIView {
    
    public var tableView: UITableView!
    
    public var refreshHeader: (() -> Void)? {
        didSet {
            if refreshHeader != nil {
                let refreshControl = UIRefreshControl()
                refreshControl.addTarget(self, action: #selector(handleRefreshHeader), for: .valueChanged)
                tableView.refreshControl = refreshControl
            }
        }
    }
    
    public var refreshFooter: (() -> Void)?
    
    public var numberOfSections: ((UITableView) -> Int)?
    public var numberOfRowsInSection: ((UITableView, Int) -> Int)?
    public var cellForRowAtIndexPath: ((UITableView, IndexPath) -> UITableViewCell?)?
    public var willDisplayCell: ((UITableViewCell, IndexPath) -> Void)?
    public var heightForRowAtIndexPath: ((UITableView, IndexPath) -> CGFloat)?
    public var heightForHeaderInSection: ((UITableView, Int) -> CGFloat)?
    public var heightForFooterInSection: ((UITableView, Int) -> CGFloat)?
    public var didSelectRowAtIndexPath: ((UITableView, IndexPath) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        bestCellDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bestCellDesignViews()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    private func bestCellDesignViews() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        addSubview(tableView)
    }
    
    @objc private func handleRefreshHeader() {
        refreshHeader?()
    }
    
    public func endRefresh() {
        tableView.refreshControl?.endRefreshing()
    }
    
    public func deleteRefresh() {
        tableView.refreshControl = nil
    }
}

extension FSReuseTableViewS: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections?(tableView) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection?(tableView, section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAtIndexPath?(tableView, indexPath) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell?(cell, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAtIndexPath?(tableView, indexPath) ?? 44
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection?(tableView, section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection?(tableView, section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndexPath?(tableView, indexPath)
    }
}
