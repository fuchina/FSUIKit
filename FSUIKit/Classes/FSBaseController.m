//
//  FSBaseController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseController.h"
#import "FSLeftItem.h"
#import "FSViewManager.h"
#import "FuSoft.h"
#import "FSTrack.h"

typedef void(^FSBaseAlertBlock)(UIAlertView *bAlertView,NSInteger bIndex);

@interface FSBaseController ()

@property (nonatomic,strong) UIView                     *baseLoadingView;
@property (nonatomic,strong) UIView                     *baseBackView;
@property (nonatomic,assign) NSTimeInterval             baseTimeDelay;
@property (nonatomic,assign) CGFloat                    baseOnPropertyBase;

@property (nonatomic,copy) GZSAdvancedBlock             advancedBlock;

@end

@implementation FSBaseController{
    BOOL        _onceBase;
    UIView      *_backTapView;
}

- (void)dealloc{
#if TARGET_IPHONE_SIMULATOR
    NSString *title = [[NSString alloc] initWithFormat:@"%@ dealloc",NSStringFromClass(self.class)];
    //    [FSToast show:title];
    NSLog(@"%@",title);
#else
#endif
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_onceBase) {
        _onceBase = YES;
        
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"金吒" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [FSTrack event:NSStringFromClass([self class])];
    self.view.backgroundColor = RGBCOLOR(245, 245, 245, 1);

    _backTapView = [FSViewManager viewWithFrame:self.view.bounds backColor:nil];
    [self.view insertSubview:_backTapView atIndex:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionBase)];
    [_backTapView addGestureRecognizer:tap];

//    if (self.navigationController.viewControllers.count > 1) {
//        UIViewController *frontVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
//
//        NSString *title = nil;
//        if (frontVC.title && (frontVC.title.length <= 5)) {
//            title = frontVC.title;
//        }else{
//            title = @"返回";
//        }
//
//        UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
//        frontVC.navigationItem.backBarButtonItem = backBBI;
//    }
    
    
//    self.navigationController.navigationBar.barTintColor = FSAPPCOLOR;
    /*
    if (self.navigationController.viewControllers.count > 1) {
        WEAKSELF(this);
        FSLeftItem *item = [[FSLeftItem alloc] initWithFrame:CGRectMake(0, 20, WIDTHFC / 4, 44)];
        item.tapBlock = ^ (){
            [this popActionBase];
        };
        BOOL isWhite = self.navigationController.navigationBar.barStyle == UIBarStyleBlack;
        if (isWhite) {            
            item.color = [UIColor whiteColor];
        }else{
            item.color = FSAPPCOLOR;
        }
        item.mode = FSItemTitleModeNOChar;
        
        UIViewController *frontVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        if (frontVC.title && (frontVC.title.length <= 5)) {
            item.textLabel.text = frontVC.title;
        }else{
            item.textLabel.text = @"返回";
        }
        
        UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithCustomView:item];
        self.navigationItem.leftBarButtonItem = leftBBI;
    }
     */
}

- (void)setBackTintColor:(UIColor *)backTintColor{
    if (_backTintColor != backTintColor) {
        _backTintColor = backTintColor;
        
        FSLeftItem *backButton = (FSLeftItem *)self.navigationItem.leftBarButtonItem.customView;
        backButton.color = backTintColor;
    }
}

- (void)setBackTitle:(NSString *)backTitle{
    if (_backTitle != backTitle) {
        _backTitle = backTitle;
        
        FSLeftItem *backButton = (FSLeftItem *)self.navigationItem.leftBarButtonItem.customView;
        backButton.textLabel.text = backTitle;
    }
}

- (void)tapActionBase{
    [self.view endEditing:YES];
}

- (FSTapScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[FSTapScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64)];
        _scrollView.contentSize = CGSizeMake(WIDTHFC, HEIGHTFC);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delaysContentTouches = NO;
        if (_backTapView) {
            [self.view insertSubview:_scrollView aboveSubview:_backTapView];
        }else{
            [self.view addSubview:_scrollView];
        }
    }
    return _scrollView;
}

//- (void)popActionBase{
//    if (self.popBlock) {
//        self.popBlock(self);
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

- (void)setLetStatusBarWhite:(BOOL)letStatusBarWhite{
    _letStatusBarWhite = letStatusBarWhite;
    if (letStatusBarWhite) {
        if (IOSGE(7)) {
            [self.navigationController.navigationBar setTranslucent:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        } else {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:130/255.0 blue:200/255.0 alpha:1];
        }
    }else{
        if (IOSGE(7)) {
            [self.navigationController.navigationBar setTranslucent:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        } else {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:130/255.0 blue:200/255.0 alpha:1];
        }
    }
}

- (void)showWaitView:(BOOL)show{
    if (show) {
    // 隐藏其他比如暂无数据、无网络等的提示视图
//        [self hiddenErrorViews];
    }
    
    CGFloat blackWidth = MIN(WIDTHFC, HEIGHTFC) / 5;
    CGRect blackRect = CGRectMake(WIDTHFC / 2 - blackWidth / 2, HEIGHTFC / 2 - WIDTHFC / 10 - 50, blackWidth, blackWidth);
    
    if (show) {
        if (_baseLoadingView) {
            [self.view bringSubviewToFront:_baseLoadingView];
            _baseLoadingView.frame = [UIScreen mainScreen].bounds;
            _baseBackView.frame = blackRect;
        }else{
            _baseLoadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self.view insertSubview:_baseLoadingView atIndex:self.view.subviews.count];
            
            _baseBackView = [[UIView alloc] initWithFrame:blackRect];
            _baseBackView.alpha = .7;
            _baseBackView.backgroundColor = [UIColor blackColor];
            _baseBackView.layer.cornerRadius = 6;
            [_baseLoadingView addSubview:_baseBackView];
            
            UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            active.frame = CGRectMake(0, 0, _baseBackView.width, _baseBackView.height);
            [active startAnimating];
            [_baseBackView addSubview:active];
        }
    }else{
        _baseLoadingView.right = - WIDTHFC;
    }
}

- (void)addKeyboardNotificationWithAdvancedBlock:(GZSAdvancedBlock)advancedBlock{
    _advancedBlock = advancedBlock;
    [self addKeyboardNotificationWithBaseOn:0];
}

- (void)addKeyboardNotificationWithBaseOn:(CGFloat)baseOn{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybaordActionInPropertyBase:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybaordActionInPropertyBase:) name:UIKeyboardWillHideNotification object:nil];
    self.baseOnPropertyBase = baseOn;
}

- (void)keybaordActionInPropertyBase:(NSNotification *)notification{
    if (_advancedBlock) {
        _advancedBlock();
    }
    
    if (_scrollView) {
        self.scrollView.contentSize = [FSKit keyboardNotificationScroll:notification baseOn:self.baseOnPropertyBase];
    }else if (_baseTableView){
        self.baseTableView.contentSize = [FSKit keyboardNotificationScroll:notification baseOn:self.baseOnPropertyBase];
    }
}

- (FSVanView *)vanView{
    if (!_vanView) {
        _vanView = [[FSVanView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_vanView];
    }
    return _vanView;
}

+ (BOOL)isIPhoneX{
    static BOOL isPhoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isPhoneX = ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size):NO);
    });
    return isPhoneX;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
