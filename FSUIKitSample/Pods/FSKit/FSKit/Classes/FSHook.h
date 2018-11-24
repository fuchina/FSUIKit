//
//  FSHook.h
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/5/7.
//

#import <Foundation/Foundation.h>

@interface FSHook : NSObject

extern void _fs_hook_swizzle_class(Class class, SEL originalSelector, SEL swizzledSelector);

@end
