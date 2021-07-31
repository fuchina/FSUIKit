//
//  FSImageLabelView.m
//  FSUIKit
//
//  Created by FudonFuchina on 2021/7/31.
//

#import "FSImageLabelView.h"

@implementation FSImageLabelView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = ceil(self.frame.size.width * .25);
    CGFloat w = ceil(self.frame.size.width * .5);
    CGFloat top = ceil(self.frame.size.height * .1);
    CGFloat h = ceil(self.frame.size.height * .7);
    _imageView.frame = CGRectMake(x, top, w, w);
    _label.frame = CGRectMake(0, h, self.frame.size.width, self.frame.size.height - h);
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat x = ceil(self.frame.size.width * .25);
        CGFloat w = ceil(self.frame.size.width * .5);
        CGFloat top = ceil(self.frame.size.height * .1);
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, top, w, w)];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        CGFloat top = ceil(self.frame.size.height * .7);
        CGFloat h = ceil(self.frame.size.height * .3);
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, h)];
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = UIColor.whiteColor;
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
