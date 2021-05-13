//
//  OneButtonImageTipAlert.h
//  FanBookClub
//
//  Created by zhangtong on 2020/9/1.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ZTToPresentingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTOneButtonImageTipAlert : ZTToPresentingViewController

+ (void)showTipAlertInController:(UIViewController *)controller image:(UIImage *)image text:(NSString *)text buttonTitle:(NSString *)buttonTitle buttonAction:(void(^_Nullable)(void))buttonAction;

@end

NS_ASSUME_NONNULL_END
