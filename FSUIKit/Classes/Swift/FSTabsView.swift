// FSTabsViewS.swift
// Translated from FSTabsView.h/m

import UIKit

@objcMembers
public class FSTabsView: FSView {
    
    public var list: [String]? {
        didSet {
            setupTabs()
        }
    }
    
    public var clickIndex: ((FSTabsView, Int) -> Void)?
    public var selectedState: ((FSTabView, Bool) -> Void)?
    
    private func setupTabs() {
        // Hide existing tabs
        for sub in subviews {
            if let tab = sub as? FSTabView {
                tab.isHidden = true
            }
        }
        
        guard let list = list, !list.isEmpty else { return }
        
        let w = frame.width / CGFloat(list.count)
        for (index, text) in list.enumerated() {
            let fr = CGRect(x: w * CGFloat(index), y: 0, width: w, height: frame.height)
            
            var tab: FSTabView
            if let existingTab = FSView.viewWithTheTag(tag: index, view: self) as? FSTabView {
                existingTab.isHidden = false
                existingTab.frame = fr
                tab = existingTab
            } else {
                tab = FSTabView(frame: fr)
                tab.theTag = index
                addSubview(tab)
                
                tab.click = { [weak self] view, p in
                    guard let self = self else { return }
                    if let tabView = view as? FSTabView {
                        self.clickIndex?(self, tabView.theTag)
                    }
                }
                tab.selectedState = { [weak self] tabV, selected in
                    self?.selectedState?(tabV, selected)
                }
            }
            tab.label.text = text
        }
    }
    
    public func selectedIndex(_ index: Int) {
        for sub in subviews {
            if let tab = sub as? FSTabView {
                tab.selected = (tab.theTag == index)
            }
        }
    }
}
