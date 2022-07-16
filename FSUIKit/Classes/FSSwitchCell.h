//
//  FSSwitchCell.h
//  Expand
//
//  Created by Fudongdong on 2017/11/29.
//  Copyright © 2017年 china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSwitchCell : UITableViewCell

@property (nonatomic, assign) NSInteger               on;
@property (nonatomic, copy)   void (^block)(UISwitch *s);

@end
