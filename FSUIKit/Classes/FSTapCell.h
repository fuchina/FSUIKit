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

@end
