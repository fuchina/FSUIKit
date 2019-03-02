//
//  FSCloundView.m
//  FBRetainCycleDetector
//
//  Created by FudonFuchina on 2019/3/2.
//

#import "FSCloundView.h"

@implementation FSCloundView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.alpha = .6;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.alpha = 1;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.alpha = 1;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    CGFloat offsetX = currentPoint.x - prePoint.x;
    CGFloat offsetY = currentPoint.y - prePoint.y;
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    
    if (self.frame.origin.x < _margin.left) {
        self.frame = CGRectMake(_margin.left, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    }
    if (self.frame.origin.x > (self.superview.frame.size.width - _margin.right - self.bounds.size.width)) {
        self.frame = CGRectMake(self.superview.frame.size.width - _margin.right - self.bounds.size.width, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    }
    if (self.frame.origin.y < _margin.top) {
        self.frame = CGRectMake(self.frame.origin.x, _margin.top, self.bounds.size.width, self.bounds.size.height);
    }
    if (self.frame.origin.y > (self.superview.frame.size.height - _margin.bottom - self.bounds.size.height)) {
        self.frame = CGRectMake(self.frame.origin.x, self.superview.frame.size.height - _margin.bottom - self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
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
