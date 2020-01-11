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
- (void)pushAnimated:(BOOL)flag toFrame:(CGRect)frame completion:(void (^ __nullable)(UIView *modalView))completion;

/**
 * remove是否从父视图移除，如果不移除，对象会不释放
 */
- (void)popAnimated:(BOOL)flag removeFromSuperView:(BOOL)remove completion:(void (^ __nullable)(UIView *modalView))completion;

- (void)popAnimated:(BOOL)flag toFrame:(CGRect)frame removeFromSuperView:(BOOL)remove completion:(void (^ __nullable)(UIView *modalView))completion;

@end

NS_ASSUME_NONNULL_END
