//
//  FSBaseController.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSNavigationController.h"
#import "FSTapScrollView.h"
#import "FSVanView.h"
#import "FSViewManager.h"
#import "UIViewExt.h"
#import "FSToast.h"
#import <FuSoft.h>

#define FS_iPhone_X     [FSBaseController isIPhoneX]

typedef void(^GZSAdvancedBlock)(void);
@interface FSBaseController : UIViewController

/*
    这个方法的作用会把整个App的状态栏都改变。
    另一种方法：@property(nonatomic, readonly) UIStatusBarStyle preferredStatusBarStyle NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED; // Defaults to UIStatusBarStyleDefault
 如果UIViewController 不在导航控制器中，这个方法才有效；如果在导航控制器中，需要在导航控制器中调用这个方法，UIViewController中调用这个方法    self.navigationController.navigationBar.barStyle = UIBarStyleBlack来改变。

 */
@property (nonatomic,assign) BOOL               letStatusBarWhite;  // 把整个App都变了
@property (nonatomic,strong) UIColor            *backTintColor;     // 设置导航栏返回按钮的颜色

@property (nonatomic,strong) FSTapScrollView    *scrollView;
@property (nonatomic,copy)   NSString           *backTitle;
@property (nonatomic,strong) UITableView        *baseTableView;

@property (nonatomic,strong) FSVanView          *vanView;

//@property (nonatomic,copy) void (^popBlock)(FSBaseController *bVC);
@property (nonatomic,copy) void (^popParamBlock)(FSBaseController *bVC,id object);

- (void)addKeyboardNotificationWithBaseOn:(CGFloat)baseOn;
- (void)addKeyboardNotificationWithAdvancedBlock:(GZSAdvancedBlock)advancedBlock;

- (void)showWaitView:(BOOL)show;

+ (BOOL)isIPhoneX;

@end
