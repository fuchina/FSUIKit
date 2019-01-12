//
//  FSReuseTableView.h
//  myhome
//
//  Created by FudonFuchina on 2018/4/5.
//  Copyright © 2018年 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSReuseTableView : UIView

@property (nonatomic,strong) UITableView    *tableView;

@property (nonatomic,copy) void (^refresh_header)(void);
@property (nonatomic,copy) void (^refresh_footer)(void);

@property (nonatomic,copy) NSInteger (^numberOfSections)(UITableView *tableView);
@property (nonatomic,copy) NSInteger (^numberOfRowsInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) UITableViewCell* (^cellForRowAtIndexPath)(UITableView *tableView,NSIndexPath *indexPath);
@property (nonatomic,copy) void (^willDisplayCell)(UITableViewCell *cell,NSIndexPath *indexPath);
@property (nonatomic,copy) CGFloat (^heightForRowAtIndexPath)(UITableView *tableView,NSIndexPath *indexPath);

@property (nonatomic,copy) CGFloat (^heightForHeaderInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) CGFloat (^heightForFooterInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) void (^didSelectRowAtIndexPath)(UITableView *tableView,NSIndexPath *indexPath);

- (void)endRefresh;
- (void)deleteRefresh;

@end
