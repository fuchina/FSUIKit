//
//  FSShakeBaseController.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

@objc open class FSShakeBaseController: FSBaseController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.applicationSupportsShakeToEdit = true
        if canBecomeFirstResponder {
            becomeFirstResponder()
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if canResignFirstResponder {
            resignFirstResponder()
        }
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    }
    
    open override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            shakeEndActionFromShakeBase()
        }
    }
    
    @objc open func shakeEndActionFromShakeBase() {
        // 子类重写此方法处理摇一摇结束事件
    }
}
