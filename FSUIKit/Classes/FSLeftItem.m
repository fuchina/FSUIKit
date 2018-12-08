//
//  FSLeftItem.m
//  ShareEconomy
//
//  Created by fudon on 2016/9/6.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSLeftItem.h"

@implementation FSBackItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat red = 31 / 255.0;
    CGFloat green = 143 / 255.0;
    CGFloat blue = 228.0 / 255.0;
    CGFloat alpha = 1.0;
    if ([_color isKindOfClass:UIColor.class]) {
        [_color getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 2);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);  //线的颜色
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.bounds.size.width * .9, self.bounds.size.width * .1);  //起点坐标
    CGContextAddLineToPoint(context, 1, self.frame.size.height / 2);
    CGContextAddLineToPoint(context, self.frame.size.width * .9, self.frame.size.height * .9);   //终点坐标
    
    CGContextStrokePath(context);
}

@end

@interface FSLeftItem ()

@property (nonatomic,strong) FSBackItemView *backImage;

@end

@implementation FSLeftItem

- (void)setColor:(UIColor *)color
{
    if (_color != color) {
        _color = color;
        
        _backImage.color = color;
        [_backImage setNeedsDisplay];
        _textLabel.textColor = color;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self leftDesignViews];
    }
    return self;
}

- (void)leftDesignViews
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionItem)];
    [self addGestureRecognizer:tap];
    
    _backImage = [[FSBackItemView alloc] initWithFrame:CGRectMake(-5 + 5 * (_mode == FSItemTitleModeNOChar), 12, 11, 20)];
    [self addSubview:_backImage];
    
    if (_mode == FSItemTitleModeDefault) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backImage.right + 3, 7, self.bounds.size.width - 14, 30)];
        _textLabel.font = [UIFont systemFontOfSize:15];
        //    _textLabel.textColor = RGBCOLOR(31, 143, 228, 1);
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1.0f];
        [self addSubview:_textLabel];
    }
}

- (void)setMode:(FSItemTitleMode)mode
{
    if (_mode != mode) {
        _mode = mode;
        
        _backImage.frame = CGRectMake(-5 + 5 * (_mode == FSItemTitleModeNOChar), 12, 11, 20);
        if (mode == FSItemTitleModeDefault) {
            _textLabel.frame = CGRectMake(_backImage.right + 3, 7, self.bounds.size.width - 14, 30);
        }else{
            if (_textLabel) {
                [_textLabel removeFromSuperview];
                _textLabel = nil;
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.alpha = .28;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    if (!CGRectContainsPoint(self.frame, currentPoint)) {
        [UIView animateWithDuration:.3 animations:^{
            self.alpha = 1;
        }];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)tapActionItem
{
    if (self.tapBlock) {
        self.tapBlock();
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
