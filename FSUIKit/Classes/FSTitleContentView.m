//
//  FSTitleContentView.m
//  myhome
//
//  Created by FudonFuchina on 2018/3/26.
//  Copyright © 2018年 fuhope. All rights reserved.
//

#import "FSTitleContentView.h"

@implementation FSTitleContentView {
    UIView      *_tapView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self tcDesignViews];
    }
    return self;
}

- (void)tcDesignViews{
    _tapView = [[UIView alloc] initWithFrame:self.bounds];
    [self insertSubview:_tapView atIndex:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent)];
    [_tapView addGestureRecognizer:tap];
}

- (void)clickEvent {
    if (self.click) {
        self.click(self);
    }
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:_label];
    }
    return _label;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
