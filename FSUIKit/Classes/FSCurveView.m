////
////  FSCurveView.m
////  FSUIKit
////
////  Created by Dongdong Fu on 2022/10/22.
////
//
//#import "FSCurveView.h"
//#import "FSUIAdapter.h"
//
//@implementation FSCurveModel
//
//@end
//
//@implementation FSBezierPath
//
//@end
//
//@implementation FSCurveView {
//    NSMutableArray      *_paths;
//}
//
//- (void)show {
//    [self setNeedsDisplay];
//}
//
//- (FSBezierPath *)findPathWithIndex:(NSInteger)index {
//    for (FSBezierPath *p in _paths) {
//        if (p.index == index) {
//            return p;
//        }
//    }
//    return nil;
//}
//
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    CGColorRef roundColor = UIColor.lightGrayColor.CGColor;
//    CGColorRef backColor = UIColor.whiteColor.CGColor;
//    _paths = [NSMutableArray new];
//    CGFloat point_margin = 15 + (FSUIAdapter.sharedInstance.isIPad ? 15 : 0);
//    for (int x = 0; x < _lines.count; x ++) {
//        FSCurveModel *m = _lines[x];
//        FSBezierPath *path = [FSBezierPath bezierPath];
//        path.index = x;
//        NSValue *startPoint = m.points.firstObject;
//        CGPoint startP = [startPoint CGPointValue];
//        [path moveToPoint:startP];
//        BOOL addRound = m.points.count <= point_margin;
//        for (int i = 0; i < m.points.count; i ++) {
//            NSValue *value = m.points[i];
//            CGPoint p = [value CGPointValue];
//            [path addLineToPoint:p];
//            
//            // 添加一个小球
//            if (addRound) {
//                CGFloat y = p.y - 3;
//                if (y > 0) {
//                    CGFloat x = p.x - 3;
//                    if (isnan(x)) {
//                        continue;
//                    }
//                    CALayer *layr = [CALayer layer];
//                    layr.frame = CGRectMake(p.x - 3, y, 6, 6);
//                    layr.cornerRadius = 3;
//                    layr.backgroundColor = backColor;
//                    layr.borderColor = roundColor;
//                    layr.borderWidth = 1;
//                    [self.layer addSublayer:layr];
//                }
//            }
//        }
//        
//        path.lineWidth = m.lineWidth;
//        path.lineCapStyle = m.lineCapStyle;
//        path.lineJoinStyle = m.lineJoinStyle;
//        if (m.lineColor) {
//            [m.lineColor set];
//        }
//        [path stroke];
//        
//        [_paths addObject:path];
//    }
//}
//
//@end
