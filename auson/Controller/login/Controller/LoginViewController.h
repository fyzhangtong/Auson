//
//  LoginViewController.h
//  auson
//
//  Created by zhangtong on 2021/5/12.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : BaseViewController

+ (void)loginWithComplete:(void(^__nullable)(BOOL success))complete;

@end

NS_ASSUME_NONNULL_END
