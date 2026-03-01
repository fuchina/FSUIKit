// FSUICommonS.swift
// Translated from FSUICommon.h/m

import UIKit

public class FSUICommon: UIView {
    
    /// 添加四边阴影效果
    public static func addShadow(to view: UIView, with color: UIColor) {
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
    }
    
    /// 添加单边阴影效果
    public static func addShadowView(_ view: UIView, with color: UIColor) {
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        
        // 单边阴影 顶边
        let shadowPathWidth = view.layer.shadowRadius
        let shadowRect = CGRect(x: 0, y: 0 - shadowPathWidth / 2.0, width: view.bounds.width, height: shadowPathWidth)
        let path = UIBezierPath(rect: shadowRect)
        view.layer.shadowPath = path.cgPath
    }
}
