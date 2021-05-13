//
//  CenterAlertViewController.h

//
//  Created by zhangtong on 2020/6/16.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTCenterAlertDismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@end

@interface ZTCenterAlertPresentingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface ZTCenterAlertViewController : UIViewController

/// 显示的大小
- (void)setViewFrame;
- (void)dismissViewController;

@end

NS_ASSUME_NONNULL_END
