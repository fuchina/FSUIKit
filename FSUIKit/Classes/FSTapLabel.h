//
//  FSTapLabel.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/3.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSTapLabel;
typedef void(^FSTapLabelBlock)(FSTapLabel *bLabel);

@interface FSTapLabel : UILabel

@property (nonatomic,copy) FSTapLabelBlock  block;

@end
