//
//  FSRealView.m
//  FSUIKit
//
//  Created by Dongdong Fu on 2024/11/22.
//

#import "FSRealView.h"

@implementation FSRealGridView {
    UILabel             *_label;
    
//    CALayer             *_top_layer;
//    CALayer             *_left_layer;
//    CALayer             *_bottom_layer;
//    CALayer             *_right_layer;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _lineWidth = 1;
//        _lineColor = UIColor.blackColor;
//    }
//    return self;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label = [[UILabel alloc] initWithFrame: self.bounds];

//    if (_top_layer) {
//        _top_layer.frame = CGRectMake(0, 0, self.frame.size.width, _lineWidth);
//    }
//
//    if (_left_layer) {
//        _left_layer.frame = CGRectMake(0, 0, _lineWidth, self.frame.size.height);
//    }
//
//    if (_bottom_layer) {
//        _bottom_layer.frame = CGRectMake(0, self.frame.size.height - _lineWidth, self.frame.size.width, _lineWidth);
//    }
//
//    if (_right_layer) {
//        _right_layer.frame = CGRectMake(self.frame.size.width - _lineWidth, 0, _lineWidth, self.frame.size.height);
//    }
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame: self.bounds];
        [self addSubview: _label];
    }
    return _label;
}

- (void)setLabelDefaultStyle {
    _label.textAlignment = NSTextAlignmentCenter;
    _label.adjustsFontSizeToFitWidth = YES;
}

//- (void)designLayers {
//
//    if (_hideCorner & UIRectEdgeTop) {
//        [_top_layer removeFromSuperlayer];
//    } else {
//        _top_layer = CALayer.layer;
//        _top_layer.frame = CGRectMake(0, 0, self.frame.size.width, _lineWidth);
//        _top_layer.backgroundColor = _lineColor.CGColor;
//        [self.layer addSublayer: _top_layer];
//    }
//
//    if (_hideCorner & UIRectEdgeLeft) {
//        [_left_layer removeFromSuperlayer];
//    } else {
//        _left_layer = CALayer.layer;
//        _left_layer.frame = CGRectMake(0, 0, _lineWidth, self.frame.size.height);
//        _left_layer.backgroundColor = _lineColor.CGColor;
//        [self.layer addSublayer: _left_layer];
//    }
//
//    if (_hideCorner & UIRectEdgeBottom) {
//        [_bottom_layer removeFromSuperlayer];
//    } else {
//        _bottom_layer = CALayer.layer;
//        _bottom_layer.frame = CGRectMake(0, self.frame.size.height - _lineWidth, self.frame.size.width, _lineWidth);
//        _bottom_layer.backgroundColor = _lineColor.CGColor;
//        [self.layer addSublayer: _bottom_layer];
//    }
//
//    if (_hideCorner & UIRectEdgeRight) {
//        [_right_layer removeFromSuperlayer];
//    } else {
//        _right_layer = CALayer.layer;
//        _right_layer.frame = CGRectMake(self.frame.size.width - _lineWidth, 0, _lineWidth, self.frame.size.height);
//        _right_layer.backgroundColor = _lineColor.CGColor;
//        [self.layer addSublayer: _right_layer];
//    }
//}
//
//- (void)designViews {
//    [self designLayers];
//}

@end

@implementation FSRealView

//- (void)designViewsWithRows:(NSInteger)rows columns:(NSInteger)columns height:(CGFloat)height size:(void(^)(CGFloat *width, NSInteger row, NSInteger column))size grid:(void (^)(FSRealGridView *gridView, NSInteger row, NSInteger column))config {
//
//    CGFloat x = 0;
//    CGFloat y = 0;
//    for (int row = 0; row < rows; row ++) {
//        for (int column = 0; column < columns; column ++) {
//            CGFloat width = 0;
//            if (size) {
//                size(&width, row, column);
//            }
//
//            CGRect frame = CGRectMake(x, y, width, height);
//            FSRealGridView *grid = [[FSRealGridView alloc] initWithFrame: frame];
//            [self addSubview: grid];
//            config(grid, row, column);
//
//            x += width;
//        }
//
//        x = 0;
//        y += height;
//    }
//}

- (void)designViewsWithRows:(NSInteger)rows columns:(NSInteger)columns height:(CGFloat)height configRow:(void (^)(CALayer *line, CGFloat *y, CGFloat *width, CGFloat *height, NSInteger row))configRow configColumn:(void (^)(CALayer *line, CGFloat *x, CGFloat *height, CGFloat *width, NSInteger column))configColumn size:(void(^)(CGFloat *width, NSInteger row, NSInteger column))size grid:(void (^)(FSRealGridView *gridView, NSInteger row, NSInteger column))config {
    
    CGFloat row_top = 0;
    for (int row = 0; row < rows + 1; row ++) {
        
        if (configRow) {
            CALayer *row_line = CALayer.layer;
            [self.layer addSublayer: row_line];
            
            CGFloat row_line_y = 0;
            CGFloat row_line_width = 0;
            CGFloat row_line_height = 0;
            configRow(row_line, &row_line_y, &row_line_width, &row_line_height, row);
            row_line.frame = CGRectMake(0, row_top, row_line_width, row_line_height);
            
            row_top += row_line_y;
        }
    }
    
    CGFloat column_x = 0;
    for (int column = 0; column < columns + 1; column ++) {
        
        if (configColumn) {
            CALayer *column_line = CALayer.layer;
            [self.layer addSublayer: column_line];
            
            CGFloat column_line_x = 0;
            CGFloat column_line_height = 0;
            CGFloat column_line_width = 0;
            configColumn(column_line, &column_line_x, &column_line_height, &column_line_width, column);
            
            column_line.frame = CGRectMake(column_x, 0, column_line_width, column_line_height);
            
            column_x += column_line_x;
        }
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    for (int row = 0; row < rows; row ++) {
        for (int column = 0; column < columns; column ++) {
            CGFloat width = 0;
            if (size) {
                size(&width, row, column);
            }
            
            CGRect frame = CGRectMake(x, y, width, height);
            FSRealGridView *grid = [[FSRealGridView alloc] initWithFrame: frame];
            [self addSubview: grid];
            config(grid, row, column);
            
            x += width;
        }
        
        x = 0;
        y += height;
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
