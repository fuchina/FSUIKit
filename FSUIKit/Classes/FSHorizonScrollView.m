////
////  FSHorizonScrollView.m
////  FSUIKit
////
////  Created by 扶冬冬 on 2023/7/11.
////
//
//#import "FSHorizonScrollView.h"
//
//@implementation FSHorizonScrollView
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ([self panBack:gestureRecognizer]) {
//        return NO;
//    }
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
//    if ([self panBack:gestureRecognizer]) {
//        return YES;
//    }
//    return NO;
//}
//
//- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
//    if (gestureRecognizer == self.panGestureRecognizer) {
//        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//        UIGestureRecognizerState state = gestureRecognizer.state;
//        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
//            CGPoint point = [pan translationInView:self];
//            CGPoint location = [gestureRecognizer locationInView:self];
//            if (point.x > 0 && location.x < 90 && self.contentOffset.x <= 0) {
//                return YES;
//            }
//        }
//    }
//    return NO;
//}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end
