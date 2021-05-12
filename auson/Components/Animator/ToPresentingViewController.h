//
//  ToPresentingViewController.h

//
//  Created by zhangtong on 2019/11/29.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DismissingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface PresentingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface ToPresentingViewController : UIViewController

/// 显示的大小
- (void)setViewFrame;
- (void)dismissViewController;

@end

NS_ASSUME_NONNULL_END
