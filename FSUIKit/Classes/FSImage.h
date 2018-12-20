//
//  FSImage.h
//  FSCalculator
//
//  Created by fudongdong on 2018/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSImage : NSObject

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
