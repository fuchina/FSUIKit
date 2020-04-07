//
//  FSUICommon.m
//  com.fuhope.sale
//
//  Created by FudonFuchina on 2019/4/20.
//  Copyright © 2019 FudonFuchina. All rights reserved.
//

#import "FSUICommon.h"

@implementation FSUICommon

+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0,0);
    theView.layer.shadowOpacity = 0.3;
    theView.layer.shadowRadius = 5;
}

+ (void)addShadowView:(UIView *)theView withColor:(UIColor *)theColor {
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0,0);
    theView.layer.shadowOpacity = 0.5;
    theView.layer.shadowRadius = 5;
    // 单边阴影 顶边
    float shadowPathWidth = theView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, theView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    theView.layer.shadowPath = path.CGPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
