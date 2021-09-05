//
//  FSImageLabelView.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/14.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSImageLabelView;
typedef void(^FSImageLabelViewTapBlock)(FSImageLabelView *bImageLabelView);

@interface FSImageLabelView : UIView

@property (nonatomic,copy) FSImageLabelViewTapBlock     block;

+ (FSImageLabelView *)imageLabelViewWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text;

@end
