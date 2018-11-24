//
//  FSUIKit.h
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/3.
//

#import <UIKit/UIkit.h>

@interface FSUIKit : NSObject

// 根据action.title映射titles中的字段来判断点击事件   UIAlertActionStyleDefault
+ (void)alertOnCustomWindow:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler cancelTitle:(NSString *)cancelTitle cancel:(void (^)(UIAlertAction *action))cancel completion:(void (^)(void))completion;

+ (void)alertOnCustomWindow:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler;

+ (void)alert:(UIAlertControllerStyle)style controller:(UIViewController *)pController title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler;

+ (void)alert:(UIAlertControllerStyle)style controller:(UIViewController *)pController title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler cancelTitle:(NSString *)cancelTitle cancel:(void (^)(UIAlertAction *action))cancel completion:(void (^)(void))completion;

// 有输入框时，number为输入框数量，根据textField的tag【0、1、2...】来配置textField
+ (void)alertInput:(NSInteger)number controller:(UIViewController *)controller title:(NSString *)title message:(NSString *)message ok:(NSString *)okTitle handler:(void (^)(UIAlertController *bAlert,UIAlertAction *action))handler cancel:(NSString *)cancelTitle handler:(void (^)(UIAlertAction *action))cancelHandler textFieldConifg:(void (^)(UITextField *textField))configurationHandler completion:(void (^)(void))completion;

+ (void)alertInputOnCustomWindow:(NSInteger)number title:(NSString *)title message:(NSString *)message ok:(NSString *)okTitle handler:(void (^)(UIAlertController *bAlert,UIAlertAction *action))handler cancel:(NSString *)cancelTitle handler:(void (^)(UIAlertAction *action))cancelHandler textFieldConifg:(void (^)(UITextField *textField))configurationHandler completion:(void (^)(void))completion;

+ (void)xuanzhuanView:(UIView *)view;

+ (void)showFullScreenImage:(UIImageView *)avatarImageView;

+ (void)showMessage:(NSString *)message;
+ (void)showAlertWithMessageOnCustomWindow:(NSString *)message;
+ (void)showAlertWithMessageOnCustomWindow:(NSString *)message handler:(void (^)(UIAlertAction *action))handler;
+ (void)showAlertWithTitleOnCustomWindow:(NSString *)title message:(NSString *)message ok:(NSString *)ok handler:(void (^)(UIAlertAction *action))handler;
+ (void)showAlertWithMessage:(NSString *)message controller:(UIViewController *)controller;
+ (void)showAlertWithMessage:(NSString *)message controller:(UIViewController *)controller handler:(void (^)(UIAlertAction *action))handler;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok controller:(UIViewController *)pController handler:(void (^)(UIAlertAction *action))handler;

// 压缩图片
+ (UIImage *)compressImageData:(NSData *)imageData;
+ (UIImage *)compressImage:(UIImage *)imageData;
+ (UIImage *)compressImage:(UIImage *)image width:(NSInteger)minWidth minHeight:(NSInteger)minHeight;

+ (UIImage *)compressImage:(UIImage *)image width:(NSInteger)width;
+ (UIImage*)imageForUIView:(UIView *)view;

// 创建一张实时模糊效果 View (毛玻璃效果)
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;
// 全屏截图
+ (UIImage *)shotFullScreen;
//截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;
//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view;

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;

// 绘制虚线
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;
+ (UIImage *)QRImageFromString:(NSString *)string;
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;
+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset;
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth; // 将图片大小设置为目标大小，用于压缩图片
+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth;
#pragma mark - 对图片进行滤镜处理
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;
#pragma mark -  对图片进行模糊处理
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;

    

@end
