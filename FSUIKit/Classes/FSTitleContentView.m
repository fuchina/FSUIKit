//
//  FSTitleContentView.m
//  myhome
//
//  Created by FudonFuchina on 2018/3/26.
//  Copyright © 2018年 fuhope. All rights reserved.
//

#import "FSTitleContentView.h"

@implementation FSTitleContentView

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
