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

// 高德导航蚯蚓线
+ (UIImage *)imageWithSize:(CGSize)size
                 direction:(BOOL)isHorizon
                 segements:(NSInteger)segements
           ratiosAndColors:(NSNumber *)ratios,...NS_REQUIRES_NIL_TERMINATION
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    Class _class_NSNumber = NSNumber.class;
    Class _class_Color = UIColor.class;
    CGFloat sum = 0;
    
    va_list args;
    va_start(args, ratios);
    for (int x = 0; x < segements; x ++) {
        NSNumber *ratio = va_arg(args, NSNumber *);
        if (![ratio isKindOfClass:_class_NSNumber]) {
            return nil;
        }
        UIColor *color = va_arg(args, UIColor *);
        if (![color isKindOfClass:_class_Color]) {
            return nil;
        }
        CGFloat fratio = ratio.floatValue;
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        if (isHorizon) {
            CGContextFillRect(context, CGRectMake(0, sum * size.height, size.width, fratio * size.height));
        }else{
            CGContextFillRect(context, CGRectMake(sum * size.width, 0, fratio * size.width, size.height));
        }

        sum += fratio;
    }
    va_end(args);

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
