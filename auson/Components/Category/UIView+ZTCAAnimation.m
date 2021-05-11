//
//  UIView+ZTCAAnimation.m
//  FanBookClub
//
//  Created by zhangtong on 2020/7/20.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "UIView+ZTCAAnimation.h"

#define angleValue(angle) ((angle) * M_PI / 180.0)//角度数值转换宏

@implementation UIView (ZTCAAnimation)

- (void)addLikeAnimatrion {
    
    [self.layer removeAnimationForKey:@"scaleAnimation"];
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    //缩放变换
    scaleAnimation.values   = @[@0.f, @1.1f,@0.9f,@1.05f,@0.95,@1];
    scaleAnimation.keyTimes = @[@0.f, @0.5f,@0.7f,@0.8f,@0.9f,@1.f];
    //缩放时长
    scaleAnimation.duration = 1;
    //重复次数
//    scaleAnimation.repeatCount = 1;
    //kCAMediaTimingFunctionEaseIn(淡入)
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    scaleAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)addOverTurnAnimationWithHalfTimeBlock:(dispatch_block_t)halfTimeBlock
{
    
    [self.layer removeAnimationForKey:@"Rate3DAnimation"];
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DMakeRotation(angleValue(180), 0, 0.5, 0); //1.57表示所转角度的弧度 = 90Pi/180 = 90*3.14/180
    NSValue *value = [NSValue valueWithCATransform3D:transform];
    [theAnimation setToValue:value];
    [theAnimation setAutoreverses:NO];  //原路返回的动画一遍
    [theAnimation setDuration:0.4];
    [theAnimation setRepeatCount:1];
    [self.layer addAnimation:theAnimation forKey:@"Rate3DAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),halfTimeBlock);
}

@end
