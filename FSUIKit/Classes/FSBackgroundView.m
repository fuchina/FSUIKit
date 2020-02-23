//
//  FSBackgroundView.m
//  FBRetainCycleDetector
//
//  Created by FudonFuchina on 2020/2/23.
//

#import "FSBackgroundView.h"

@implementation FSBackgroundView

- (void)dealloc {
#if DEBUG
    NSLog(@"FSBackgroundView dealloc");
#endif
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self backDesignViews];
    }
    return self;
}

- (void)backDesignViews {
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = UIColor.blackColor;
    backView.alpha = .28;
    [self addSubview:backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [backView addGestureRecognizer:tap];
}

- (void)showView:(UIView *)view completion:(void(^)(FSBackgroundView *bbView,BOOL finished))completion {
    view.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, view.frame.size.width, view.frame.size.height);
    
    if (view) {
        [UIView animateWithDuration:.25 animations:^{
            view.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - view.frame.size.height, view.frame.size.width, view.frame.size.height);
        } completion:^(BOOL finished) {
            if (completion) {
                completion(self,finished);
            }
        }];
    }
}

- (void)dismissView:(UIView *)view completion:(void(^)(FSBackgroundView *bbView,BOOL finished))completion {
    if (view) {
        [UIView animateWithDuration:.25 animations:^{
            view.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, view.frame.size.width, view.frame.size.height);
        } completion:^(BOOL finished) {
            if (completion) {
                completion(self,finished);
            }
        }];
    }
}

- (void)dismiss {
    if (self.tap) {
        self.tap(self);
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
