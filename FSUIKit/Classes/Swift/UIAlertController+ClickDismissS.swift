// UIAlertController+ClickDismissS.swift
// Translated from UIAlertController+ClickDismiss.h/m

import UIKit
import ObjectiveC
import FSKit

// 用于关联对象的key
//
// Swift 6 语言模式：它是全局 `var`，被判为并发不安全的共享可变状态。
// 这里仅取其**地址**当 key（`&tapGestureKey`），从不读写值，故 uncheck 是安全的。
nonisolated(unsafe) private var tapGestureKey: UInt8 = 0

public extension UIAlertController {
    
    @discardableResult
    func addTapEvent(_ clickDismiss: ((UIAlertController, CGPoint) -> Void)?) -> Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
              let backView = keyWindow.subviews.last,
              NSStringFromClass(type(of: backView)) == "UITransitionView" else {
            return false
        }
        
        backView.isUserInteractionEnabled = true
        
        let tap = FSTapGestureRecognizer.init { [weak self] tap in
            guard let self else { return }
            guard let view = tap.view else { return }
            let point = tap.location(in: view)
            clickDismiss?(self, point)
        }
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        backView.addGestureRecognizer(tap)
        
        let doubleTap = FSTapGestureRecognizer.init { [weak self] tap in
            guard let self else { return }
            self.handleDoubleTapS(tap)
        }
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        backView.addGestureRecognizer(doubleTap)
        
        tap.require(toFail: doubleTap)
        
        // 保存引用防止被释放
        objc_setAssociatedObject(self, &tapGestureKey, tap, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return true
    }
    
    private func handleDoubleTapS(_ doubleTap: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleAlertClick() {
        let hasData = textFields?.contains { ($0.text?.count ?? 0) > 0 } ?? false
        if !hasData {
            dismiss(animated: true, completion: nil)
        }
    }
}
