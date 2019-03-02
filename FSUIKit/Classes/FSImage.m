//
//  FSImage.m
//  FSCalculator
//
//  Created by fudongdong on 2018/12/20.
//

#import "FSImage.h"
#import "FSCalculator.h"

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

+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    if (image.images) {
        // Do not decode animated images
        return image;
    }
    
    CGImageRef imageRef = image.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) return image;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth{
    CGFloat sourceWidth = sourceImage.size.width;
    CGFloat sourceHeight = sourceImage.size.height;
    CGFloat targetHeight = (targetWidth / sourceWidth) * sourceHeight;
    
    CGFloat compressRate = sourceWidth * sourceHeight / (targetWidth * targetHeight);
    if (compressRate <= 1.0f) {
        return sourceImage;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)compressImage:(UIImage *)image width:(NSInteger)minWidth {
    if (![image isKindOfClass:UIImage.class]) {
        return nil;
    }
    if (image.size.width < 1) {
        return image;
    }
    NSInteger comp = 1;
    NSInteger targetWidth = image.size.width;
    while (targetWidth > minWidth) {
        comp *= 2;
        targetWidth /= comp;
    }
    if (targetWidth < minWidth) {
        comp /= 2;
    }
    if (comp < 2) {
        return image;
    }
    
    if (comp > 0) {
        NSInteger width = image.size.width / comp;
        return [self compressImage:image targetWidth:width];
    }
    return image;
}

+ (UIImage*)imageForUIView:(UIView*)view{
    //    UIGraphicsBeginImageContext(view.bounds.size);// 只会生成屏幕所见的部分
    CGSize size = view.bounds.size;
    if ([view isKindOfClass:UIScrollView.class]) {
        UIScrollView *sView = (UIScrollView *)view;
        size = CGSizeMake(sView.frame.size.width,sView.contentSize.height+ sView.contentInset.top+ sView.contentInset.bottom);
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, view.layer.contentsScale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    //    CGContextRestoreGState(currnetContext);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
