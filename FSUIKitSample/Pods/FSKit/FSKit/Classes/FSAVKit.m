//
//  FSAVKit.m
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/23.
//

#import "FSAVKit.h"
#import <AVFoundation/AVFoundation.h>

@implementation FSAVKit

+ (void)playSongs:(NSString *)songs type:(NSString *)fileType{
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:songs ofType:fileType]], &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);// 播放震动
}

+ (void)flashLampShow:(BOOL)show{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {//判断是否有闪光灯
        if (show) {
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];
            [device unlockForConfiguration];
        }else{
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

@end
