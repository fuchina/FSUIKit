//
//  UIView+Animated.m
//  ModuleOxfordUtils
//
//  Created by tanqi on 2021/4/6.
//

#import "UIView+Animated.h"

@implementation UIView (Animated)

- (void)cancelAnimated {
    [self.layer removeAllAnimations];
}

/**
    摇晃
 */
- (void)shake:(NSInteger)count {
    [self shake: count delegate:nil];
}

- (void)shake:(NSInteger)count delegate:(nullable id<CAAnimationDelegate>)delegate {
    [self shake: count duration: 0.15 delegate: delegate];
}

- (void)shake:(NSInteger)count duration:(CGFloat)duration delegate:(nullable id<CAAnimationDelegate>)delegate {
    [self cancelAnimated];
    [self shake: count duration: duration anchorPoint: CGPointMake(0.5, 0.5) delegate: delegate];
}

- (void)shake:(NSInteger)count duration:(CGFloat)duration anchorPoint:(CGPoint)point delegate:(nullable id<CAAnimationDelegate>)delegate {
    [self cancelAnimated];
    
    CGFloat radian = 10 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath: @"transform.rotation"];
    anim.duration = duration;
    anim.repeatCount = count;
    anim.values = @[@0, @(-radian), @0, @(radian), @0];
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    if (delegate) {
        anim.delegate = (id<CAAnimationDelegate>)delegate;
    }
    self.layer.anchorPoint = point;
    [self.layer addAnimation: anim forKey: [NSString stringWithFormat: @"shake_animation_%ld", (long)count]];
}

/**
    放大
 */
- (void)zoomIn:(NSInteger)count {
    [self cancelAnimated];
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim.duration = 0.25;
    anim.repeatCount = count;
    anim.values = @[@(1), @(1.2), @(1), @(0.8), @(1), @(1.2), @(1)];
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:[NSString stringWithFormat:@"zoom_in_animation_%ld", (long)count]];
}

/**
    上下漂浮动画
 */
- (void)floatingAnimaition {
    [self floatingAnimaition:2.0f];
}

- (void)floatingAnimaition:(CGFloat)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat height = 7.f;
    CGFloat currentY = self.transform.ty;
    animation.duration = duration;
    animation.values = @[@(currentY),@(currentY - height/4),@(currentY - height/4*2),@(currentY - height/4*3),@(currentY - height),@(currentY - height/ 4*3),@(currentY - height/4*2),@(currentY - height/4),@(currentY)];
    animation.keyTimes = @[ @(0), @(0.025), @(0.085), @(0.2), @(0.5), @(0.8), @(0.915), @(0.975), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}

- (void)floatingHorizontalAnimaition:(CGFloat)duration {
    [self cancelAnimated];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat height = 7.f;
    CGFloat currentX = self.transform.tx;
    animation.duration = duration;
    animation.values = @[@(currentX),@(currentX - height / 4),@(currentX - height / 4 * 2),@(currentX - height / 4 * 3),@(currentX - height),@(currentX - height/ 4 * 3),@(currentX - height /4 * 2),@(currentX - height / 4),@(currentX)];
    animation.keyTimes = @[@(0), @(0.025), @(0.085), @(0.2), @(0.5), @(0.8), @(0.915), @(0.975), @(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:@"kViewShakerAnimationKey.x"];
}

/**
    缩小
 */
- (void)zoomOut:(NSInteger)count {
    [self cancelAnimated];
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim.duration = 0.25;
    anim.repeatCount = count;
    anim.values = @[@(1), @(0.8), @(1), @(1.2), @(1), @(0.8), @(1)];
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:[NSString stringWithFormat:@"zoom_out_animation_%ld", (long)count]];
}

/**
    呼吸发光动画
 */
- (void)breatheAnimation {
    [self breatheAnimation:3];
}

- (void)breatheAnimation:(CGFloat)duration {
    [self breatheAnimation:duration opacity:YES];
}

- (void)breatheAnimation:(CGFloat)duration opacity:(BOOL)opacity {
    [self cancelAnimated];
    
    NSMutableArray *animations = [[NSMutableArray alloc] init];
    
    // 缩放动画
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.duration = duration;
    scaleAnim.values = @[@(1.0), @(0.95), @(1.0), @(1.05), @(1.0)];
    [animations addObject:scaleAnim];
    
    // 透明度动画
    if (opacity) {
        CAKeyframeAnimation *opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.duration = duration;
        opacityAnim.values = @[@(1), @(0.85), @(1), @(0.85), @(1.0)];
        
        [animations addObject: opacityAnim];
    }
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = animations.copy;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.duration = duration;
    groups.repeatCount = FLT_MAX;
    
    [self.layer addAnimation:groups forKey:[NSString stringWithFormat:@"breathe_animation"]];
}

- (void)stars_breatheAnimation {
    [self cancelAnimated];
    
    CFTimeInterval duration = 2;
    NSMutableArray *animations = [[NSMutableArray alloc] init];
    
    // 缩放动画
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.duration = duration;
    scaleAnim.values = @[@(1.0), @(0.9), @(0.8), @(0.9), @(1.0)];
    [animations addObject:scaleAnim];
    
    // 透明度动画
    CAKeyframeAnimation *opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.duration = duration;
    opacityAnim.values = @[@(1), @(0.618), @(0.382), @(0.618), @(1.0)];
    
    [animations addObject:opacityAnim];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = animations.copy;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.duration = duration;
    groups.repeatCount = FLT_MAX;
    
    [self.layer addAnimation:groups forKey:[NSString stringWithFormat:@"stars_breatheAnimation"]];
}

// 透明度动画
- (void)opacityAnimation:(CGFloat)duration {
    CAKeyframeAnimation *opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.duration = duration;
    opacityAnim.values = @[@(1), @(0.618), @(0.382), @(0.618), @(1.0)];
        
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[opacityAnim];
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.duration = duration;
    groups.repeatCount = FLT_MAX;
    
    [self.layer addAnimation:groups forKey:[NSString stringWithFormat:@"opacity_animation"]];
}

- (void)rotateByShaft:(BOOL)isY duration:(CFTimeInterval)duration delegate:(id<CAAnimationDelegate>)delegate repeat:(float)repeatCount {
    [self cancelAnimated];
    
    CABasicAnimation *rotationAnimation;
    NSString *keyPath = nil;
    if (isY) {
        keyPath = @"transform.rotation.y";
    } else {
        keyPath = @"transform.rotation.z";
    }
    rotationAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeatCount;
    rotationAnimation.delegate = delegate;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/**
    交叉溶解动画
 */
+ (void)crossDissolveToViewController:(UIViewController *)viewController
                           animations:(void (^ _Nullable)(void))animations
                           completion:(void (^ _Nullable)(BOOL))completion {
    [self crossDissolveToViewController:viewController duration:0.4 animations:animations completion:completion];
}
+ (void)crossDissolveToViewController:(UIViewController *)viewController
                             duration:(NSTimeInterval)duration
                           animations:(void(^ _Nullable)(void))animations
                           completion:(void(^ _Nullable)(BOOL finished))completion {
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCrossDissolve;
    
    void(^animationsBlock)(void) = ^(void){
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        if (animations) {
            animations();
        }
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:[UIApplication sharedApplication].delegate.window duration:duration options:options animations:animationsBlock completion:completion];
}

+ (void)crossDissolveWithView:(UIView *)view
                   animations:(void(^ _Nullable)(void))animations
                   completion:(void(^ _Nullable)(BOOL finished))completion {
    [self crossDissolveWithView:view duration:0.25 animations:animations completion:completion];
}

+ (void)crossDissolveWithView:(UIView *)view
                     duration:(NSTimeInterval)duration
                   animations:(void(^ _Nullable)(void))animations
                   completion:(void(^ _Nullable)(BOOL finished))completion {
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCrossDissolve;
    
    void(^animationsBlock)(void) = ^(void){
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        if (animations) {
            animations();
        }
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:view duration:duration options:options animations:animationsBlock completion:completion];
}

@end
