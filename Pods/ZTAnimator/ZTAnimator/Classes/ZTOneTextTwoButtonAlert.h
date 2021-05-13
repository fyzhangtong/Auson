//
//  OneTextTwoButtonAlert.h
//  FanBookClub
//
//  Created by zhangtong on 2019/11/30.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "ZTToPresentingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTOneTextTwoButtonAlert : ZTToPresentingViewController

+ (void)showOneTextTwoButtonAlertInController:(UIViewController *)controller text:(NSString *)text leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftButtonAction:(void(^_Nullable)(void))leftButtonAction rightButtonAction:(void(^)(void))rightButtonAction;

@end

NS_ASSUME_NONNULL_END
