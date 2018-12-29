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
#import "UIView+ModalAnimation.h"

@interface ViewController ()

@end

@implementation ViewController{
    UIImageView     *_imageView;
    UIView          *_modelView;
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
    UIImage *image = [self monkeyKing];
    
    _imageView.image = image;
    _imageView.frame = CGRectMake(self.view.bounds.size.width / 2 - image.size.width / 2, self.view.bounds.size.height / 2 - image.size.height / 2, image.size.width, image.size.height);
}

- (UIImage *)monkeyKing{
    CGSize size = CGSizeMake(60, 60);
    UIColor *backgroundColor = [UIColor colorWithRed:0x1f/255.0 green:0xbc/255.0 blue:0xec/255.0 alpha:1];
    UIColor *mainColor = UIColor.whiteColor;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    Class _class_Color = UIColor.class;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([backgroundColor isKindOfClass:_class_Color]) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, size.width,size.height));
    }
    
    if ([mainColor isKindOfClass:_class_Color]) {
        CGContextSetFillColorWithColor(context, mainColor.CGColor);
        CGContextFillRect(context, CGRectMake(size.width * .2, .5 * size.height, size.width * .2,1));
        CGContextFillRect(context, CGRectMake(size.width * .6, .5 * size.height, size.width * .2,1));
    }
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)drawClick{
    UIColor *mainColor = [UIColor colorWithRed:0x00/255.0 green:0x97/255.0 blue:0xff/255.0 alpha:1];
//    UIColor *marginColor = [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:0.8];
    UIColor *marginColor = [UIColor colorWithRed:0x00/255.0 green:0x97/255.0 blue:0xff/255.0 alpha:0.8];

    UIImage *image = [FSImage imageWithSize:CGSizeMake(64, 64) backgroundColor:UIColor.clearColor mainColor:mainColor marginColor:marginColor];
    _imageView.image = image;
    _imageView.frame = CGRectMake(self.view.bounds.size.width / 2 - image.size.width / 2, self.view.bounds.size.height / 2 - image.size.height / 2, image.size.width, image.size.height);
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
}

@end
