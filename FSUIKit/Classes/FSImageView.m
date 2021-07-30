//
//  FSImageView.m
//  FSUIKit
//
//  Created by FudonFuchina on 2021/7/31.
//

#import "FSImageView.h"

@implementation FSImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self fs_add_tap_event_in_base_view];
    }
    return self;
}

- (void)fs_add_tap_event_in_base_view{
    UITapGestureRecognizer *one = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_fs_tap_click_event:)];
    [self addGestureRecognizer:one];
}

- (void)_fs_tap_click_event:(UITapGestureRecognizer *)tap {
    if (self.click) {
        self.click(self);
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
