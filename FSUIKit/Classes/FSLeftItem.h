//
//  FSLeftItem.h
//  ShareEconomy
//
//  Created by fudon on 2016/9/6.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"

typedef NS_ENUM(NSInteger, FSItemTitleMode) {
    FSItemTitleModeDefault,
    FSItemTitleModeNOChar,// 没有字符
};

@interface FSBackItemView : UIView

@property (nonatomic,assign) FSItemTitleMode    mode;
@property (nonatomic,strong) UIColor            *color;

@end

@interface FSLeftItem : UIView

@property (nonatomic,assign) FSItemTitleMode    mode;
@property (nonatomic,strong) UIColor    *color;
@property (nonatomic,strong) UILabel    *textLabel;

@property (nonatomic,copy) void (^tapBlock) (void);

@end
