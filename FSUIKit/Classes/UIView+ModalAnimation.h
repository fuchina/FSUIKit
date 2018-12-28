//
//  UIView+ModalAnimation.h
//  FSCalculator
//
//  Created by fudongdong on 2018/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ModalAnimation)

- (void)pushAnimated:(BOOL)flag completion:(void (^ __nullable)(UIView *modalView))completion;
- (void)popAnimated:(BOOL)flag completion:(void (^ __nullable)(UIView *modalView))completion;

@end

NS_ASSUME_NONNULL_END
