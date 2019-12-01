//
//  FSPlaceholderView.h
//  FSApp
//
//  Created by FudonFuchina on 2019/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSPlaceholderView : UIView

@property (nonatomic,strong) UILabel    *label;
@property (nonatomic,copy) void(^click)(FSPlaceholderView *view);

@end

NS_ASSUME_NONNULL_END
