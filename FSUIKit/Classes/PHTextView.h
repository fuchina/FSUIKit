//
//  PHTextView.h
//  Daiyida
//
//  Created by fudon on 15/1/30.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;  //textview的placeholder

@property (nonatomic, copy) NSString *contentText;  //textview 的内容

@property (nonatomic, strong) UIColor *contentTextColor;

@end
