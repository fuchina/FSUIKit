//
//  UIImage+Bundle.h
//  FSUIKit
//
//  Created by FudonFuchina on 2021/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Bundle)

+ (UIImage *)imageWithBundle:(NSString *)bundle imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
