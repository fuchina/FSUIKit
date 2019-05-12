//
//  FSView.h
//  FSBaseController
//
//  Created by FudonFuchina on 2019/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSView : UIView

// 单击和双击手势事件
@property (nonatomic,copy) void (^tapClick)(FSView *view,NSInteger tapCount);

@end

NS_ASSUME_NONNULL_END
