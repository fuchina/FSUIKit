////
////  FSPlaceholderView.m
////  FSApp
////
////  Created by FudonFuchina on 2019/12/1.
////
//
//#import "FSPlaceholderView.h"
//
//@implementation FSPlaceholderView
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self placeholderDesignViews];
//    }
//    return self;
//}
//
//- (void)placeholderDesignViews {
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent)];
//    [self addGestureRecognizer:tap];
//}
//
//- (void)clickEvent {
//    if (self.click) {
//        self.click(self);
//    }
//}
//
//- (UILabel *)label {
//    if (!_label) {
//        _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.bounds.size.width - 15, self.bounds.size.height)];
//        _label.textColor = UIColor.lightGrayColor;
//        _label.font = [UIFont systemFontOfSize:15];
//        _label.numberOfLines = 0;
//        [self addSubview:_label];
//    }
//    return _label;
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
