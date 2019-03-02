//
//  UIView+Tap.h
//  FBRetainCycleDetector
//
//  Created by FudonFuchina on 2019/3/2.
//

#import <UIKit/UIKit.h>

@interface UIView (Tap)

/*
 * 注册单击和双击手势
 */
- (void)_fs_tapClick:(void(^)(UIView *view,NSInteger taps))click;

@end
