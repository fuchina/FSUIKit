//
//  FSView.h
//  FSBaseController
//
//  Created by FudonFuchina on 2019/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSView : UIView

@property (nonatomic, strong, readonly) UIView          *tapBackView;
@property (nonatomic,copy) void (^click)(FSView *view);
@property (nonatomic,copy) void (^clickLocation)(FSView *view, CGPoint point);

/**
 *  渐变色
 */
@property (nonatomic, strong) CAGradientLayer           *gradientLayer;

// 自定义的tag
@property (nonatomic, assign) NSInteger                 theTag;

- (void)dismiss;

+ (nullable __kindof FSView *)viewWithTheTag:(NSInteger)tag inView:(UIView *)inView;

@end

NS_ASSUME_NONNULL_END
