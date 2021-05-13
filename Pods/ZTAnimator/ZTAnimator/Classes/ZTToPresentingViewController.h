//
//  ToPresentingViewController.h

//
//  Created by zhangtong on 2019/11/29.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTDismissingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface ZTPresentingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface ZTToPresentingViewController : UIViewController

/// 显示的大小
- (void)setViewFrame;
- (void)dismissViewController;

@end

NS_ASSUME_NONNULL_END
