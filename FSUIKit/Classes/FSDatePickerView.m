//
//  FSDatePickerView.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/7.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSDatePickerView.h"

@interface FSDatePickerView ()

@property (nonatomic,strong) UIView         *mainView;
@property (nonatomic,strong) UIDatePicker   *datePicker;

@end

@implementation FSDatePickerView{
    NSDate  *_date;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self dpDesignViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date{
    self = [super initWithFrame:frame];
    if (self) {
        _date = date;
        [self dpDesignViews];
    }
    return self;
}

- (void)dpDesignViews{
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = .28;
    [self addSubview:backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [backView addGestureRecognizer:tap];

    CGSize size = self.bounds.size;
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, 240)];
    _mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.bounds.size.width, 200)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    _datePicker.minimumDate = [[NSDate date] dateByAddingTimeInterval:- 100 * 365 * 24 * 3600];
    _datePicker.maximumDate = [[NSDate date] dateByAddingTimeInterval:100 * 365 * 24 * 3600];
//    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_mainView addSubview:_datePicker];
    
    if (![_date isKindOfClass:NSDate.class]) {
        _date = [NSDate date];
    }
    _datePicker.date = _date;
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mainView.bounds.size.width, 40)];
    selectView.backgroundColor = [UIColor colorWithRed:18/255.0 green:152/255.0 blue:233/255.0 alpha:1.0f];
    [_mainView addSubview:selectView];
    
    for (int x = 0; x < 2; x ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(x * (selectView.bounds.size.width - 60), 0, 60, 40);
        [button setTitle:x?NSLocalizedString(@"Confirm", nil):NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = x;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:button];
    }
    
    NSDateComponents *comp = [FSDatePickerView componentForDate:[NSDate date]];
    NSString *title = [[NSString alloc] initWithFormat:@"今天是%@月%@日",@(comp.month),@(comp.day)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, size.width - 120, selectView.bounds.size.height)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = title;
    [selectView addSubview:timeLabel];
    
    [self showAction:YES];
}

- (void)tap{
    if (self.cancel) {
        self.cancel();
    }
    [self showAction:NO];
}

- (void)buttonAction:(UIButton *)button{
    if (button.tag) {
        if (_block) {
//            NSCalendar *calendar = [NSCalendar currentCalendar];
//            NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:_datePicker.date];
//            components.hour = 0;components.minute = 0;components.second = 0;
//            NSDate *date = [calendar dateFromComponents:components];
            _block(_datePicker.date);
        }
    }
    [self showAction:NO];
}

- (void)showAction:(BOOL)show{
    if (show) {
        [UIView animateWithDuration:.3 animations:^{
            self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, self.frame.size.height - 240, self.mainView.bounds.size.width, self.mainView.bounds.size.height);
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, self.frame.size.height, self.mainView.bounds.size.width, self.mainView.bounds.size.height);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

+ (NSDateComponents *)componentForDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    return components;
}

//- (void)datePickerValueChanged:(UIDatePicker *)datePicker
//{
//    if (_block) {
//        _block(datePicker.date);
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
