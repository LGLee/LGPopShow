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
    self.popBgView = nil;
    self.popBgView = bgView;
    self.popView = nil;
    self.popView = bgView;

    UIView *sourceView = [self adjustSourceView:view];
    UIView *popContentView = [[UIView alloc] initWithFrame:sourceView.bounds];
    self.popContentView = nil;
    self.popContentView = popContentView;
    popContentView.backgroundColor = [UIColor clearColor];
    [sourceView addSubview:popContentView];
    
    if (bgView==nil) {//如果bgView没有
        
    }else{
        [popContentView addSubview:bgView];
        bgView.frame = self.view.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissedView:)];
        [self.popBgView addGestureRecognizer:tap];
    }
    [popContentView addSubview:popView];
    popView.frame = CGRectMake(40, 100, 100, 100);
    popView.center = bgView.center;
    if (animation) {
        [animation showView:popView bgView:bgView];
    }
}


//默认背景
- (void)defaultBgView{
    
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
