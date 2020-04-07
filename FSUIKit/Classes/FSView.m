//
//  FSView.m
//  FSBaseController
//
//  Created by FudonFuchina on 2019/5/12.
//

#import "FSView.h"

@implementation FSView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self fs_add_tap_event_in_base_view];
    }
    return self;
}

- (void)fs_add_tap_event_in_base_view{
    UITapGestureRecognizer *one = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_fs_tap_click_event:)];
    one.numberOfTapsRequired = 1;
    [self addGestureRecognizer:one];
//    UITapGestureRecognizer *two = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_fs_tap_click_event:)];
//    two.numberOfTapsRequired = 2;
//    [self addGestureRecognizer:two];
//    [one requireGestureRecognizerToFail:two]; // 响应很慢
}

- (void)_fs_tap_click_event:(UITapGestureRecognizer *)tap{
    NSInteger count = tap.numberOfTapsRequired;
    if (self.tapClick) {
        self.tapClick(self, count);
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
