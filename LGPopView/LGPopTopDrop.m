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
    popView.frame = CGRectMake(0.01, 0.01, bgView.frame.size.width, 0.01);
    [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        popView.frame = CGRectMake(0.01, 0.01, bgView.frame.size.width, 300);
    } completion:^(BOOL finished) {
    }];
}

- (void)dimissView:(UIView *)popView bgView:(UIView *)bgView completed:(void (^)(void))completed{
    [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        popView.frame = CGRectMake(0.01, 0.01, bgView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        completed();
    }];
}

@end
