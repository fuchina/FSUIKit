//
//  FSUICommon.h
//  com.fuhope.sale
//
//  Created by FudonFuchina on 2019/4/20.
//  Copyright © 2019 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSUICommon : UIView

// 添加四边阴影效果
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor;

// 添加单边阴影效果
+ (void)addShadowView:(UIView *)theView withColor:(UIColor *)theColor;

@end

NS_ASSUME_NONNULL_END
