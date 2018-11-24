//
//  FSWindow.h
//  Expand
//
//  Created by Fudongdong on 2017/9/29.
//  Copyright © 2017年 china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSWindow : UIWindow

+ (instancetype)sharedInstance;

+ (void)showView:(UIView *)view;
+ (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion;
+ (void)dismiss;

@end
