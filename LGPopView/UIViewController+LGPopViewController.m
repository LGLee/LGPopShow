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
/** 消失回调的block */
@property (nonatomic , copy) void(^popDismissedCallBackBlock)(void);
/** popView栈 -- 实际是popContent栈  用于存储当前弹出的控件 */
@property (nonatomic ,strong) NSMutableArray *popViewArray;
/** animation栈 -- 存储动画*/
@property (nonatomic ,strong) NSMutableArray *animationStack;
/** popView栈 --  */
@property (nonatomic ,strong) NSMutableArray *popViewStack;
/** 回调栈 */
@property (nonatomic ,strong) NSMutableArray *callBackStack;

@end

static const void *KPopBgViewKey =&KPopBgViewKey;
static const void *KPopViewKey = &KPopViewKey;
static const void *KpopContentViewKey = &KpopContentViewKey;
static const void *KpopDismissedCallBackBlock = &KpopDismissedCallBackBlock;
static const void *KpopAnimation = &KpopAnimation;
static const void *KpopViewArray = &KpopViewArray;
static const void *KanimationStack = &KanimationStack;
static const void *KpopViewStack = &KpopViewStack;
static const void *KcallBackStack = &KcallBackStack;
@implementation UIViewController (LGPopViewController)
#pragma mark - 呈现
- (void)showPopView:(UIView *)popView bgView:(UIView *)bgView inView:(UIView *)view animation:(id<LGPopAnimation>)animation dismissed:(void (^)(void))dismissed{
    if ([self.popContentView.subviews containsObject:popView]) return;//如果已经弹出,就不要再弹出了
    if (self.popViewArray==nil) {
        self.popViewArray = [NSMutableArray array];
    }
    
    if (self.animationStack == nil) {
        self.animationStack = [NSMutableArray array];
    }
    
    if (self.popViewStack == nil) {
        self.popViewStack = [NSMutableArray array];
    }
    
    if (self.callBackStack == nil) {
        self.callBackStack = [NSMutableArray array];
    }

    //判断弹出位置和容器加载
    UIView *sourceView = [self adjustSourceView:view];
    UIView *popContentView = [[UIView alloc] initWithFrame:sourceView.bounds];
    self.popContentView = popContentView;
    popContentView.backgroundColor = [UIColor clearColor];
    [sourceView addSubview:popContentView];
    [self.popViewArray addObject:popContentView];
    if (bgView==nil) {//如果bgView没有--创建一个bgview
        bgView = [self defaultBgView];
    }else{
        if (!(bgView.frame.size.height&&bgView.frame.size.width)) {//对bgView的一些判断，默认等于当前容器的bounds
            bgView.frame =popContentView.bounds;
        }
    }
    self.popBgView = bgView;//保存传过来的bgView
    [popContentView addSubview:self.popBgView];
    //点击背景的时候要移除
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissedView:)];
    [self.popBgView addGestureRecognizer:tap];
    if (!(popView.frame.size.height&&popView.frame.size.width)) {//如果没有宽高，给个默认的宽高
        CGRect currRect = popView.frame;
        currRect.size = CGSizeMake(100, 100);
        popView.frame = currRect;
    }
    if (!(popView.frame.origin.x&&popView.frame.origin.y)) {//没有原点,设置默认从中心点开始弹出
        popView.center = popContentView.center;
    }
    self.popView = popView;
    [self.popViewStack addObject:popView];
    [popContentView addSubview:self.popView];
    self.popAnimation = animation;
    [self.animationStack addObject:animation];
    
    if (animation) {//加载动画
        [animation showView:popView bgView:bgView];
    }
    [self setPopDismissedCallBackBlock:dismissed];
    if (dismissed == nil) {
        dismissed = ^{NSLog(@"没有处理这个回调哟~(可忽略)");};
    }
    [self.callBackStack addObject:dismissed];
}

//默认背景
- (UIView *)defaultBgView{
    UIView *defaultBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    defaultBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    return defaultBgView;
}
/**
 判断应该将此pop加载在哪
 @param sourceView 源view
 @return 判断好的源view
 */
- (UIView *)adjustSourceView:(UIView *)sourceView{
    if (sourceView) {
        return sourceView;
    }else{
        return [UIApplication sharedApplication].keyWindow;
    }
}

#pragma mark - 消失
- (void)dismissedView:(UIGestureRecognizer *)ges{
   // [self dismissPopViewWithAnimation:self.popAnimation  completion:nil];
    [self dismissPopView];
}
- (void)dismissPopView{
    id<LGPopAnimation> animation = self.animationStack.lastObject;
    [self dismissPopViewWithAnimation:animation completion:nil];
    [self.animationStack removeLastObject];
}

- (void)dismissPopViewWithAnimation:(id<LGPopAnimation>)animation{
    [self dismissPopViewWithAnimation:animation completion:nil];
}

- (void)dismissPopViewWithAnimation:(id<LGPopAnimation>)animation completion:(void (^)(void))completion{
     self.popView = self.popViewStack.lastObject;
    if (animation) {//如果需要消失的动画
        [animation dimissView:self.popView bgView:self.popContentView completed:^{
            UIView *lastView = self.popViewArray.lastObject;
            [lastView removeFromSuperview];
            [self.popViewArray removeLastObject];
            self.popContentView = self.popViewArray.lastObject;
        //[self.popContentView removeFromSuperview];
            id dissmissed = [self.callBackStack lastObject];
           // id dissmissed = [self popDismissedCallBackBlock];
            if (dissmissed) {
                ((void(^)(void))dissmissed)();
                [self.callBackStack removeLastObject];
                //[self setPopDismissedCallBackBlock:nil];
            }
        }];
    }else{//如果不需要消失动画
        UIView *lastView = self.popViewArray.lastObject;
        [lastView removeFromSuperview];
        [self.popViewArray removeLastObject];
        self.popContentView = self.popViewArray.lastObject;
       // [self.popContentView removeFromSuperview];
        //id dissmissed = [self popDismissedCallBackBlock];
        id dissmissed = [self.callBackStack lastObject];
        if (dissmissed) {
            ((void(^)(void))dissmissed)();
           // [self setPopDismissedCallBackBlock:nil];
            [self.callBackStack removeLastObject];
        }
    }
    [self.popViewStack removeLastObject];
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

- (void)setPopDismissedCallBackBlock:(void (^)(void))popDismissedCallBackBlock{
    objc_setAssociatedObject(self, KpopDismissedCallBackBlock, popDismissedCallBackBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))popDismissedCallBackBlock{
    return objc_getAssociatedObject(self, KpopDismissedCallBackBlock);
}

- (void)setPopAnimation:(id<LGPopAnimation>)popAnimation{
    objc_setAssociatedObject(self, KpopAnimation, popAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id<LGPopAnimation>)popAnimation{
    return objc_getAssociatedObject(self, KpopAnimation);
}

- (void)setPopViewArray:(NSMutableArray *)popViewArray{
    objc_setAssociatedObject(self, KpopViewArray, popViewArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)popViewArray{
    return objc_getAssociatedObject(self, KpopViewArray);
}

- (void)setAnimationStack:(NSMutableArray *)animationStack{
    objc_setAssociatedObject(self, KanimationStack, animationStack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)animationStack{
    return objc_getAssociatedObject(self, KanimationStack);
}

- (void)setPopViewStack:(NSMutableArray *)popViewStack{
    objc_setAssociatedObject(self, KpopViewStack, popViewStack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)popViewStack{
    return objc_getAssociatedObject(self, KpopViewStack);
}

- (void)setCallBackStack:(NSMutableArray *)callBackStack{
    objc_setAssociatedObject(self, KcallBackStack, callBackStack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)callBackStack{
    return objc_getAssociatedObject(self, KcallBackStack);
}
@end
