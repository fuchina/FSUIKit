//
//  FSTapScrollView.h
//  ShareEconomy
//
//  Created by fudon on 16/6/8.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSTapScrollView : UIScrollView

@property (nonatomic,copy) void (^click)(FSTapScrollView *view);

@end
