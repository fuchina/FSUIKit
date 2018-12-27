//
//  UIView+ModalAnimation.m
//  FSCalculator
//
//  Created by fudongdong on 2018/12/27.
//

#import "UIView+ModalAnimation.h"
#import <objc/runtime.h>

@implementation UIView (ModalAnimation)

static const char *_pushKey = "associatedPushKeys";
static const char *_popKey = "associatedPopKeys";
- (void)pushAnimated:(BOOL)flag completion:(void (^ __nullable)(UIView *modalView))completion{
    objc_setAssociatedObject(self, _pushKey, completion, OBJC_ASSOCIATION_COPY);
    
    self.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    if (flag) {
        CATransition *transition = CATransition.animation;
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        transition.delegate = (id <CAAnimationDelegate>)self;
        [self.layer addAnimation:transition forKey:@"push"];
    }
}

- (void)popAnimated:(BOOL)flag completion:(void (^ __nullable)(UIView *modalView))completion{
    objc_setAssociatedObject(self, _popKey, completion, OBJC_ASSOCIATION_COPY);

    self.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    if (flag) {
        CATransition *transition = CATransition.animation;
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
        transition.delegate = (id <CAAnimationDelegate>)self;
        [self.layer addAnimation:transition forKey:@"pop"];
    }
}

#pragma mark CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    void (^pushCompletion)(UIView *view) = objc_getAssociatedObject(self, _pushKey);
    if (pushCompletion) {
        pushCompletion(self);
        objc_removeAssociatedObjects(self);
    }
    
    void (^popCompletion)(UIView *view) = objc_getAssociatedObject(self, _popKey);
    if (popCompletion) {
        popCompletion(self);
        objc_removeAssociatedObjects(self);
        [self.layer removeAllAnimations];
    }
}


@end
