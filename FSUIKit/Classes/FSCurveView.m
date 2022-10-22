//
//  FSCurveView.m
//  FSUIKit
//
//  Created by Dongdong Fu on 2022/10/22.
//

#import "FSCurveView.h"

@implementation FSCurveModel

@end

@implementation FSBezierPath

@end

@implementation FSCurveView {
    NSMutableArray      *_paths;
}

- (void)show {
    [self setNeedsDisplay];
}

- (FSBezierPath *)findPathWithIndex:(NSInteger)index {
    for (FSBezierPath *p in _paths) {
        if (p.index == index) {
            return p;
        }
    }
    return nil;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGColorRef roundColor = UIColor.lightGrayColor.CGColor;
    _paths = [NSMutableArray new];
    for (int x = 0; x < _lines.count; x ++) {
        FSCurveModel *m = _lines[x];
        FSBezierPath *path = [FSBezierPath bezierPath];
        path.index = x;
        NSValue *startPoint = m.points.firstObject;
        CGPoint startP = [startPoint CGPointValue];
        [path moveToPoint:startP];
        for (int i = 0; i < m.points.count; i ++) {
            NSValue *value = m.points[i];
            CGPoint p = [value CGPointValue];
            [path addLineToPoint:p];
            
            // 添加一个小球
            CALayer *layr = [CALayer layer];
            layr.frame = CGRectMake(p.x - 3, p.y - 3, 6, 6);
            layr.cornerRadius = 3;
            layr.backgroundColor = roundColor;
            [self.layer addSublayer:layr];
        }
        
        path.lineWidth = m.lineWidth;
        path.lineCapStyle = m.lineCapStyle;
        path.lineJoinStyle = m.lineJoinStyle;
        if (m.lineColor) {
            [m.lineColor set];
        }
        [path stroke];
        
        [_paths addObject:path];
    }
}

@end
