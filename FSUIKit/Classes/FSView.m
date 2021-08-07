//
//  FSView.m
//  FSBaseController
//
//  Created by FudonFuchina on 2019/5/12.
//

#import "FSView.h"

@implementation FSView {
    UIView      *_tapBackView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tapBackView.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self fs_add_tap_event_in_base_view];
    }
    return self;
}

- (void)fs_add_tap_event_in_base_view{
    _tapBackView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_tapBackView];
    
    UITapGestureRecognizer *one = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_fs_tap_click_event:)];
    [_tapBackView addGestureRecognizer:one];
}

- (void)_fs_tap_click_event:(UITapGestureRecognizer *)tap {
    if (self.click) {
        self.click(self);
    }
}

- (FSView *)viewWithTheTag:(NSInteger)tag {
    for (FSView *sub in self.subviews) {
        if ([sub isKindOfClass:FSView.class]) {
            if (sub.theTag == tag) {
                return sub;
            }
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
