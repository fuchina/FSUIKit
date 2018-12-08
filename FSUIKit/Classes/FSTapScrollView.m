//
//  FSTapScrollView.m
//  ShareEconomy
//
//  Created by fudon on 16/6/8.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSTapScrollView.h"

@implementation FSTapScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionInTapScrollView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapActionInTapScrollView{
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
