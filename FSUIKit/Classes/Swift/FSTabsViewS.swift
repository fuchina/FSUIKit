// FSTabsViewS.swift
// Translated from FSTabsView.h/m

import UIKit

@objcMembers
public class FSTabsViewS: FSView {
    
    public var list: [String]? {
        didSet {
            setupTabs()
        }
    }
    
    public var clickIndex: ((FSTabsViewS, Int) -> Void)?
    public var selectedState: ((FSTabViewS, Bool) -> Void)?
    
    private func setupTabs() {
        // Hide existing tabs
        for sub in subviews {
            if let tab = sub as? FSTabViewS {
                tab.isHidden = trueb
            }
        }
        
        guard let list = list, !list.isEmpty else { return }
        
        let w = frame.width / CGFloat(list.count)
        for (index, text) in list.enumerated() {
            let fr = CGRect(x: w * CGFloat(index), y: 0, width: w, height: frame.height)
            
            var tab: FSTabViewS
            if let existingTab = FSView.viewWithTheTag(tag: index, view: self) as? FSTabViewS {
                existingTab.isHidden = false
                existingTab.frame = fr
                tab = existingTab
            } else {
                tab = FSTabViewS(frame: fr)
                tab.theTag = index
                addSubview(tab)
                
                tab.click = { [weak self] view, p in
                    guard let self = self else { return }
                    if let tabView = view as? FSTabViewS {
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
            if let tab = sub as? FSTabViewS {
                tab.selected = (tab.theTag == index)
            }
        }
    }
}
