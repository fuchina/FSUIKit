//
//  FSCurveView.h
//  FSUIKit
//
//  Created by Dongdong Fu on 2022/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSCurveModel : NSObject

/**
 *  (x,y)坐标点
 */
@property (nonatomic, strong) NSArray<NSNumber *>                       *points;

@property (nonatomic, strong) UIColor                                   *lineColor;
@property (nonatomic, assign) CGFloat                                   lineWidth;

@property (nonatomic, assign) CGLineCap                                 lineCapStyle;       // 终点处理，如 kCGLineCapRound
@property (nonatomic, assign) CGLineJoin                                lineJoinStyle;      // 线条拐角，如 kCGLineJoinRound

@end

@interface FSBezierPath : UIBezierPath

@property (nonatomic, strong) FSCurveModel                              *model;
@property (nonatomic, assign) NSInteger                                 index;

@end

@interface FSCurveView : UIView

@property (nonatomic, strong) NSArray<FSCurveModel *>                   *lines;

@property (nonatomic, strong, readonly) NSArray<FSBezierPath *>         *paths;

- (FSBezierPath *)findPathWithIndex:(NSInteger)index;

- (void)show;

@end

NS_ASSUME_NONNULL_END
