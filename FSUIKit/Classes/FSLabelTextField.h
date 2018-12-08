//
//  FSLabelTextField.h
//  myhome
//
//  Created by fudon on 2017/5/26.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSLabelTextField : UIView

@property (nonatomic,strong) UILabel        *label;
@property (nonatomic,strong) UITextField    *textField;

@property (nonatomic,copy) void (^tapEvent)(FSLabelTextField *blf);

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textFieldText:(NSString *)tfText placeholder:(NSString *)placeholder;

@end

