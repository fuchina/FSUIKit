//
//  FSTitleContentView.h
//  myhome
//
//  Created by FudonFuchina on 2018/3/26.
//  Copyright © 2018年 fuhope. All rights reserved.
//

#import "FSView.h"

@interface FSTitleContentView : FSView

@property (nonatomic, strong) UILabel    *label;
@property (nonatomic, strong) UILabel    *contentLabel;

@property (nonatomic, copy) void (^click)(FSTitleContentView *titleContentView);

@end
