//
//  UIImage+Bundle.m
//  FSUIKit
//
//  Created by FudonFuchina on 2021/7/31.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (UIImage *)imageWithBundle:(NSString *)bundle imageName:(NSString *)imageName {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *bundlePath = [mainBundle pathForResource:bundle ofType:@"bundle"];
    NSBundle *currentBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *imagePath = [currentBundle pathForResource:imageName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
