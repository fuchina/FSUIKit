//
//  FSLabelTextField.m
//  myhome
//
//  Created by fudon on 2017/5/26.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSLabelTextField.h"

@implementation FSLabelTextField

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textFieldText:(NSString *)tfText placeholder:(NSString *)placeholder{
    self = [super initWithFrame:frame];
    if (self) {
        [self labelTextFieldDesignViews:text textFieldText:tfText placeholder:placeholder];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self labelTextFieldDesignViews:nil textFieldText:nil placeholder:@"请输入"];
    }
    return self;
}

- (void)labelTextFieldDesignViews:(NSString *)text textFieldText:(NSString *)tfText placeholder:(NSString *)placeholder{
    CGFloat widthSelf = self.bounds.size.width;
    CGFloat heightSelf = self.bounds.size.height;
    self.backgroundColor = [UIColor whiteColor];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, widthSelf / 2, heightSelf)];
    _label.text = text;
    [self addSubview:_label];
    _label.userInteractionEnabled = YES;
    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [_label addGestureRecognizer:t];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(widthSelf / 3, 0, widthSelf * 2 / 3 - 15, heightSelf)];
    _textField.placeholder = placeholder;
    _textField.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1.0f];
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.text = tfText;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.textAlignment = NSTextAlignmentRight;
    [self addSubview:_textField];
}

- (void)tapClick{
    if (self.tapEvent) {
        self.tapEvent(self);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end


