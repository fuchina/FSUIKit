//
//  FSToastS.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/31.
//

import Foundation
import FSKit

open class FSToast: NSObject {

    //  2026-10-15 全 SwiftUI 化：
    //  `toast(_:)` / `toast(_:duration:)` 原来要构造 UIView 加到 window 上，必须有 UIView 宿主；
    //  现改为把文案塞进 `FSToastCenter`（SwiftUI 全局浮层），由根视图渲染。
    //  ⇒ 全项目 348 处调用点无需改动，也不再依赖 UIView / UIViewController。
    //  返回值保留（调用处多为 `_ =`，改 Void 亦可兼容），但已无实际用途。

    public static func toast(_ text: String) {
        self.toast(text, duration: 2)
    }

    public static func toast(_ text: String, duration: Float) {
        FSToastCenter.shared.show(text, duration: Double(duration))
    }

    /// ⚠️ 旧通道：显式挂到某个 UIView 上（UIKit 集成场景，如模态 UIKit 页）。
    /// 全项目仅 87 处调用，均为 `_ =` 丢弃返回值。待这些场景一并 SwiftUI 化后可删。
    @discardableResult
    public static func toast(_ text: String, duration: Float, to: UIView) -> UIView {
        
        var height = 40.0
        let font = UIFont.systemFont(ofSize: 14)
        var width = FSCalculator.textWidth(text, font: font, labelHeight: height)
        
        let maxWidth = WIDTHFC - 30 - 20
        if width > maxWidth {
            width = maxWidth
            
            height = FSCalculator.textHeight(text, font: font, labelWidth: width) + 20
        }
                
        let label = UILabel(frame: CGRectMake(10, 0, width, height))
        label.textAlignment = .center
        label.font = font
        label.text = text
        label.numberOfLines = 0
        label.textColor = UIColor.white
        
        let vWidth = width + 20
        let x = WIDTHFC / 2 - vWidth / 2
        
        let y = to.bounds.size.height / 2 - height / 2
        let back = UIView(frame: CGRect(x: x, y: y, width: vWidth, height: height))
        back.backgroundColor = UIColor.init(red: 73.0 / 255, green: 80 / 255.0, blue: 86.0 / 255, alpha: 0.9)
        back.layer.cornerRadius = 3.0
        back.addSubview(label)
        
        to.addSubview(back)

        back.alpha = 0;
        
        UIView.animate(withDuration: 0.1) {
            back.alpha = 1.0
        } completion: { Bool in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(duration * 1000)), execute: {
                UIView.animate(withDuration: 0.25) {
                    back.alpha = 0
                } completion: { Bool in
                    back.removeFromSuperview()
                }
            })
        }

        return back
    }
}
