// FSToastS.swift
// Translated from FSToast.h/m

import UIKit

@objcMembers
public class FSToastS: NSObject {
    
    @discardableResult
    public static func toast(_ text: String) -> UIView? {
        return toast(text, duration: 2)
    }
    
    @discardableResult
    public static func toast(_ text: String, duration: CGFloat) -> UIView? {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return nil }
        return toast(text, duration: duration, to: window)
    }
    
    @discardableResult
    public static func toast(_ text: String, duration: CGFloat, to superView: UIView) -> UIView? {
        guard !text.isEmpty else { return nil }
        
        let padding: CGFloat = 20
        let maxWidth = superView.bounds.width - 60
        let font = UIFont.systemFont(ofSize: 14)
        
        let textSize = (text as NSString).boundingRect(
            with: CGSize(width: maxWidth - padding * 2, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        ).size
        
        let toastWidth = min(textSize.width + padding * 2, maxWidth)
        let toastHeight = textSize.height + padding
        
        let toastView = UIView(frame: CGRect(
            x: (superView.bounds.width - toastWidth) / 2,
            y: (superView.bounds.height - toastHeight) / 2,
            width: toastWidth,
            height: toastHeight
        ))
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        toastView.layer.cornerRadius = 8
        toastView.clipsToBounds = true
        
        let label = UILabel(frame: toastView.bounds.insetBy(dx: padding / 2, dy: padding / 2))
        label.text = text
        label.textColor = .white
        label.font = font
        label.textAlignment = .center
        label.numberOfLines = 0
        toastView.addSubview(label)
        
        superView.addSubview(toastView)
        
        toastView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            toastView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(duration)) {
            UIView.animate(withDuration: 0.3, animations: {
                toastView.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        }
        
        return toastView
    }
}
