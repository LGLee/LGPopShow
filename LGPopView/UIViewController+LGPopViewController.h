//
//  UIViewController+LGPopViewController.h
//  LGPopView
//
//  Created by lingo on 16/11/17.
//  Copyright © 2016年 lingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGPopAnimation <NSObject>
@required
- (void)showView:(UIView *)popView bgView:(UIView *)bgView;

- (void)dimissView:(UIView *)popView bgView:(UIView *)bgView completed:(void(^)(void))completed;

@end


@interface UIViewController (LGPopViewController)

- (void)showPopView:(UIView *)popView bgView:(UIView *)bgView inView:(UIView *)view animation:(id<LGPopAnimation>)animation dismissed:(void(^)(void))dismissed;

- (void)dismissPopViewWithAnimation:(id<LGPopAnimation>)animation completion:(void(^)(void))completion;

@end
