////
////  FSImageLabelView.m
////  ShareEconomy
////
////  Created by FudonFuchina on 16/5/14.
////  Copyright © 2016年 FudonFuchina. All rights reserved.
////
//
//#import "FSImageLabelView.h"
//#import "FSImage.h"
//#import "FSUIKit.h"
//
//@implementation FSImageLabelView2
//
////- (instancetype)initWithFrame:(CGRect)frame {
////    self = [super initWithFrame:frame];
////    if (self) {
////        [self imageLabelDesignViews];
////    }
////    return self;
////}
////
////- (void)imageLabelDesignViews{
////    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(imageLabelTapAction)];
////    [self addGestureRecognizer: tap];
////    
////    _imageView = [[UIImageView alloc] init];
////    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
////    _imageView.contentMode = UIViewContentModeScaleAspectFill;
////    [self addSubview: _imageView];
////    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"H:[_imageView(35)]" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(_imageView)]];
////    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:[_imageView(35)]" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(_imageView)]];
////    [self addConstraint: [NSLayoutConstraint constraintWithItem: _imageView attribute:NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeCenterX multiplier: 1 constant: 0]];
////    [self addConstraint: [NSLayoutConstraint constraintWithItem: _imageView attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeCenterY multiplier: 1 constant: -10]];
////
////    _label = [[UILabel alloc] init];
////    _label.translatesAutoresizingMaskIntoConstraints = NO;
////    _label.font = [UIFont systemFontOfSize: 13];
////    _label.textAlignment = NSTextAlignmentCenter;
////    [self addSubview: _label];
////    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[_label]-0-|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(_label)]];
////    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:[_label(30)]" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(_label)]];
////    [self addConstraint:[NSLayoutConstraint constraintWithItem: _label attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeBottom multiplier: 1 constant: 0]];
////}
////
////- (void)imageLabelTapAction {
////    if (_block) {
////        _block(self);
////    }
////}
////
////+ (FSImageLabelView *)imageLabelViewWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text{
////    FSImageLabelView *view = [[FSImageLabelView alloc] initWithFrame:frame];
////    view.imageView.contentMode = UIViewContentModeScaleAspectFill;
////    view.label.text = text;
////    
////    __block UIImage *image = [UIImage imageNamed:imageName];
////    dispatch_async(dispatch_get_global_queue(0, 0), ^{
////        BOOL decode = NO;
////        if (image && decode) {
////            image = [FSImage decodedImageWithImage:image];
//////            CGSize size = image.size;
//////            image = [FSImage compressImage:image width:70];
//////            CGSize reSize = image.size;
////        
////#if DEBUG
//////            NSLog(@"size：(%f,%f)-(%f,%f)",size.width,size.height,reSize.width,reSize.height);
////#endif
////        }
////        
////#if DEBUG
////        static NSMutableString *list = nil;
////        if (!list) {
////            list = NSMutableString.new;
////        }
////#endif
////        
////        dispatch_async(dispatch_get_main_queue(), ^{
////            if ([image isKindOfClass:UIImage.class]) {
////                view.imageView.image = image;
////            }
////#if DEBUG
////            else{
////                NSString *msg = [[NSString alloc] initWithFormat:@"图片为空（表明不受图片压缩的影响），text为：%@",text];
////                [list appendFormat:@"\n%@",msg];
////            }
////            
////            if (view == nil || view.imageView == nil) {
//////                [FSToast show:@"view为空"];
////                [list appendFormat:@"view为空"];
////            }
////            
////            if (list.length) {
////                static BOOL showed = NO;
////                if (showed == NO) {
////                    showed = YES;
////                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//////                        [FSUIKit showAlertWithMessageOnCustomWindow:list];
////                    });
////                }
////            }
////#endif
////            
////        });
////    });
////    return view;
////}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end
