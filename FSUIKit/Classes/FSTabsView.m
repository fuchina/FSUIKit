//
//  FSTabsView.m
//  FBRetainCycleDetector
//
//  Created by FudonFuchina on 2020/1/12.
//

#import "FSTabsView.h"

@interface FSTabsView ()

@end

@implementation FSTabsView

- (void)setList:(NSArray<NSString *> *)list {
    _list = nil;
    if ([list isKindOfClass:NSArray.class] && list.count) {
        _list = list;
    }
    
    for (FSTabView *tab in self.subviews) {
        if ([tab isKindOfClass:FSTabView.class]) {
            tab.hidden = YES;
        }
    }
    
    if (!_list.count) {
        return;
    }
    
    CGFloat w = self.frame.size.width / list.count;
    for (int x = 0; x < list.count; x ++) {
        CGRect fr = CGRectMake(w * x, 0, w, self.frame.size.height);
        FSTabView *tab = [FSView viewWithTheTag:x inView:self];
        if (tab) {
            tab.hidden = NO;
            tab.frame = fr;
        } else {
            tab = [[FSTabView alloc] initWithFrame:fr];
            tab.theTag = x;
            [self addSubview:tab];
            __weak typeof(self)this = self;
            tab.click = ^(FSView * _Nonnull view) {
                if (this.clickIndex) {
                    this.clickIndex(this, view.theTag);
                }
            };
            tab.selectedState = ^(FSTabView * _Nonnull tabV, BOOL selected) {
                if (this.selectedState) {
                    this.selectedState(tabV, selected);
                }
            };
        }
        tab.label.text = list[x];
    }
}

- (void)selectedIndex:(NSInteger)index {
    for (FSTabView *tab in self.subviews) {
        if ([tab isKindOfClass:FSTabView.class]) {
            if (tab.theTag == index) {
                tab.selected = YES;
            } else {
                tab.selected = NO;
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
