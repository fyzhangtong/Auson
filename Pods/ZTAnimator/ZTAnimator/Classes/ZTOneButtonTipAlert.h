//
//  OneTextOneButtonAlert.h
//  FanBookClub
//
//  Created by zhangtong on 2020/7/22.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ZTToPresentingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTOneButtonTipAlert : ZTToPresentingViewController

+ (void)showTipAlertInController:(UIViewController *)controller title:(NSString *)title text:(NSString *)text buttonTitle:(NSString *)buttonTitle buttonAction:(void(^_Nullable)(void))buttonAction;

@end

NS_ASSUME_NONNULL_END
