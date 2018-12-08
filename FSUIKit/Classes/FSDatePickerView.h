//
//  FSDatePickerView.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/7.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSDatePickerView;

// 不把FSDatePickerView传过去的原因是，防止引用FSDatePickerView,让不能释放
typedef void(^FSDatePickerBlock)(NSDate *bDate);

@interface FSDatePickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date;

@property (nonatomic,copy) FSDatePickerBlock block;
@property (nonatomic,copy) void (^cancel)(void);

@end
