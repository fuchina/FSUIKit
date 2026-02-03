////
////  FSImageView.m
////  FSUIKit
////
////  Created by FudonFuchina on 2021/7/31.
////
//
//#import "FSImageView.h"
//
//@implementation FSImageView {
//    UIView      *_back_tap_view;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self fs_add_tap_event_in_base_view];
//    }
//    return self;
//}
//
//- (void)fs_add_tap_event_in_base_view {
//    _back_tap_view = [[UIView alloc] initWithFrame:self.bounds];
//    [self addSubview:_back_tap_view];
//    
//    UITapGestureRecognizer *one = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_fs_tap_click_event:)];
//    [_back_tap_view addGestureRecognizer:one];
//}
//
//- (void)_fs_tap_click_event:(UITapGestureRecognizer *)tap {
//    if (self.click) {
//        self.click(self);
//    }
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _back_tap_view.frame = self.bounds;
//}
//
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end
