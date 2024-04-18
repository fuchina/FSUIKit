//
//  FSImage.h
//  FSCalculator
//
//  Created by fudongdong on 2018/12/20.
//

#import <Foundation/Foundation.h>

@interface FSImage : NSObject

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

/*
 * @param size：整个视图的大小
 * @param direction：YES为水平分段，NO为垂直分段
 * @param segements：分段数目
 * @param ratios：段数参数列表，每段占比，个数必须跟segements相同，值类型为NSNumber，所有值加起来等于1
 * @param colors：段数参数列表，每段颜色，个数必须跟segements相同，值类型为UIColor
 */
+ (UIImage *)imageWithSize:(CGSize)size
                 direction:(BOOL)isHorizon
                offsetLeft:(CGFloat)left
               offsetRight:(CGFloat)right
                    ratios:(NSArray<NSNumber *> *)ratios
                    colors:(NSArray<UIColor *> *)colors;

+ (UIImage *)imageWithSize:(CGSize)size
           backgroundColor:(UIColor *)backgroundColor
                 mainColor:(UIColor *)mainColor
               marginColor:(UIColor *)marginColor;

// 图片解码
+ (UIImage *)decodedImageWithImage:(UIImage *)image;

/*
 * 按照2的倍数压缩图片
 */
+ (UIImage *)compressImage:(UIImage *)image width:(NSInteger)minWidth;

/*
 * 压缩图片，MT项目中实用
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth;

+ (UIImage*)imageForUIView:(UIView *)view;

/**
 * 根据两个颜色渐变生成图片
 *return UIImage对象
 */
+ (UIImage *)imageGradualFromColorWithARed:(CGFloat)aRed aGreen:(CGFloat)aGreen aBlue:(CGFloat)aBlue aAlpha:(CGFloat)aAlpha toColorWithBRed:(CGFloat)bRed bGreen:(CGFloat)bGreen bBlue:(CGFloat)bBlue bAlpha:(CGFloat)bAlpha width:(CGFloat)width height:(CGFloat)height;

@end

