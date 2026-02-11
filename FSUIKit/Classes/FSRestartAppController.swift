//
//  FSRestartAppController.swift
//  FSPassword
//
//  Translated from Objective-C
//

import UIKit

import FSKit

open class FSRestartAppController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        rsDesignViews()
    }
    
    private func rsDesignViews() {
        let label = FSTapLabel(frame: CGRect(x: 0, y: HEIGHTFC / 2 - 30, width: WIDTHFC, height: 80))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "导入成功，请重启APP"
        label.numberOfLines = 0
        view.addSubview(label)
        
        #if targetEnvironment(simulator)
        label.text = "导入成功，请重启APP（模拟器上点击重启）"
        label.block = { _ in
            // Force crash for simulator restart
            let list: [Any] = []
            _ = list[1]
        }
        #endif
    }
}
