////
////  FSSwitchCell.m
////  Expand
////
////  Created by Fudongdong on 2017/11/29.
////  Copyright © 2017年 china. All rights reserved.
////
//
//#import "FSSwitchCell.h"
//
//@implementation FSSwitchCell {
//    UISwitch    *_s;
//}
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self switchDesignViews];
//    }
//    return self;
//}
//
//- (void)switchDesignViews {
//    self.userInteractionEnabled = YES;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    _s = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 71, 12, 51, 31)];
//    [_s addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    [self.contentView addSubview:_s];
//}
//
//- (void)switchAction:(UISwitch *)s {
//    _on = s.isOn;
//    if (self.block) {
//        self.block(s);
//    }
//}
//
//- (void)setOn:(NSInteger)on {
//    _s.on = on;
//}
//
//@end
