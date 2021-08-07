//
//  FSTabView.m
//  FSUIKit
//
//  Created by FudonFuchina on 2021/8/7.
//

#import "FSTabView.h"

@implementation FSTabView

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = self.bounds;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
