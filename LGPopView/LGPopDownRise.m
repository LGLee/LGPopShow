//
//  LGPopDownRise.m
//  LGPopView
//
//  Created by lingo on 2016/12/9.
//  Copyright © 2016年 lingo. All rights reserved.
//

#import "LGPopDownRise.h"

@implementation LGPopDownRise

- (void)showView:(UIView *)popView bgView:(UIView *)bgView{
    CGRect popFrame = popView.frame;
    popView.frame = CGRectMake(0.01, - CGRectGetMaxY(bgView.frame), bgView.frame.size.width, 0.01);
    [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        popView.frame = popFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dimissView:(UIView *)popView bgView:(UIView *)bgView completed:(void (^)(void))completed{
    [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        popView.frame = CGRectMake(0.01, -CGRectGetMaxY(bgView.frame), bgView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        completed();
    }];
}
@end
