//
//  FSToast.m
//  myhome
//
//  Created by FudonFuchina on 2017/7/25.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSToast.h"

#import "FSUIKit-Swift.h"

@implementation FSToast

+ (UIView *)show:(NSString *)text {
    return [self show: text duration: 2];
}

+ (UIView *)show:(NSString *)text duration:(CGFloat)duration {
    return [FSToastS toast: text duration: duration];
}

+ (UIView *)show:(NSString *)text duration:(CGFloat)duration inView:(UIView *)superView {
    return [FSToastS toast: text duration: duration to: superView];
}

@end
