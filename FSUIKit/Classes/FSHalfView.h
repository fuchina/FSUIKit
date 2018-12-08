//
//  FSHalfView.h
//  myhome
//
//  Created by Fudongdong on 2017/8/17.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSHalfView : UIView

@property (nonatomic,strong) NSArray            *dataSource;
@property (nonatomic,copy)void (^configCell)(UITableView *bTableView,NSIndexPath *bIndexPath,UITableViewCell *bCell);
@property (nonatomic,copy)void (^selectCell)(UITableView *bTableView,NSIndexPath *bIndexPath);

- (void)showHalfView:(BOOL)show;

@end
