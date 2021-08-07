//
//  FSTabsView.h
//  FBRetainCycleDetector
//
//  Created by FudonFuchina on 2020/1/12.
//

#import "FSView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSTabsView : FSView

@property (nonatomic,strong) NSArray<NSString *>    *list;

@property (nonatomic, copy) void (^clickIndex)(FSTabsView *view, NSInteger index);

@end

NS_ASSUME_NONNULL_END
