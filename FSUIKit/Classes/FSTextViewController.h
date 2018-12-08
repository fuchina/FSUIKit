//
//  FSTextViewController.h
//  myhome
//
//  Created by FudonFuchina on 2017/8/15.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSBaseController.h"

@interface FSTextViewController : FSBaseController

@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) void (^callback)(FSTextViewController *bVC,NSString *bText);

@end
