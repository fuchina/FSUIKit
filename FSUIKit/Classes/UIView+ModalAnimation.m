//
//  UIView+ModalAnimation.m
//  FSCalculator
//
//  Created by fudongdong on 2018/12/27.
//

#import "UIView+ModalAnimation.h"

@implementation UIView (ModalAnimation)

- (void)pushAnimated:(BOOL)flag completion:(void (^ __nullable)(UIView *modalView))completion {
    [self pushAnimated:flag toFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) completion:completion];
}

- (void)pushAnimated:(BOOL)flag toFrame:(CGRect)frame completion:(void (^ __nullable)(UIView *modalView))completion {
    if (flag) {
           self.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
           [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1 /*震动效果，0-1，越小越明显*/ initialSpringVelocity:0.5
                               options:UIViewAnimationOptionCurveEaseOut
                            animations:^{
                                self.frame = frame;
                            } completion:^(BOOL finished) {
                                if (completion) {
                                    completion(self);
                                }
                            }];
    } else {
        self.frame = frame;
        if (completion) {
            completion(self);
        }
    }
}

- (void)popAnimated:(BOOL)flag removeFromSuperView:(BOOL)remove completion:(void (^ __nullable)(UIView *modalView))completion {
    [self popAnimated:flag toFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) removeFromSuperView:remove completion:completion];
}

- (void)popAnimated:(BOOL)flag toFrame:(CGRect)frame removeFromSuperView:(BOOL)remove completion:(void (^ __nullable)(UIView *modalView))completion {
    if (flag) {
           [UIView animateWithDuration:.5
                                 delay:0
                usingSpringWithDamping:1 /*震动效果，0-1，越小越明显*/
                 initialSpringVelocity:0.5
                               options:UIViewAnimationOptionCurveEaseOut
                            animations:^{
                                self.frame = frame;
                            }
                            completion:^(BOOL finished) {
                              [self popCallback:remove completion:completion];
                            }];
       } else {
           self.frame = frame;
           [self popCallback:remove completion:completion];
       }
}

- (void)popCallback:(BOOL)remove completion:(void (^ __nullable)(UIView *modalView))completion {
    if (completion) {
        completion(self);
    }
    
    if (remove) {
        self.frame = CGRectMake(10000, 0, 0, 0);
        self.hidden = YES;
        [self removeFromSuperview];
    }
}

@end
