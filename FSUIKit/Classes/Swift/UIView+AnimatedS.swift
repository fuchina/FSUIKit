// UIView+AnimatedS.swift
// Translated from UIView+Animated.h/m

import UIKit

public extension UIView {
    
    /// 取消动画
    func cancelAnimatedS() {
        layer.removeAllAnimations()
    }
    
    /// 摇晃，count：次数
    func shakeS(_ count: Int) {
        shakeS(count, delegate: nil)
    }
    
    func shakeS(_ count: Int, delegate: CAAnimationDelegate?) {
        shakeS(count, duration: 0.15, delegate: delegate)
    }
    
    func shakeS(_ count: Int, duration: CGFloat, delegate: CAAnimationDelegate?) {
        cancelAnimatedS()
        shakeS(count, duration: duration, anchorPoint: CGPoint(x: 0.5, y: 0.5), delegate: delegate)
    }
    
    func shakeS(_ count: Int, duration: CGFloat, anchorPoint point: CGPoint, delegate: CAAnimationDelegate?) {
        cancelAnimatedS()
        
        let radian = 10 / 180.0 * CGFloat.pi
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
        anim.duration = CFTimeInterval(duration)
        anim.repeatCount = Float(count)
        anim.values = [0, -radian, 0, radian, 0]
        anim.isRemovedOnCompletion = true
        anim.fillMode = .forwards
        anim.delegate = delegate
        layer.anchorPoint = point
        layer.add(anim, forKey: "shake_animation_\(count)")
    }
    
    /// 星星动画
    func starsBreathAnimationS() {
        cancelAnimatedS()
        
        let duration: CFTimeInterval = 2
        var animations: [CAAnimation] = []
        
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.duration = duration
        scaleAnim.values = [1.0, 0.9, 0.8, 0.9, 1.0]
        animations.append(scaleAnim)
        
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.duration = duration
        opacityAnim.values = [1, 0.618, 0.382, 0.618, 1.0]
        animations.append(opacityAnim)
        
        let groups = CAAnimationGroup()
        groups.animations = animations
        groups.isRemovedOnCompletion = false
        groups.fillMode = .forwards
        groups.duration = duration
        groups.repeatCount = .greatestFiniteMagnitude
        
        layer.add(groups, forKey: "stars_breatheAnimation")
    }
    
    /// 透明度动画
    func opacityAnimationS(_ duration: CGFloat) {
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.duration = CFTimeInterval(duration)
        opacityAnim.values = [1, 0.618, 0.382, 0.618, 1.0]
        
        let groups = CAAnimationGroup()
        groups.animations = [opacityAnim]
        groups.isRemovedOnCompletion = false
        groups.fillMode = .forwards
        groups.duration = CFTimeInterval(duration)
        groups.repeatCount = .greatestFiniteMagnitude
        
        layer.add(groups, forKey: "opacity_animation")
    }
    
    /// 放大，count：次数
    func zoomInS(_ count: Int) {
        cancelAnimatedS()
        let anim = CAKeyframeAnimation(keyPath: "transform.scale")
        anim.duration = 0.25
        anim.repeatCount = Float(count)
        anim.values = [1, 1.2, 1, 0.8, 1, 1.2, 1]
        anim.isRemovedOnCompletion = true
        anim.fillMode = .forwards
        layer.add(anim, forKey: "zoom_in_animation_\(count)")
    }
    
    /// 缩小，count：次数
    func zoomOutS(_ count: Int) {
        cancelAnimatedS()
        let anim = CAKeyframeAnimation(keyPath: "transform.scale")
        anim.duration = 0.25
        anim.repeatCount = Float(count)
        anim.values = [1, 0.8, 1, 1.2, 1, 0.8, 1]
        anim.isRemovedOnCompletion = true
        anim.fillMode = .forwards
        layer.add(anim, forKey: "zoom_out_animation_\(count)")
    }
    
    /// 呼吸发光动画
    func breatheAnimationS() {
        breatheAnimationS(3)
    }
    
    func breatheAnimationS(_ duration: CGFloat) {
        breatheAnimationS(duration, opacity: true)
    }
    
    func breatheAnimationS(_ duration: CGFloat, opacity: Bool) {
        cancelAnimatedS()
        
        var animations: [CAAnimation] = []
        
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.duration = CFTimeInterval(duration)
        scaleAnim.values = [1.0, 0.95, 1.0, 1.05, 1.0]
        animations.append(scaleAnim)
        
        if opacity {
            let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnim.duration = CFTimeInterval(duration)
            opacityAnim.values = [1, 0.85, 1, 0.85, 1.0]
            animations.append(opacityAnim)
        }
        
        let groups = CAAnimationGroup()
        groups.animations = animations
        groups.isRemovedOnCompletion = false
        groups.fillMode = .forwards
        groups.duration = CFTimeInterval(duration)
        groups.repeatCount = .greatestFiniteMagnitude
        
        layer.add(groups, forKey: "breathe_animation")
    }
    
    /// 上下漂浮动画
    func floatingAnimationS() {
        floatingAnimationS(2.0)
    }
    
    func floatingAnimationS(_ duration: CGFloat) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let height: CGFloat = 7
        let currentY = transform.ty
        animation.duration = CFTimeInterval(duration)
        animation.values = [currentY, currentY - height/4, currentY - height/4*2, currentY - height/4*3, currentY - height, currentY - height/4*3, currentY - height/4*2, currentY - height/4, currentY]
        animation.keyTimes = [0, 0.025, 0.085, 0.2, 0.5, 0.8, 0.915, 0.975, 1]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = .greatestFiniteMagnitude
        layer.add(animation, forKey: "kViewShakerAnimationKey")
    }
    
    /// 左右漂浮动画
    func floatingHorizontalAnimationS(_ duration: CGFloat) {
        cancelAnimatedS()
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let height: CGFloat = 7
        let currentX = transform.tx
        animation.duration = CFTimeInterval(duration)
        animation.values = [currentX, currentX - height/4, currentX - height/4*2, currentX - height/4*3, currentX - height, currentX - height/4*3, currentX - height/4*2, currentX - height/4, currentX]
        animation.keyTimes = [0, 0.025, 0.085, 0.2, 0.5, 0.8, 0.915, 0.975, 1]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = .greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "kViewShakerAnimationKey.x")
    }
    
    /// isY：YES，绕Y轴旋转；NO，绕Z轴旋转
    func rotateByShaftS(isY: Bool, duration: CFTimeInterval, delegate: CAAnimationDelegate?, repeatCount: Float) {
        cancelAnimatedS()
        
        let keyPath = isY ? "transform.rotation.y" : "transform.rotation.z"
        let rotationAnimation = CABasicAnimation(keyPath: keyPath)
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = duration
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = repeatCount
        rotationAnimation.delegate = delegate
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = .forwards
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// 【Controller】交叉溶解动画（0.4s动画时间）
    static func crossDissolveS(to viewController: UIViewController, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        crossDissolveS(to: viewController, duration: 0.4, animations: animations, completion: completion)
    }
    
    /// 【Controller】交叉溶解动画（自定义动画时间）
    static func crossDissolveS(to viewController: UIViewController, duration: TimeInterval, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        viewController.modalTransitionStyle = .crossDissolve
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        
        let animationsBlock: () -> Void = {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            animations?()
            UIView.setAnimationsEnabled(oldState)
        }
        
        UIView.transition(with: UIApplication.shared.delegate!.window!!, duration: duration, options: options, animations: animationsBlock, completion: completion)
    }
    
    /// 【View】交叉溶解动画（0.25s动画时间）
    static func crossDissolveS(with view: UIView, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        crossDissolveS(with: view, duration: 0.25, animations: animations, completion: completion)
    }
    
    /// 【View】交叉溶解动画（自定义动画时间）
    static func crossDissolveS(with view: UIView, duration: TimeInterval, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        
        let animationsBlock: () -> Void = {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            animations?()
            UIView.setAnimationsEnabled(oldState)
        }
        
        UIView.transition(with: view, duration: duration, options: options, animations: animationsBlock, completion: completion)
    }
}
