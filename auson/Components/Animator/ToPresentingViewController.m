//
//  ToPresentingViewController.m

//
//  Created by zhangtong on 2019/11/29.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "ToPresentingViewController.h"
#import <pop/POP.h>

@implementation DismissingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
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

    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(-fromVC.view.layer.position.y);
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    [fromVC.view.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

@end

@implementation PresentingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;

    ///添加蒙层
    UIView *dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GTSCREENW, GTSCREENH)];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.layer.opacity = 0.0;
    dimmingView.userInteractionEnabled = YES;

    ToPresentingViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
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
    toViewController.view.center = CGPointMake(transitionContext.containerView.center.x, -transitionContext.containerView.center.y);

    ///添加蒙层
    [transitionContext.containerView addSubview:dimmingView];
    ///添加toViewController的view
    [transitionContext.containerView addSubview:toViewController.view];

    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(transitionContext.containerView.center.y);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];

    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];

    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.5);

    [toViewController.view.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toViewController.view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

@end

@interface ToPresentingViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL appDelegateAllowRotation;

@end

@implementation ToPresentingViewController

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
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
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
