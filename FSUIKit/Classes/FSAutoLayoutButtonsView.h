//
//  FSAutoLayoutButtonsView.h
//  myhome
//
//  Created by FudonFuchina on 2018/8/18.
//  Copyright © 2018年 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSAutoLayoutButtonsView : UIView

@property (nonatomic,strong) NSArray<NSString *>   *texts;
@property (nonatomic,copy) void (^click)(FSAutoLayoutButtonsView *v,NSInteger index);
@property (nonatomic,copy) void (^configButton)(UIButton *button);

- (CGFloat)selfHeight;

@end
