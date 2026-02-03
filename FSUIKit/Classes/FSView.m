////
////  FSView.m
////  FSBaseController
////
////  Created by FudonFuchina on 2019/5/12.
////
//
//#import "FSView.h"
//
//@implementation FSView
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _tapBackView.frame = self.bounds;
//    _gradientLayer.frame = self.bounds;
//}
//
//- (CAGradientLayer *)gradientLayer {
//    if (!_gradientLayer) {
//        _gradientLayer = [CAGradientLayer layer];
//        _gradientLayer.frame = self.bounds;
//        [self.layer insertSublayer: _gradientLayer atIndex: 0];
//    }
//    return _gradientLayer;
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
//    _tapBackView = [[UIView alloc] initWithFrame: self.bounds];
//    [self addSubview: _tapBackView];
//    
//    UITapGestureRecognizer *one = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(_fs_tap_click_event:)];
//    [_tapBackView addGestureRecognizer: one];
//}
//
//- (void)_fs_tap_click_event:(UITapGestureRecognizer *)tap {
//    if (self.click) {
//        self.click(self);
//    }
//    
//    if (self.clickLocation) {
//        CGPoint p = [tap locationInView: _tapBackView];
//        self.clickLocation(self, p);
//    }
//}
//
//+ (FSView *)viewWithTheTag:(NSInteger)tag inView:(nonnull UIView *)inView {
//    for (FSView *sub in inView.subviews) {
//        if ([sub isKindOfClass:FSView.class]) {
//            if (sub.theTag == tag) {
//                return sub;
//            }
//        }
//    }
//    return nil;
//}
//
//- (void)dismiss {
//    [UIView animateWithDuration:.25 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//}
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
