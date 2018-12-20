//
//  FSImage.m
//  FSCalculator
//
//  Created by fudongdong on 2018/12/20.
//

#import "FSImage.h"

@implementation FSImage

+ (UIImage *)imageFromColor:(UIColor *)color{
    return [self imageFromColor:color size:CGSizeMake(1, 10)];
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size{
    if (![color isKindOfClass:UIColor.class]) {
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
