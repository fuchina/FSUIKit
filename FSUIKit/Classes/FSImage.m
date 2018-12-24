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
+ (UIImage *)imageWithSize1:(CGSize)size
                 direction:(BOOL)isHorizon
                    ratios:(NSArray<NSNumber *> *)ratios
                    colors:(UIColor *)colors,...NS_REQUIRES_NIL_TERMINATION
{
    if (!([ratios isKindOfClass:NSArray.class] && ratios.count)){
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    Class _class_NSNumber = NSNumber.class;
    Class _class_Color = UIColor.class;
    CGFloat sum = 0;
    
    va_list args;
    va_start(args, colors);
    for (int x = 0; x < ratios.count; x ++) {
        NSNumber *ratio = ratios[x];
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

// 高德导航蚯蚓线
+ (UIImage *)imageWithSize:(CGSize)size
                 direction:(BOOL)isHorizon
                offsetLeft:(CGFloat)left
               offsetRight:(CGFloat)right
                    ratios:(NSArray<NSNumber *> *)ratios
                    colors:(NSArray<UIColor *> *)colors
{
    if (!([ratios isKindOfClass:NSArray.class] && ratios.count)){
        return nil;
    }
    if (!([ratios isKindOfClass:NSArray.class] && ratios.count)){
        return nil;
    }
    if (ratios.count != colors.count) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    Class _class_NSNumber = NSNumber.class;
    Class _class_Color = UIColor.class;
    CGFloat sum = 0;
    
    for (int x = 0; x < ratios.count; x ++) {
        NSNumber *ratio = ratios[x];
        if (![ratio isKindOfClass:_class_NSNumber]) {
            return nil;
        }
        UIColor *color = colors[x];
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
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageWithSize:(CGSize)size
           backgroundColor:(UIColor *)backgroundColor
                 mainColor:(UIColor *)mainColor
               marginColor:(UIColor *)marginColor
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    Class _class_Color = UIColor.class;

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([backgroundColor isKindOfClass:_class_Color]) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, size.width * 0.25,size.height));
        CGContextFillRect(context, CGRectMake(size.width * 0.75, 0, size.width * 0.25, size.height));
    }
    
    if ([mainColor isKindOfClass:_class_Color]) {
        CGContextSetFillColorWithColor(context, mainColor.CGColor);
        CGContextFillRect(context, CGRectMake(size.width * 0.3125, 0, size.width * 0.375,size.height));
    }
    
    if ([marginColor isKindOfClass:_class_Color]) {
        CGContextSetFillColorWithColor(context, marginColor.CGColor);
        CGContextFillRect(context, CGRectMake(size.width * 0.25, 0, size.width * 0.0625,size.height));
        CGContextFillRect(context, CGRectMake(size.width * 0.6875, 0, size.width * 0.0625, size.height));
    }
    
    UIImage *image = [UIImage imageNamed:@"arrow"];
    if ([image isKindOfClass:UIImage.class]) {
        CGContextDrawImage(context, CGRectMake(size.width / 2 - 8, size.height / 2 - 8, 16, 16), image.CGImage);
    }

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
