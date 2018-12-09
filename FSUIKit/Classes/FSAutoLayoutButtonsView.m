//
//  FSAutoLayoutButtonsView.m
//  myhome
//
//  Created by FudonFuchina on 2018/8/18.
//  Copyright © 2018年 fuhope. All rights reserved.
//

#import "FSAutoLayoutButtonsView.h"
#import "FSCalculator.h"

#define _key_value_button_tag 1000

@implementation FSAutoLayoutButtonsView{
    CGFloat _height;
}

- (void)setTexts:(NSArray<NSString *> *)texts{
    _texts = nil;
    if ([texts isKindOfClass:NSArray.class] && texts.count) {
        _texts = texts;
    }
    
    Class _class_UIButton = UIButton.class;
    for (UIButton *sub in self.subviews) {
        if ([sub isKindOfClass:_class_UIButton] && sub.tag > _key_value_button_tag) {
            sub.hidden = YES;
            [sub removeFromSuperview];
        }
    }
    
    Class _class_NSString = NSString.class;
    UIFont *font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    CGFloat sw = UIScreen.mainScreen.bounds.size.width;
    NSInteger lrMargin = 15;
    CGFloat rightMargin = sw - lrMargin;
    CGFloat offsetX = lrMargin;
    CGFloat offsetY = 20;
    CGFloat bh = 44;
    NSInteger xSpace = 30;
    for (int x = 0; x < texts.count; x ++) {
        NSString *item = texts[x];
        if (![item isKindOfClass:_class_NSString]) {
            continue;
        }
        
        CGFloat w = [FSCalculator textWidth:item font:font labelHeight:30] + 40;
        if ((offsetX + w) > rightMargin) {
            offsetY += 70;
            offsetX = lrMargin;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(offsetX, offsetY, w, bh);
        button.tag = x + _key_value_button_tag + 1;
        button.backgroundColor = UIColor.whiteColor;
        [button setTitle:item forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        offsetX += (w + xSpace);
        
        if (self.configButton) {
            self.configButton(button);
        }
    }
    _height = offsetY + bh;
}

- (CGFloat)selfHeight{
    return  _height;
}

- (void)btnClick:(UIButton *)button{
    if (self.click) {
        NSInteger index = button.tag - _key_value_button_tag - 1;
        self.click(self, index);
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
