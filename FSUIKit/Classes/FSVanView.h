//
//  FSVanView.h
//  Expand
//
//  Created by Fudongdong on 2017/8/4.
//  Copyright © 2017年 china. All rights reserved.
//

#import "FSLabel.h"

typedef NS_ENUM(NSInteger, FSLoadingStatus) {
    FSLoadingStatusDefault,        /*  无状态     */
    FSLoadingStatusLoading,        /*  加载中     */
    FSLoadingStatusNoData,         /*  无数据     */
    FSLoadingStatusNoNet,          /*  网络失败   */
};

typedef NS_ENUM(NSInteger, FSClickMode) {
    FSClickModeRefresh,            /*  刷新       */
    FSClickModeOther,              /*  其他       */
};

@interface FSVanView : UIView

@property (nonatomic,strong) FSLabel            *label;
@property (nonatomic,assign) FSLoadingStatus    status;

- (void)dismiss;

@end

@interface FSRoundVanView : UIView

@property (nonatomic,assign) NSArray *circleArray;

- (void)start;
- (void)stop;

@end


