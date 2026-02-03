//
//  UIViewAnimated.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/31.
//

import UIKit
import FSKit
import QuartzCore

// 对应 OC 分类 UIView+Animated，Swift 以扩展实现
extension UIView {
    // MARK: - 取消所有动画（对应 cancelAnimated）
    func cancelAnimated() {
        layer.removeAllAnimations()
    }
    
    // MARK: - 摇晃动画（重载方法，对应 shake 系列）
    func shake(count: Int) {
        shake(count: count, delegate: nil)
    }
    
    func shake(count: Int, delegate: CAAnimationDelegate?) {
        shake(count: count, duration: 0.15, delegate: delegate)
    }
    
    func shake(count: Int, duration: CGFloat, delegate: CAAnimationDelegate?) {
        cancelAnimated()
        shake(count: count, duration: duration, anchorPoint: CGPoint(x: 0.5, y: 0.5), delegate: delegate)
    }
    
    func shake(count: Int, duration: CGFloat, anchorPoint: CGPoint, delegate: CAAnimationDelegate?) {
        cancelAnimated()
        
        let radian = 10.0 / 180.0 * .pi
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
        anim.duration = CFTimeInterval(duration)
        anim.repeatCount = Float(count)
        anim.values = [0, -radian, 0, radian, 0]
        anim.isRemovedOnCompletion = true
        anim.fillMode = .forwards
        if let delegate = delegate {
            anim.delegate = delegate
        }
        layer.anchorPoint = anchorPoint
        layer.add(anim, forKey: "shake_animation_\(count)")
    }
    
    // MARK: - 放大动画（对应 zoomIn）
    func zoomIn(count: Int) {
        cancelAnimated()
        let anim = CAKeyframeAnimation(keyPath: "transform.scale")
        anim.duration = 0.25
        anim.repeatCount = Float(count)
        anim.values = [1, 1.2, 1, 0.8, 1, 1.2, 1]
        anim.isRemovedOnCompletion = true
        anim.fillMode = .forwards
        layer.add(anim, forKey: "zoom_in_animation_\(count)")
    }
    
    // MARK: - 上下漂浮动画（对应 floatingAnimaition，原OC拼写错误保留适配）
    func floatingAnimaition() {
        floatingAnimaition(duration: 2.0)
    }
    
    func floatingAnimaition(duration: CGFloat) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let height: CGFloat = 7.0
        let currentY = self.transform.ty
        animation.duration = CFTimeInterval(duration)
        animation.values = [
            currentY,
            currentY - height/4,
            currentY - height/4*2,
            currentY - height/4*3,
            currentY - height,
            currentY - height/4*3,
            currentY - height/4*2,
            currentY - height/4,
            currentY
        ]
        animation.keyTimes = [0, 0.025, 0.085, 0.2, 0.5, 0.8, 0.915, 0.975, 1] as [NSNumber]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = .greatestFiniteMagnitude
        layer.add(animation, forKey: "kViewShakerAnimationKey")
    }
    
    // MARK: - 水平漂浮动画（对应 floatingHorizontalAnimaition）
    func floatingHorizontalAnimaition(duration: CGFloat) {
        cancelAnimated()
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let height: CGFloat = 7.0
        let currentX = self.transform.tx
        animation.duration = CFTimeInterval(duration)
        animation.values = [
            currentX,
            currentX - height/4,
            currentX - height/4*2,
            currentX - height/4*3,
            currentX - height,
            currentX - height/4*3,
            currentX - height/4*2,
            currentX - height/4,
            currentX
        ]
        animation.keyTimes = [0, 0.025, 0.085, 0.2, 0.5, 0.8, 0.915, 0.975, 1] as [NSNumber]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = .greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "kViewShakerAnimationKey.x")
    }
    
    // MARK: - 缩小动画（对应 zoomOut）
    func zoomOut(count: Int) {
        cancelAnimated()
        let anim = CAKeyframeAnimation(keyPath: "transform.scale")
        anim.duration = 0.25
        anim.repeatCount = Float(count)
        anim.values = [1, 0.8, 1, 1.2, 1, 0.8, 1]
        anim.isRemovedOnCompletion = true
        anim.fillMode = .forwards
        layer.add(anim, forKey: "zoom_out_animation_\(count)")
    }
    
    // MARK: - 呼吸发光动画（重载方法，对应 breatheAnimation 系列）
    func breatheAnimation() {
        breatheAnimation(duration: 3)
    }
    
    func breatheAnimation(duration: CGFloat) {
        breatheAnimation(duration: duration, opacity: true)
    }
    
    func breatheAnimation(duration: CGFloat, opacity: Bool) {
        cancelAnimated()
        
        var animations = [CAAnimation]()
        // 缩放动画
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.duration = CFTimeInterval(duration)
        scaleAnim.values = [1.0, 0.95, 1.0, 1.05, 1.0]
        animations.append(scaleAnim)
        
        // 透明度动画
        if opacity {
            let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnim.duration = CFTimeInterval(duration)
            opacityAnim.values = [1, 0.85, 1, 0.85, 1.0]
            animations.append(opacityAnim)
        }
        
        let group = CAAnimationGroup()
        group.animations = animations
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.duration = CFTimeInterval(duration)
        group.repeatCount = .greatestFiniteMagnitude
        layer.add(group, forKey: "breathe_animation")
    }
    
    // MARK: - 星星呼吸动画（对应 stars_breatheAnimation）
    func stars_breatheAnimation() {
        cancelAnimated()
        
        let duration: CFTimeInterval = 2
        var animations = [CAAnimation]()
        // 缩放动画
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.duration = duration
        scaleAnim.values = [1.0, 0.9, 0.8, 0.9, 1.0]
        animations.append(scaleAnim)
        
        // 透明度动画
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.duration = duration
        opacityAnim.values = [1, 0.618, 0.382, 0.618, 1.0]
        animations.append(opacityAnim)
        
        let group = CAAnimationGroup()
        group.animations = animations
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.duration = duration
        group.repeatCount = .greatestFiniteMagnitude
        layer.add(group, forKey: "stars_breatheAnimation")
    }
    
    // MARK: - 透明度呼吸动画（对应 opacityAnimation）
    func opacityAnimation(duration: CGFloat) {
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.duration = CFTimeInterval(duration)
        opacityAnim.values = [1, 0.618, 0.382, 0.618, 1.0]
        
        let group = CAAnimationGroup()
        group.animations = [opacityAnim]
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.duration = CFTimeInterval(duration)
        group.repeatCount = .greatestFiniteMagnitude
        layer.add(group, forKey: "opacity_animation")
    }
    
    // MARK: - 轴旋转动画（对应 rotateByShaft）
    func rotateByShaft(isY: Bool, duration: CFTimeInterval, delegate: CAAnimationDelegate?, repeat repeatCount: Float) {
        cancelAnimated()
        
        let keyPath = isY ? "transform.rotation.y" : "transform.rotation.z"
        let rotationAnim = CABasicAnimation(keyPath: keyPath)
        rotationAnim.toValue = NSNumber(value: Float.pi * 2)
        rotationAnim.duration = duration
        rotationAnim.isCumulative = true
        rotationAnim.repeatCount = repeatCount
        rotationAnim.delegate = delegate
        rotationAnim.isRemovedOnCompletion = false
        rotationAnim.fillMode = .forwards
        layer.add(rotationAnim, forKey: "rotationAnimation")
    }
    
    // MARK: - 控制器交叉溶解转场（类方法，对应 crossDissolveToViewController 系列）
    static func crossDissolve(to viewController: UIViewController,
                              animations: (() -> Void)? = nil,
                              completion: ((Bool) -> Void)? = nil) {
        crossDissolve(to: viewController, duration: 0.4, animations: animations, completion: completion)
    }
    
    static func crossDissolve(to viewController: UIViewController,
                              duration: TimeInterval,
                              animations: (() -> Void)? = nil,
                              completion: ((Bool) -> Void)? = nil) {
        viewController.modalTransitionStyle = .crossDissolve
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        
        let animationsBlock = {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            animations?()
            UIView.setAnimationsEnabled(oldState)
        }
        
        guard let window = FSKit.currentWindowScene()?.windows.first else {
            completion?(false)
            return
        }
        UIView.transition(with: window, duration: duration, options: options, animations: animationsBlock, completion: completion)
    }
    
    // MARK: - 视图交叉溶解动画（类方法，对应 crossDissolveWithView 系列）
    static func crossDissolve(with view: UIView,
                              animations: (() -> Void)? = nil,
                              completion: ((Bool) -> Void)? = nil) {
        crossDissolve(with: view, duration: 0.25, animations: animations, completion: completion)
    }
    
    static func crossDissolve(with view: UIView,
                              duration: TimeInterval,
                              animations: (() -> Void)? = nil,
                              completion: ((Bool) -> Void)? = nil) {
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        
        let animationsBlock = {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            animations?()
            UIView.setAnimationsEnabled(oldState)
        }
        
        UIView.transition(with: view, duration: duration, options: options, animations: animationsBlock, completion: completion)
    }
}
