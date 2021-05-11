//
//  BottomAlertViewController.m
//  FanBookClub
//
//  Created by zhangtong on 2020/5/14.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "BottomAlertViewController.h"
#import <pop/POP.h>

@implementation BottomAlertDismissAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toVC.view.userInteractionEnabled = YES;

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    __block UIView *dimmingView;
    [transitionContext.containerView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (view.layer.opacity < 1.f) {
            dimmingView = view;
            *stop = YES;
        }
    }];
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);

    CGFloat fromHeight = fromVC.view.frame.size.height;
    CGFloat contextHeight = transitionContext.containerView.bounds.size.height;
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(contextHeight+fromHeight/2);
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    [fromVC.view.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}
@end

@interface BottomAlertPresentingAnimator ()
@property (nonatomic, assign) BOOL addGreyMask;
@end
@implementation BottomAlertPresentingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;

    ///添加蒙层
    UIView *dimmingView = [[UIView alloc] initWithFrame:fromView.bounds];
    
    dimmingView.backgroundColor = self.addGreyMask ? [UIColor blackColor] : [UIColor clearColor];
    dimmingView.layer.opacity = 0.0;
    dimmingView.userInteractionEnabled = YES;

    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ///设置toViewController的View的frame
    if ([toViewController respondsToSelector:@selector(setViewFrame)]) {
        [toViewController performSelector:@selector(setViewFrame)];
    }
    ///添加点击蒙层返回手势
    if ([toViewController respondsToSelector:@selector(dismissViewController)]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:toViewController action:@selector(dismissViewController)];
        [dimmingView addGestureRecognizer:tap];
    }
    CGFloat toHeight = toViewController.view.frame.size.height;
    CGFloat toWidth = toViewController.view.frame.size.width;
    CGFloat contextHeight = transitionContext.containerView.bounds.size.height;
    ///设置toViewController的center
    toViewController.view.center = CGPointMake(toWidth/2, contextHeight + toHeight/2);

    ///添加蒙层
    [transitionContext.containerView addSubview:dimmingView];
    ///添加toViewController的view
    [transitionContext.containerView addSubview:toViewController.view];

    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(contextHeight-toHeight/2);
    positionAnimation.springBounciness = 0;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 0;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.2)];

    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.5);

    [toViewController.view.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toViewController.view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

@end

@interface BottomAlertViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL appDelegateAllowRotation;

@end

@implementation BottomAlertViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    BottomAlertPresentingAnimator *animator = [BottomAlertPresentingAnimator new];
    animator.addGreyMask = [self addGreyMask];
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [BottomAlertDismissAnimator new];
}
/// 是否有黑色背景
- (BOOL)addGreyMask
{
    return YES;
}
- (void)setViewFrame
{
    self.view.frame = CGRectMake(0, 0, GTSCREENW, GTSCREENH);
}
- (void)dismissViewController
{}

- (void)dealloc
{
    NSLog(@"***********dealloc:%@",[self class]);
}

@end
