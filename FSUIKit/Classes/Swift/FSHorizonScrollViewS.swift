// FSHorizonScrollViewS.swift
// Translated from FSHorizonScrollView.h/m

import UIKit

@objcMembers
public class FSHorizonScrollViewS: UIScrollView, UIGestureRecognizerDelegate {
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if panBack(gestureRecognizer) {
            return false
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if panBack(gestureRecognizer) {
            return true
        }
        return false
    }
    
    private func panBack(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
            let state = gestureRecognizer.state
            if state == .began || state == .possible {
                let point = pan.translation(in: self)
                let location = gestureRecognizer.location(in: self)
                if point.x > 0 && location.x < 90 && contentOffset.x <= 0 {
                    return true
                }
            }
        }
        return false
    }
}
