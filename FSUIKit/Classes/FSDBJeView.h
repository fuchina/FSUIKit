//
//  FSDBJeView.h
//  myhome
//
//  Created by Fudongdong on 2017/12/21.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLabelTextField.h"

@interface FSDBJeView : UIView

@property (nonatomic,strong) FSLabelTextField    *jeTF;
@property (nonatomic,strong) FSLabelTextField    *bzTF;

@property (nonatomic,copy) void (^tapEvent)(FSDBJeView *bView);

@end
