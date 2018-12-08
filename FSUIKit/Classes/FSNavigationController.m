//
//  FSNavigationController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSNavigationController.h"

@interface FSNavigationController ()
// <UIGestureRecognizerDelegate>

@end

@implementation FSNavigationController

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    // 解决自定义返回按钮导致左滑手势失效的问题
//    WEAKSELF(this);
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        this.interactivePopGestureRecognizer.delegate = this;
//    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.topViewController) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    
//    if (self.childViewControllers.count == 1) {
//    }
    
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
    
    [super pushViewController:viewController animated:animated];
}

//- (void)navigationController:(UINavigationController *)navigationController
//       didShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated
//{
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

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
