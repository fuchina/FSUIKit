//
//  FSToast.m
//  myhome
//
//  Created by FudonFuchina on 2017/7/25.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSToast.h"
#import <objc/runtime.h>

static char _kAssociateToastTapKey;

@implementation FSToast

+ (void)toast:(NSString *)text{
    [self toast:text duration:2];
}

+ (void)toast:(NSString *)text tap:(void (^)(void))tap{
    [self toast:text duration:2 start:-64 move:0 end:-64 tap:tap];
}

+ (void)toast:(NSString *)text duration:(CGFloat)duration{
    [self toast:text tap:nil];
}

+ (void)toast:(NSString *)text duration:(CGFloat)duration start:(CGFloat)start move:(CGFloat)move end:(CGFloat)end tap:(void (^)(void))cb{
    if ([text isKindOfClass:NSString.class] && text.length) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:13];
        label.text = text;
        [label sizeToFit];
        
        CGFloat tstHeight = 64;
        CGFloat labelWidth = label.bounds.size.width;
        CGFloat labelHeight = 0;
        CGFloat labelMax = size.width - 61;
        if (labelWidth > labelMax) {
            labelWidth = labelMax;
            labelHeight = [self textHeight:text fontInt:13 labelWidth:labelWidth];
        }else{
            labelHeight = 44;
        }
        label.frame = CGRectMake(56, 20, labelWidth, labelHeight);
        
        static UIImage *image = nil;
        if (!image) {
            image = [UIImage imageNamed:@"toast_right"];
        }
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 31, 22, 22)];
        img.image = image;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, start, size.width, tstHeight + labelHeight - 44)];
        [view addSubview:label];
        [view addSubview:img];
        view.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeView:)];
        [view addGestureRecognizer:tap];
        objc_setAssociatedObject(tap, &_kAssociateToastTapKey, cb, OBJC_ASSOCIATION_COPY);

        [self toastCustomView:view duration:duration start:start move:move end:end];
    }
}

+ (void)hiddeView:(UITapGestureRecognizer *)tap{
    void (^cb)(void) = objc_getAssociatedObject(tap, &_kAssociateToastTapKey);
    if (cb) {
        cb();
    }
    if (tap.view) {
        [tap.view removeFromSuperview];
    }
}

+ (void)show:(NSString *)text{
    [self show:text duration:2];
}

+ (void)show:(NSString *)text duration:(CGFloat)duration{
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self show:text duration:duration viewTop:(size.height - 40) / 2];
}

+ (void)show:(NSString *)text duration:(CGFloat)duration viewTop:(CGFloat)y{
    if ([text isKindOfClass:NSString.class] && text.length) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        UILabel *label = [self label];
        label.text = text;
        [label sizeToFit];
        
        CGFloat labelWidth = label.bounds.size.width;
        CGFloat labelHeight = 0;
        CGFloat labelMax = size.width - 80;
        if (labelWidth > labelMax) {
            labelWidth = labelMax;
            labelHeight = [self textHeight:text fontInt:14 labelWidth:labelWidth];
        }else{
            labelHeight = 24;
        }
        
        label.frame = CGRectMake(20, 10, labelWidth, labelHeight);
        
        UIView *view = [self baseView];
        CGFloat viewWidth = labelWidth + 40;
        view.frame = CGRectMake((size.width - viewWidth) / 2, y, viewWidth, labelHeight + 20);
        [view addSubview:label];
        
        [self showCustomView:view duration:duration];
    }
}

+ (void)showImageWithType:(CSPToastImageType)type text:(NSString *)text{
    UIImage *image = nil;
    switch (type) {
        case CSPToastImageTypeGreenHeart:{
            image = [UIImage imageNamed:@"toast_store"];
        }break;
            
        default:
            break;
    }
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self showImage:image text:text viewTop:(size.height - 40) / 2];
}

+ (void)showImage:(UIImage *)image text:(NSString *)text viewTop:(CGFloat)top{
    if ([text isKindOfClass:NSString.class] && text.length) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        UILabel *label = [self label];
        label.text = text;
        [label sizeToFit];
        CGFloat labelWidth = label.bounds.size.width;
        
        UIImageView *imageView = nil;
        if ([image isKindOfClass:UIImage.class]) {
            CGFloat imageWidth = 20 * (image.size.width / MAX(image.size.height, 1));
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, imageWidth, 20)];
            imageView.image = image;
        }
        
        CGFloat labelMax = (size.width - 80 - 5 - imageView.frame.size.width);
        CGFloat labelHeight = 0;
        if (labelWidth > labelMax) {
            labelWidth = labelMax;
            labelHeight = [self textHeight:text fontInt:14 labelWidth:labelWidth];
        }else{
            labelHeight = 24;
        }
        
        UIView *view = [self baseView];
        [view addSubview:imageView];
        
        label.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5, 10, labelWidth, labelHeight);
        [view addSubview:label];
        
        CGFloat viewWidth = labelWidth + 20 + imageView.frame.size.width + 5 + 20;
        view.frame = CGRectMake((size.width - viewWidth) / 2, top, viewWidth, labelHeight + 20);
        imageView.center = CGPointMake(imageView.center.x, view.frame.size.height / 2);
        [self showCustomView:view duration:2];
    }
}

+ (void)showCustomView:(UIView *)view duration:(CGFloat)duration{
    if ([view isKindOfClass:UIView.class]) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIDevice *device = [UIDevice currentDevice];
//            NSInteger os = [[device systemVersion] integerValue];
//            if (os >= 11) {
//                UIWindow *w = [UIApplication sharedApplication].keyWindow;
//                [w addSubview:view];
//            }else{
//            }
            NSArray *windows = [UIApplication sharedApplication].windows;
            UIWindow *w = nil;
            for (int x = (int)windows.count - 1; x >= 0; x --) {
                w = windows[x];
                if ((!w.hidden) && w.isKeyWindow) {
                    break;
                }
            }
            [w addSubview:view];
            
            [UIView animateWithDuration:0.3 delay:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        });
    }
}

+ (void)toastCustomView:(UIView *)view duration:(CGFloat)duration start:(CGFloat)start move:(CGFloat)move end:(CGFloat)end{
    if ([view isKindOfClass:UIView.class]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *windows = [UIApplication sharedApplication].windows;
            UIWindow *w = nil;
            for (int x = (int)windows.count - 1; x >= 0; x --) {
                w = windows[x];
                if ((!w.hidden) && w.isKeyWindow) {
                    break;
                }
            }
            [w addSubview:view];
            
            view.frame = CGRectMake(view.bounds.origin.x, start, view.bounds.size.width, view.bounds.size.height);
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
                view.frame = CGRectMake(view.bounds.origin.x, move, view.bounds.size.width, view.bounds.size.height);
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:.2 animations:^{
                        view.frame = CGRectMake(view.bounds.origin.x, end, view.bounds.size.width, view.bounds.size.height);
                    } completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
                });
            }];
        });
    }
}

+ (UIView *)baseView{
    static UIColor *backColor = nil;
    if (!backColor) {
        backColor = [UIColor colorWithRed:73 / 255.0 green:80 / 255.0 blue:86 / 255.0 alpha:.9];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    view.backgroundColor = backColor;
    view.layer.cornerRadius = 3;
    return view;
}

+ (UILabel *)label{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 0, 24)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    return label;
}

+ (CGFloat)textHeight:(NSString *)text fontInt:(NSInteger)fontInt labelWidth:(CGFloat)labelWidth{
    if(text){
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange allRange = [text rangeOfString:text];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:fontInt]
                        range:allRange];
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                            options:options
                                            context:nil];
        return ceilf(rect.size.height);
    }
    return 0;
}

@end
