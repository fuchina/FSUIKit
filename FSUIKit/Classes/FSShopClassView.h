//
//  FSShopClassView.h
//  myhome
//
//  Created by FudonFuchina on 2016/12/4.
//  Copyright © 2016年 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSShopClassView : UIView

@property (nonatomic,assign) NSInteger              selectIndex;
@property (nonatomic,strong) NSArray<NSString *>    *dataSource;
@property (nonatomic,copy) void (^selectedBlock)(FSShopClassView *bView,NSInteger bIndex);

@end
