//
//  BottomAlertViewController.h

//
//  Created by zhangtong on 2020/5/14.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomAlertDismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@end

@interface BottomAlertPresentingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface BottomAlertViewController : UIViewController

/// 是否有黑色背景，default yes
- (BOOL)addGreyMask;
/// 显示的大小
- (void)setViewFrame;
- (void)dismissViewController;

@end

NS_ASSUME_NONNULL_END
