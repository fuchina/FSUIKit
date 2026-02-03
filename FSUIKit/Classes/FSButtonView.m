////
////  FSButtonView.m
////  FBRetainCycleDetector
////
////  Created by FudonFuchina on 2020/2/23.
////
//
//#import "FSButtonView.h"
//
//@implementation FSButtonView {
//    UIView      *_backView;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self buttonDesignViews];
//    }
//    return self;
//}
//
//- (void)buttonDesignViews {
//    _backView = [[UIView alloc] initWithFrame:self.bounds];
//    [self addSubview:_backView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//    [_backView addGestureRecognizer:tap];
//}
//
//- (void)tapClick {
//    if (self.tap) {
//        self.tap(self);
//    }
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _button.frame = CGRectMake(5, self.frame.size.height / 2 - 18, self.frame.size.width - 10, 36);
//}
//
//- (UIButton *)button {
//    if (!_button) {
//        _button = [UIButton buttonWithType:UIButtonTypeSystem];
//        _button.frame = CGRectMake(5, self.frame.size.height / 2 - 18, self.frame.size.width - 10, 36);
//        _button.layer.cornerRadius = 18;
//        [_button addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_button];
//    }
//    return _button;
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
