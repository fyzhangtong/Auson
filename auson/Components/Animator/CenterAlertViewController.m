//
//  CenterAlertViewController.m

//
//  Created by zhangtong on 2020/6/16.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "CenterAlertViewController.h"
#import <pop/POP.h>
#import "AppDelegate.h"

@implementation CenterAlertDismissAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toVC.view.userInteractionEnabled = YES;

    __block UIView *dimmingView;
    [transitionContext.containerView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (view.layer.opacity < 1.f) {
            dimmingView = view;
            *stop = YES;
        }
    }];
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [transitionContext completeTransition:YES];
}
@end

@implementation CenterAlertPresentingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;

    ///添加蒙层
    UIView *dimmingView = [[UIView alloc] initWithFrame:fromView.bounds];
    dimmingView.backgroundColor = [UIColor blackColor];
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
    ///设置toViewController的center
    toViewController.view.center = CGPointMake(transitionContext.containerView.center.x, transitionContext.containerView.center.y);

    ///添加蒙层
    [transitionContext.containerView addSubview:dimmingView];
    ///添加toViewController的view
    [transitionContext.containerView addSubview:toViewController.view];

    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.6);
    POPBasicAnimation *opacityAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation1.toValue = @(1);
    opacityAnimation1.fromValue = @(0.4);
    [opacityAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    [toViewController.view.layer pop_addAnimation:opacityAnimation1 forKey:@"opacityAnimation1"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

@end

@interface CenterAlertViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL appDelegateAllowRotation;

@end

@implementation CenterAlertViewController

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
    return [CenterAlertPresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [CenterAlertDismissAnimator new];
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
