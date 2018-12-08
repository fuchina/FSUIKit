//
//  FSLabel.m
//  Expand
//
//  Created by Fudongdong on 2017/8/4.
//  Copyright © 2017年 china. All rights reserved.
//

#import "FSLabel.h"

@implementation FSLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0;
    }
    return self;
}

- (void)setText:(NSString *)text{
    [super setText:text];
    
    CGRect frame = self.frame;
    [self sizeToFit];
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.frame.size.height);
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setText:self.text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
