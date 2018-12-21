//
//  FSModalView.m
//  FSCalculator
//
//  Created by fudongdong on 2018/12/21.
//

#import "FSModalView.h"

@interface FSModalView ()<CAAnimationDelegate>

@end

@implementation FSModalView{
    void(^_pushCompletion)(FSModalView *view);
    void(^_popCompletion)(FSModalView *view);
}

- (void)pushAnimated: (BOOL)flag completion:(void (^ __nullable)(FSModalView *modalView))completion{
    _pushCompletion = completion;
    
    self.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    if (flag) {
        CATransition *transition = CATransition.animation;
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        transition.delegate = self;
        [self.layer addAnimation:transition forKey:nil];
    }
}

- (void)popAnimated: (BOOL)flag completion:(void (^ __nullable)(FSModalView *modalView))completion{
    _popCompletion = completion;
    
    self.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    if (flag) {
        CATransition *transition = CATransition.animation;
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
        transition.delegate = self;
        [self.layer addAnimation:transition forKey:nil];
    }
}

#pragma mark CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (_pushCompletion) {
        _pushCompletion(self);
    }
    if (_popCompletion) {
        _popCompletion(self);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
