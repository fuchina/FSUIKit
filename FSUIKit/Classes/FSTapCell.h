//
//  FSTapCell.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/21.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FSTapCell;
typedef void(^TapCellBlock)(FSTapCell *bCell);

@interface FSTapCell : UIView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;
    
@property (nonatomic,copy) TapCellBlock     click;

@property (nonatomic, strong) UILabel       *textLabel;
@property (nonatomic, strong) UILabel       *detailTextLabel;

@end

NS_ASSUME_NONNULL_END

