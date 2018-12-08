//
//  FSTitleContentView.m
//  myhome
//
//  Created by FudonFuchina on 2018/3/26.
//  Copyright © 2018年 fuhope. All rights reserved.
//

#import "FSTitleContentView.h"

@implementation FSTitleContentView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self tcDesignViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self tcDesignViews];
    }
    return self;
}

- (void)tcDesignViews{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_label];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _contentLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_contentLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLabel)]];
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
