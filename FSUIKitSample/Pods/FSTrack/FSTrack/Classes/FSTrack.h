//
//  FSTrack.h
//  FSTrackSample
//
//  Created by fudongdong on 2018/11/30.
//  Copyright © 2018年 fudongdong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSTrack : NSObject

// 友盟统计
+ (void)configUMeng:(NSString *)appKey
          channelId:(NSString *)channelId
 crashReportEnabled:(BOOL)crashReportEnabled
         appVersion:(NSString *)appVersion
               PUID:(NSString *)puid;

+ (void)event:(NSString *)event;
+ (void)pageStart:(NSString *)page;
+ (void)pageEnd:(NSString *)page;

@end

NS_ASSUME_NONNULL_END
