//
//  LGPopSpring.m
//  LGPopView
//
//  Created by lingo on 16/11/18.
//  Copyright © 2016年 lingo. All rights reserved.
//

#import "LGPopSpring.h"

@implementation LGPopSpring

- (void)showView:(UIView *)popView bgView:(UIView *)bgView{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [popView.layer addAnimation:popAnimation forKey:nil];
}

- (void)dimissView:(UIView *)popView bgView:(UIView *)bgView completed:(void (^)(void))completed{
    
}

@end
