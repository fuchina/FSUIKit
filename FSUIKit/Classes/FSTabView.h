//
//  FSTabView.h
//  FSUIKit
//
//  Created by FudonFuchina on 2021/8/7.
//

#import "FSView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSTabView : FSView

@property (nonatomic, strong) UILabel       *label;

// 是否选中，由外界记录
@property (nonatomic, assign) BOOL          selected;

@end

NS_ASSUME_NONNULL_END
