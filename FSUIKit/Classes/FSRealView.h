//
//  FSRealView.h
//  FSUIKit
//
//  Created by Dongdong Fu on 2024/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSRealGridView : UIView

@property (nonatomic, assign)   CGFloat       lineWidth;
@property (nonatomic, strong)   UIColor       *lineColor;

@property (nonatomic, assign)   UIRectEdge    hideCorner;

@property (nonatomic, readonly) UILabel       *label;

- (void)designViews;

- (void)setLabelDefaultStyle;

@end

@interface FSRealView : UIView

- (void)designViews:(NSInteger)grids grid:(void (^)(FSRealGridView *gridView))grid;

@end

NS_ASSUME_NONNULL_END
