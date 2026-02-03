////
////  FSTapCell.m
////  ShareEconomy
////
////  Created by FudonFuchina on 16/7/21.
////  Copyright © 2016年 FudonFuchina. All rights reserved.
////
//
//#import "FSTapCell.h"
//
//@implementation FSTapCell {
//    UIView      *_backTapView;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _backTapView = [[UIView alloc] initWithFrame: self.bounds];
//        [self addSubview:_backTapView];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapAction)];
//        [_backTapView addGestureRecognizer:tap];
//    }
//    return self;
//}
//
//- (void)tapAction {
//    self->_backTapView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
//    self->_backTapView.alpha = 0.2;
//    [UIView animateWithDuration:.25 animations:^{
//        self->_backTapView.alpha = 0.1;
//    } completion:^(BOOL finished) {
//        self->_backTapView.alpha = 1;
//        self->_backTapView.backgroundColor = UIColor.clearColor;
//    }];
//    
//    if (_click) {
//        _click(self);
//    }
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _backTapView.frame = self.bounds;
//    _textLabel.frame = CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height);
//    _detailTextLabel.frame = CGRectMake(90, 0, self.frame.size.width - 105, self.frame.size.height);
//}
//
//- (UILabel *)textLabel {
//    if (!_textLabel) {
//        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height)];
//        _textLabel.textColor = UIColor.blackColor;
//        [self addSubview:_textLabel];
//    }
//    return _textLabel;
//}
//
//- (UILabel *)detailTextLabel {
//    if (!_detailTextLabel) {
//        _detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, self.frame.size.width - 105, self.frame.size.height)];
//        _detailTextLabel.textAlignment = NSTextAlignmentRight;
//        _detailTextLabel.textColor = UIColor.grayColor;
//        _detailTextLabel.font = [UIFont systemFontOfSize:14];
//        [self addSubview:_detailTextLabel];
//    }
//    return _detailTextLabel;
//}
//
//@end
