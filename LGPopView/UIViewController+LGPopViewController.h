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

/**
 出场动画

 @param popView 呈现的view
 @param bgView 背景
 */
- (void)showView:(UIView *)popView bgView:(UIView *)bgView;


/**
 消失动画

 @param popView 呈现的view
 @param bgView 背景
 @param completed 动画完成回调
 */
- (void)dimissView:(UIView *)popView bgView:(UIView *)bgView completed:(void(^)(void))completed;
@end


@interface UIViewController (LGPopViewController)
/** 动画协议 */
@property (nonatomic ,retain,readonly) id<LGPopAnimation> popAnimation;

/**
 展现你的popView

 @param popView 你的popView
 @param bgView popView的背景
 @param view 你需要把这一切加载在什么地方:传nil默认为keyWindow ...
 @param animation 动画
 @param dismissed 完成这一切后的回调block
 */
- (void)showPopView:(UIView *)popView bgView:(UIView *)bgView inView:(UIView *)view animation:(id<LGPopAnimation>)animation dismissed:(void(^)(void))dismissed;

/**
 消失你的popView
 */
- (void)dismissPopView;

/**
 消失你的popView

 @param animation 动画
 */
- (void)dismissPopViewWithAnimation:(id<LGPopAnimation>)animation;
@end
