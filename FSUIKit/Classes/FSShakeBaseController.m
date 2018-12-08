//
//  FSShakeBaseController.m
//  myhome
//
//  Created by FudonFuchina on 2017/12/8.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSShakeBaseController.h"

@interface FSShakeBaseController ()

@end

@implementation FSShakeBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self shakeEndActionFromShakeBase];
    }
    return;
}

- (void)shakeEndActionFromShakeBase{
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
