//
//  FSAVKit.h
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/23.
//

#import <Foundation/Foundation.h>

@interface FSAVKit : NSObject

// 播放音乐
+ (void)playSongs:(NSString *)songs type:(NSString *)fileType;

// 操作闪光灯
+ (void)flashLampShow:(BOOL)show;

@end
