//
//  FSConstant.m
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/3.
//

#import "FSConstant.h"

@implementation FSConstant

// 横屏时会改变，这个不是常量
+ (CGFloat)screenWidth{
    static CGFloat w = 0;
    if (w < 1) {
        w = [UIScreen mainScreen].bounds.size.width;
    }
    return w;
}

+ (CGFloat)screenHeight{
    static CGFloat h = 0;
    if (h < 1) {
        h = [UIScreen mainScreen].bounds.size.height;
    }
    return h;
}

@end
