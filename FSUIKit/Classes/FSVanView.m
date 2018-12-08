//
//  FSVanView.m
//  Expand
//
//  Created by Fudongdong on 2017/8/4.
//  Copyright © 2017年 china. All rights reserved.
//

#import "FSVanView.h"
#import "FSLabel.h"

@implementation FSVanView{
    @private
    FSRoundVanView      *_roundView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self vanDesignViews];
    }
    return self;
}

- (void)vanDesignViews{
    self.backgroundColor = [UIColor whiteColor];
    CGSize size = self.frame.size;
    
    CGFloat a = 1;
    CGFloat b = 1;
    _roundView = [[FSRoundVanView alloc] initWithFrame:CGRectMake(size.width / 2 - 12, size.height / 2 - 12, 24, 24)];
    [_roundView start];
    UIColor *grayColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0];
    _roundView.circleArray =@[
                        @{
                            @"a":[UIColor colorWithRed:18/255.0 green:152/255.0 blue:233/255.0 alpha:1],
                            @"b":@(a/(a+b))
                            },
                        @{
                            @"a":grayColor,
                            @"b":@(b/(a+b))
                            },
                        ];
    [self addSubview:_roundView];
}

- (void)setStatus:(FSLoadingStatus)status{
    _status = status;
    switch (status) {
        case FSLoadingStatusLoading:{
            _label.hidden = YES;
            [_roundView start];
        }break;
        case FSLoadingStatusNoData:{
            [_roundView stop];
            _roundView.hidden = YES;
            _label.hidden = NO;
        }break;
        default:
            break;
    }
}

- (void)dismiss{
    self.hidden = YES;
    [self removeFromSuperview];
}

- (FSLabel *)label{
    if (!_label) {
        CGSize size = self.frame.size;
        _label = [[FSLabel alloc] initWithFrame:CGRectMake(15, (size.height - 60) / 2, size.width - 30, 60)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface FSRoundVanView ()

@property (nonatomic,strong) CADisplayLink  *link;
@property (nonatomic,assign) NSInteger      count;

@end

@implementation FSRoundVanView

- (void)setCircleArray:(NSArray *)circleArray{
    _circleArray = circleArray;
    
    __block float a = 0;
    [self.circleArray enumerateObjectsUsingBlock:^(NSDictionary *obj,NSUInteger idx, BOOL *_Nonnull stop) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame =CGRectMake(0,0, self.bounds.size.width,self.bounds.size.height);
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        
        shapeLayer.lineWidth = 2;
        shapeLayer.strokeColor = [obj[@"a"]CGColor];
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0, self.bounds.size.width,self.bounds.size.height)];
        shapeLayer.path = circlePath.CGPath;
        shapeLayer.strokeStart = a;
        shapeLayer.strokeEnd = [obj[@"b"] doubleValue] + a;
        a = shapeLayer.strokeEnd;
        [self.layer addSublayer:shapeLayer];
    }];
}

- (void)start{
    self.link.paused = NO;
}

- (void)stop{
    self.link.paused = YES;
}

- (void)execAnimation{
    CGFloat shares = 25.0f;
    CGFloat delta = 2 * M_PI / shares;
    self.transform = CGAffineTransformMakeRotation(_count * delta);
    _count ++;
    if (_count > shares * 1000) {
        _count = 0;
        self.transform = CGAffineTransformMakeRotation(0);
    }
}

- (CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(execAnimation)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

@end
