//
//  UIView+Tap.m
//  FBRetainCycleDetector
//
//  Created by FudonFuchina on 2019/3/2.
//

#import "UIView+Tap.h"
#import <objc/runtime.h>

@implementation UIView (Tap)

static char *_did_key = "category_taps_did_key";
static char *_block_key = "category_taps_block_key";
- (void)_fs_tapClick:(void(^)(UIView *view,NSInteger taps))click{
    BOOL did = [objc_getAssociatedObject(self, _did_key) boolValue];
    if (did || click == nil) {
        return;
    }
    UITapGestureRecognizer *one = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_fs_tap_click_event:)];
    one.numberOfTapsRequired = 1;
    [self addGestureRecognizer:one];
    UITapGestureRecognizer *two = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_fs_tap_click_event:)];
    two.numberOfTapsRequired = 2;
    [self addGestureRecognizer:two];
    [one requireGestureRecognizerToFail:two];
    
    objc_setAssociatedObject(self, _block_key, click, OBJC_ASSOCIATION_COPY);
}

- (void)_fs_tap_click_event:(UITapGestureRecognizer *)tap{
    NSInteger count = tap.numberOfTapsRequired;
    void (^click)(UIView *view,NSInteger taps) = objc_getAssociatedObject(self, _block_key);
    if (click) {
        click(self,count);
    }
}

@end
