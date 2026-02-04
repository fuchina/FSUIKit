// FSHalfViewS.swift
// Translated from FSHalfView.h/m

import UIKit

@objcMembers
public class FSHalfView: UIView {
    
    private var tableView: UITableView!
    private var _leftWidth: CGFloat = 0
    private var _tapView: UIView!
    
    public var numberOfRowsInSection: ((UITableView) -> Int)?
    public var configCell: ((UITableView, IndexPath, UITableViewCell) -> Void)?
    public var selectCell: ((UITableView, IndexPath) -> Void)?
    
    deinit {
        #if targetEnvironment(simulator)
        print("\(type(of: self)) dealloc")
        #endif
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _tapView.frame = bounds
    }
    
    public static func showHalfView(in view: UIView, frame: CGRect, leftWidth: CGFloat) -> FSHalfView {
        let halfView = FSHalfView(frame: frame)
        DispatchQueue.main.async {
            halfView.showHalfView(true, leftWidth: leftWidth)
        }
        view.addSubview(halfView)
        return halfView
    }
    
    public func showHalfView(_ show: Bool, leftWidth: CGFloat) {
        if show {
            _leftWidth = leftWidth
            UIView.animate(withDuration: 0.3) {
                self._tapView.alpha = 0.28
                self.tableView.frame = CGRect(x: leftWidth, y: 0, width: self.bounds.width - leftWidth, height: self.bounds.height)
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame = CGRect(x: self.bounds.width, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
                self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
    
    @objc private func tapAction() {
        showHalfView(false, leftWidth: 0)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        halfDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        halfDesignViews()
    }
    
    private func halfDesignViews() {
        _tapView = UIView(frame: bounds)
        _tapView.backgroundColor = .black
        _tapView.alpha = 0
        addSubview(_tapView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        _tapView.addGestureRecognizer(tapGesture)
        
        let size = UIScreen.main.bounds.size
        tableView = UITableView(frame: CGRect(x: bounds.width, y: 0, width: size.width - _leftWidth, height: frame.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        addSubview(tableView)
    }
}

extension FSHalfView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection?(tableView) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "c"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            cell?.accessoryType = .disclosureIndicator
        }
        
        configCell?(tableView, indexPath, cell!)
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectCell?(tableView, indexPath)
        showHalfView(false, leftWidth: 0)
    }
}
