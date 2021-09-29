//
//  FSTapCell.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/21.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSTapCell;
typedef void(^TapCellBlock)(FSTapCell *bCell);

@interface FSTapCell : UITableViewCell

@property (nonatomic,copy) TapCellBlock     block;

// 配置cell元素
- (void)configurate:(NSString *)text textColor:(UIColor *)textColor font:(UIFont*)font; // API_AVAILABLE(ios(14.0), tvos(14.0), watchos(7.0));

- (void)configurate:(NSString *)text textColor:(UIColor *)textColor font:(UIFont*)font detailText:(NSString *)detailText detailFont:(UIFont *)detailFont detailColor:(UIColor *)detailColor;

@end
