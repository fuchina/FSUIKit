//
//  FSHook.m
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/5/7.
//

#import "FSHook.h"
#import <objc/runtime.h>

@implementation FSHook

void _fs_hook_swizzle_class(Class class, SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

BOOL _fs_hook_JRSwizzle_class(Class cls,SEL origSel_,SEL altSel_){
    Method origMethod = class_getInstanceMethod(cls, origSel_);
    if (!origMethod) {
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(cls, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(cls,
                    origSel_,
                    class_getMethodImplementation(cls, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(cls,
                    altSel_,
                    class_getMethodImplementation(cls, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(cls, origSel_), class_getInstanceMethod(cls, altSel_));
    return YES;
}

@end
