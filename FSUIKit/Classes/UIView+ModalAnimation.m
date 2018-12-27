//
//  UIView+ModalAnimation.m
//  FSCalculator
//
//  Created by fudongdong on 2018/12/27.
//

#import "UIView+ModalAnimation.h"

@implementation UIView (ModalAnimation)

- (void)pushAnimated:(BOOL)flag completion:(void (^ __nullable)(UIView *modalView))completion{
    if (flag) {
        self.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        [UIView animateWithDuration:.5
                              delay:0
             usingSpringWithDamping:1 /*震动效果，0-1，越小越明显*/
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion(self);
                             }
                         }];
    }else{
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        if (completion) {
            completion(self);
        }
    }
}

- (void)popAnimated:(BOOL)flag completion:(void (^ __nullable)(UIView *modalView))completion{
    if (flag) {
        [UIView animateWithDuration:.5
                              delay:0
             usingSpringWithDamping:1 /*震动效果，0-1，越小越明显*/
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion(self);
                             }
                         }];
    }else{
        self.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        if (completion) {
            completion(self);
        }
    }
}

@end
