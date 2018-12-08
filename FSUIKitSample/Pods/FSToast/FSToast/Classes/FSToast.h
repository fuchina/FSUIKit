//
//  FSToast.h
//  myhome
//
//  Created by FudonFuchina on 2017/7/25.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CSPToastImageType) {
    CSPToastImageTypeGreenHeart = 1,        // 绿色心形，eg.收藏成功
};

@interface FSToast : NSObject

//  纯文字提示
+ (void)show:(NSString *)text;
+ (void)show:(NSString *)text duration:(CGFloat)duration;

// 从手机顶部弹出
+ (void)toast:(NSString *)text;
+ (void)toast:(NSString *)text tap:(void (^)(void))tap;
+ (void)toast:(NSString *)text duration:(CGFloat)duration;
+ (void)toast:(NSString *)text duration:(CGFloat)duration start:(CGFloat)start move:(CGFloat)move end:(CGFloat)end tap:(void (^)(void))cb;

//  显示几种默认图片
+ (void)showImageWithType:(CSPToastImageType)type text:(NSString *)text;

//  自定义图片:   top:view在屏幕中的纵坐标
+ (void)showImage:(UIImage *)image text:(NSString *)text viewTop:(CGFloat)top;

//  显示自定义的视图
+ (void)showCustomView:(UIView *)view duration:(CGFloat)duration;

@end
