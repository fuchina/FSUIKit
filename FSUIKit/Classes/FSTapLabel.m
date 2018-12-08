//
//  FSTapLabel.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/3.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSTapLabel.h"

@implementation FSTapLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction
{
    if (_block) {
        _block(self);
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
