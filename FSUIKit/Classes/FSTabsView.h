//
//  FSTabsView.h
//  FBRetainCycleDetector
//
//  Created by FudonFuchina on 2020/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSTabsView : UIView

@property (nonatomic,strong) UITableView            *tableView;
@property (nonatomic,strong) NSArray<NSString *>    *list;


@end

NS_ASSUME_NONNULL_END
