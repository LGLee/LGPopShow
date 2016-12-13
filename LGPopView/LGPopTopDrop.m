//
//  LGPopTopDrop.m
//  LGPopView
//
//  Created by lingo on 2016/12/9.
//  Copyright © 2016年 lingo. All rights reserved.
//

#import "LGPopTopDrop.h"

@implementation LGPopTopDrop
- (void)showView:(UIView *)popView bgView:(UIView *)bgView{
    CGRect popFrame = popView.frame;
    CGRect startF = popView.frame;
    startF.origin.y = - startF.size.height;
    popView.frame = startF;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        popView.frame = popFrame;
    } completion:^(BOOL finished) {
    }];
}

- (void)dimissView:(UIView *)popView bgView:(UIView *)bgView completed:(void (^)(void))completed{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect endF = popView.frame;
        endF.origin.y = - popView.frame.size.height;
        popView.frame = endF;
    } completion:^(BOOL finished) {
        completed();
    }];
}

@end
