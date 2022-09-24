//
//  FSTableView.m
//  FSUIKit
//
//  Created by Dongdong Fu on 2022/9/23.
//

#import "FSTableView.h"

@implementation FSTableView

- (void)layoutSubviews {
    [super layoutSubviews];
 
    if (self.layoutedSubviews) {
        self.layoutedSubviews(self);
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
