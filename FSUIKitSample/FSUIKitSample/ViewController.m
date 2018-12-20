//
//  ViewController.m
//  FSUIKitSample
//
//  Created by fudongdong on 2018/12/20.
//  Copyright © 2018年 fudongdong. All rights reserved.
//

#import "ViewController.h"
#import "FSUIKit.h"
#import "FSImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = UIColor.redColor;
    button.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 50);
    [button setTitle:@"TEST" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)button{
    UIImage *image = [FSImage imageFromColor:UIColor.redColor size:CGSizeMake(64, 64)];
    NSData *data = UIImagePNGRepresentation(image);
    BOOL result = [data writeToFile:@"/Users/fudongdong/Desktop/aimage/a.png" atomically:YES];
    if (result) {
        NSLog(@"写入成功");
    }
}

@end
