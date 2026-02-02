// UIView+ModalAnimationS.swift
// Translated from UIView+ModalAnimation.h/m

import UIKit

public extension UIView {
    
    func pushAnimatedS(_ flag: Bool, completion: ((UIView) -> Void)?) {
        pushAnimatedS(flag, toFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), completion: completion)
    }
    
    func pushAnimatedS(_ flag: Bool, toFrame frame: CGRect, completion: ((UIView) -> Void)?) {
        if flag {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                self.frame = frame
            }, completion: { _ in
                completion?(self)
            })
        } else {
            self.frame = frame
            completion?(self)
        }
    }
    
    func popAnimatedS(_ flag: Bool, removeFromSuperView remove: Bool, completion: ((UIView) -> Void)?) {
        popAnimatedS(flag, toFrame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), removeFromSuperView: remove, completion: completion)
    }
    
    func popAnimatedS(_ flag: Bool, toFrame frame: CGRect, removeFromSuperView remove: Bool, completion: ((UIView) -> Void)?) {
        if flag {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                self.frame = frame
            }, completion: { _ in
                self.popCallbackS(remove: remove, completion: completion)
            })
        } else {
            self.frame = frame
            popCallbackS(remove: remove, completion: completion)
        }
    }
    
    private func popCallbackS(remove: Bool, completion: ((UIView) -> Void)?) {
        completion?(self)
        
        if remove {
            frame = CGRect(x: 10000, y: 0, width: 0, height: 0)
            isHidden = true
            removeFromSuperview()
        }
    }
}
