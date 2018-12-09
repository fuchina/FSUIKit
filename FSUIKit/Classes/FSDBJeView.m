//
//  FSDBJeView.m
//  myhome
//
//  Created by Fudongdong on 2017/12/21.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSDBJeView.h"

@implementation FSDBJeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self jeDesignViews];
    }
    return self;
}

- (void)jeDesignViews{
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
    CGSize size = self.frame.size;
    for (int x = 0; x < 2; x ++) {
        FSLabelTextField *textField = [[FSLabelTextField alloc] initWithFrame:CGRectMake(0, 10 + 45 * x, size.width, 44) text:x?NSLocalizedString(@"Note", nil):NSLocalizedString(@"Money", nil) textFieldText:nil placeholder:x?NSLocalizedString(@"Please input message", nil):NSLocalizedString(@"Please input money", nil)];
        textField.textField.keyboardType = x? UIKeyboardTypeDefault:UIKeyboardTypeDecimalPad;
        [self addSubview:textField];
        textField.label.font = [UIFont systemFontOfSize:17];
        textField.label.textColor = [UIColor blackColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, textField.frame.origin.y + textField.frame.size.height, size.width - 15, .6)];
        line.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];
        [self addSubview:line];
        if (x) {
            self.bzTF = textField;
        }else{
            self.jeTF = textField;
        }
    }
}

- (void)tapAction{
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
