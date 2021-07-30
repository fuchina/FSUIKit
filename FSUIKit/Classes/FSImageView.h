//
//  FSImageView.h
//  FSUIKit
//
//  Created by FudonFuchina on 2021/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSImageView : UIImageView

@property (nonatomic, copy) void (^click)(FSImageView *view);

@end

NS_ASSUME_NONNULL_END
