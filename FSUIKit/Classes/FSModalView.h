//
//  FSModalView.h
//  FSCalculator
//
//  Created by fudongdong on 2018/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSModalView : UIView

- (void)pushAnimated: (BOOL)flag completion:(void (^ __nullable)(FSModalView *modalView))completion;
- (void)popAnimated: (BOOL)flag completion:(void (^ __nullable)(FSModalView *modalView))completion;

@end

NS_ASSUME_NONNULL_END
