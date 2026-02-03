////
////  UIView+Animated.h
////  ModuleOxfordUtils
////
////  Created by tanqi on 2021/4/6.
////
//
//#import <UIKit/UIKit.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface UIView (Animated)
//
///**
//    取消动画
// */
//- (void)cancelAnimated;
//
///**
//    摇晃，count：次数
// */
//- (void)shake:(NSInteger)count;
//- (void)shake:(NSInteger)count delegate:(nullable id<CAAnimationDelegate>)delegate;
//- (void)shake:(NSInteger)count duration:(CGFloat)duration delegate:(nullable id<CAAnimationDelegate>)delegate;
//- (void)shake:(NSInteger)count duration:(CGFloat)duration anchorPoint:(CGPoint)point delegate:(nullable id<CAAnimationDelegate>)delegate;
//
///**
// *  星星动画
// */
//- (void)stars_breatheAnimation;
//
///**
// *  透明度动画
// */
//- (void)opacityAnimation:(CGFloat)duration;
//
///**
//    放大，count：次数
// */
//- (void)zoomIn:(NSInteger)count;
//
///**
//    缩小，count：次数
// */
//- (void)zoomOut:(NSInteger)count;
//
///**
//    呼吸发光动画
// */
//- (void)breatheAnimation;
//- (void)breatheAnimation:(CGFloat)duration;
//- (void)breatheAnimation:(CGFloat)duration opacity:(BOOL)opacity;
//
///**
//    上下漂浮动画
// */
//- (void)floatingAnimaition;
//- (void)floatingAnimaition:(CGFloat)duration;
//
///**
// *  左右漂浮动画
// */
//- (void)floatingHorizontalAnimaition:(CGFloat)duration;
//
///**
// * isY：YES，绕Y轴旋转；NO，绕Z轴旋转
// * duration：动画时间
// */
//- (void)rotateByShaft:(BOOL)isY duration:(CFTimeInterval)duration delegate:(nullable id<CAAnimationDelegate>)delegate repeat:(float)repeatCount;
//
//
///** 【Controller】交叉溶解动画（0.4s动画时间） */
//+ (void)crossDissolveToViewController:(UIViewController *)viewController
//                           animations:(void(^ _Nullable)(void))animations
//                           completion:(void(^ _Nullable)(BOOL finished))completion;
///** 【Controller】交叉溶解动画（自定义动画时间） */
//+ (void)crossDissolveToViewController:(UIViewController *)viewController
//                             duration:(NSTimeInterval)duration
//                           animations:(void(^ _Nullable)(void))animations
//                           completion:(void(^ _Nullable)(BOOL finished))completion;
//
///** 【View】交叉溶解动画（0.25s动画时间） */
//+ (void)crossDissolveWithView:(UIView *)view
//                   animations:(void(^ _Nullable)(void))animations
//                   completion:(void(^ _Nullable)(BOOL finished))completion;
///** 【View】交叉溶解动画（自定义动画时间） */
//+ (void)crossDissolveWithView:(UIView *)view
//                     duration:(NSTimeInterval)duration
//                   animations:(void(^ _Nullable)(void))animations
//                   completion:(void(^ _Nullable)(BOOL finished))completion;
//
//@end
//
//NS_ASSUME_NONNULL_END
