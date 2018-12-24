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
#import "FSModalView.h"

@interface ViewController ()

@end

@implementation ViewController{
    UIImageView     *_imageView;
    FSModalView     *_modelView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = UIColor.redColor;
    button.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 50);
    [button setTitle:@"TEST" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _imageView = [[UIImageView alloc] init];
    [self.view addSubview:_imageView];
}

- (void)buttonClick:(UIButton *)button{
    [self drawClick];
}

- (void)drawClick{
    UIColor *mainColor = [UIColor colorWithRed:0x00/255.0 green:0x97/255.0 blue:0xff/255.0 alpha:1];
//    UIColor *marginColor = [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:0.8];
    UIColor *marginColor = [UIColor colorWithRed:0x00/255.0 green:0x97/255.0 blue:0xff/255.0 alpha:0.8];

    UIImage *image = [FSImage imageWithSize:CGSizeMake(64, 64) backgroundColor:UIColor.clearColor mainColor:mainColor marginColor:marginColor];
    _imageView.image = image;
    _imageView.frame = CGRectMake(self.view.bounds.size.width / 2 - image.size.width / 2, self.view.bounds.size.height / 2 - image.size.height / 2, image.size.width, image.size.height);
}

- (void)modalAnimatiton{
    FSModalView *view = [[FSModalView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColor.redColor;
    [self.view addSubview:view];
    [view pushAnimated:YES completion:^(FSModalView * _Nonnull modalView) {
        
    }];
    _modelView = view;
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 50);
    b.backgroundColor = UIColor.whiteColor;
    [view addSubview:b];
    [b addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bClick{
    [_modelView popAnimated:YES completion:^(FSModalView * _Nonnull modalView) {
        
    }];
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
}

@end
