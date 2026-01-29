//
//  FSUIKit.h
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/3.
//

#import <UIKit/UIKit.h>
#import "FSAlertAction.h"
#import "FSImage.h"
#import "UIAlertController+ClickDismiss.h"

@interface FSUIKit : NSObject

+ (UIAlertController *)alert:(UIAlertControllerStyle)style controller:(UIViewController *)pController title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(FSAlertAction *action))handler API_AVAILABLE(ios(8.0));

+ (UIAlertController *)alert:(UIAlertControllerStyle)style controller:(UIViewController *)pController title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler cancelTitle:(NSString *)cancelTitle cancel:(void (^)(UIAlertAction *action))cancel completion:(void (^)(void))completion API_AVAILABLE(ios(8.0));

// 有输入框时，number为输入框数量，根据textField的tag【0、1、2...】来配置textField
+ (UIAlertController *)alertInput:(NSInteger)number controller:(UIViewController *)controller title:(NSString *)title message:(NSString *)message buttons:(NSInteger)buttons buttonConfig:(void (^)(FSAlertActionData *data))buttonConfig textFieldConifg:(void (^)(UITextField *textField))textFieldConfig completion:(void (^)(UIAlertController *alert))completion;

+ (void)showAlertWithMessage:(NSString *)message controller:(UIViewController *)controller;
+ (void)showAlertWithMessage:(NSString *)message controller:(UIViewController *)controller handler:(void (^)(UIAlertAction *action))handler API_AVAILABLE(ios(8.0));
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok controller:(UIViewController *)pController handler:(void (^)(UIAlertAction *action))handler API_AVAILABLE(ios(8.0));

// 创建一张实时模糊效果 View (毛玻璃效果)
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame API_AVAILABLE(ios(8.0));

//截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;
//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view;

//+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;
+ (void)captureScrollView:(UIScrollView *)scrollView finished:(void(^)(UIImage *image))completion;

// 绘制虚线
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;
+ (UIImage *)QRImageFromString:(NSString *)string;
+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset;

+ (CGFloat)scrollViewPage:(UIScrollView *)scrollView;

@end
