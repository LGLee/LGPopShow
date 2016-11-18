//
//  UIViewController+LGPopViewController.m
//  LGPopView
//
//  Created by lingo on 16/11/17.
//  Copyright © 2016年 lingo. All rights reserved.
//

#import "UIViewController+LGPopViewController.h"
#import <objc/runtime.h>

//分类
@interface UIViewController(LGPopViewControllerPrivate)
/** 背景 */
@property (nonatomic, strong) UIView *popBgView;
/** 弹出框 */
@property (nonatomic, strong) UIView *popView;
/** 容器 */
@property (nonatomic, strong) UIView *popContentView;

@end

static const void *KPopBgViewKey =&KPopBgViewKey;
static const void *KPopViewKey = &KPopViewKey;
static const void *KpopContentViewKey = &KpopContentViewKey;
@implementation UIViewController (LGPopViewController)

- (void)showPopView:(UIView *)popView bgView:(UIView *)bgView inView:(UIView *)view animation:(id<LGPopAnimation>)animation dismissed:(void (^)(void))dismissed{
   //保存传过来的
//    self.popBgView = nil;
//    self.popBgView = bgView;
    self.popView = nil;
    self.popView = bgView;

    //判断弹出位置和容器加载
    UIView *sourceView = [self adjustSourceView:view];
    UIView *popContentView = [[UIView alloc] initWithFrame:sourceView.bounds];
    self.popContentView = nil;
    self.popContentView = popContentView;
    popContentView.backgroundColor = [UIColor clearColor];
    [sourceView addSubview:popContentView];
    
    if (bgView==nil) {//如果bgView没有--创建一个bgview
        self.popBgView = [self defaultBgView];
    }else{
        self.popBgView = bgView;
        if (!(bgView.frame.size.height&&bgView.frame.size.width)) {//对bgView的一些判断，如果没有给，那么就等于当前容器的bounds
            self.popBgView.frame = popContentView.bounds;
        }
    }
    [popContentView addSubview:self.popBgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissedView:)];
    [self.popBgView addGestureRecognizer:tap];
    [popContentView addSubview:popView];
    
    if (!(popView.frame.size.height&&popView.frame.size.width)) {//如果没有宽高，给个默认的宽高
        CGRect currRect = popView.frame;
        currRect.size = CGSizeMake(100, 100);
        popView.frame = currRect;
    }
    
    if (!(popView.frame.origin.x&&popView.frame.origin.y)) {//没有原点,设置默认从中心点开始弹出
        popView.center = popContentView.center;
    }
    
    if (animation) {//加载动画
        [animation showView:popView bgView:bgView];
    }
}


//默认背景
- (UIView *)defaultBgView{
    UIView *defaultBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    defaultBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    return defaultBgView;
}
//默认弹出框的大小
- (void)defaultPopView{

}




- (UIView *)adjustSourceView:(UIView *)sourceView{
    if (sourceView==nil) {
        return [UIApplication sharedApplication].keyWindow;
    }else{
        UIViewController *recentView = self;
        while (recentView.parentViewController != nil) {
            recentView = recentView.parentViewController;
        }
        return recentView.view;
    }
}

- (void)dismissedView:(UIGestureRecognizer *)ges{
    [self dismissPopViewWithAnimation:nil completion:nil];
}

- (void)dismissPopViewWithAnimation:(id<LGPopAnimation>)animation completion:(void (^)(void))completion{
    if (animation) {//如果需要消失的动画
        
    }else{
        
    }
    [self.popContentView removeFromSuperview];
}

#pragma mark - runTime实现分类的setting和getting
- (UIView *)popBgView{
    return objc_getAssociatedObject(self, KPopBgViewKey);
}
- (void)setPopBgView:(UIView *)popBgView{
    objc_setAssociatedObject(self, KPopBgViewKey, popBgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)popView{
    return objc_getAssociatedObject(self, KPopViewKey);
}
- (void)setPopView:(UIView *)popView{
    objc_setAssociatedObject(self, KPopViewKey,popView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)popContentView{
    return objc_getAssociatedObject(self, KpopContentViewKey);
}
-(void)setPopContentView:(UIView *)popContentView{
    objc_setAssociatedObject(self, KpopContentViewKey, popContentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
