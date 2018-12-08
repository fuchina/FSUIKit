//
//  FSTrack.m
//  FSTrackSample
//
//  Created by fudongdong on 2018/11/30.
//  Copyright © 2018年 fudongdong. All rights reserved.
//

#import "FSTrack.h"
#import <UMMobClick/MobClick.h>

@implementation FSTrack

+ (void)configUMeng:(NSString *)appKey channelId:(NSString *)channelId crashReportEnabled:(BOOL)crashReportEnabled appVersion:(NSString *)appVersion PUID:(NSString *)puid{
#ifdef __OPTIMIZE__
#if TARGET_IPHONE_SIMULATOR
#else
    UMConfigInstance.appKey = appKey;
    UMConfigInstance.channelId = channelId;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    [MobClick setCrashReportEnabled:crashReportEnabled];
    [MobClick setAppVersion:appVersion];
    [MobClick profileSignInWithPUID:puid];
#endif
#endif
}

// Release模式下才统计
+ (void)event:(NSString *)event{
#ifdef __OPTIMIZE__
#if TARGET_IPHONE_SIMULATOR
#else
    [MobClick event:event];
#endif
#endif
}

+ (void)pageStart:(NSString *)page{
#ifdef __OPTIMIZE__
#if TARGET_IPHONE_SIMULATOR
#else
    [MobClick beginLogPageView:page];
#endif
#endif
}

+ (void)pageEnd:(NSString *)page{
#ifdef __OPTIMIZE__
#if TARGET_IPHONE_SIMULATOR
#else
    [MobClick endLogPageView:page];
#endif
#endif
}

@end
