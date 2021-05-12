//
//  MBProgressHUD+GTStyle.h
//  zhangtong
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 zhangtong. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (GTStyle)
/**
 黑色hud

 @return hud
 */
+ (instancetype)showWindowBlackHud;
+ (instancetype)showWindowBlackHudWithTitle:(NSString *)title;
+ (instancetype)showWindowBlackHudWithTitle:(NSString *)title hideAfterDelay:(CGFloat)time;

/**
 隐藏hud

 @return yes or no
 */
+ (BOOL)hideWindowHud;

/**
 显示带有进度的hud
 
 @return hud
 */
+ (instancetype)showGTProgress;

/**
 设置进度hud的progresstext
 
 @param text 内容
 */
- (void)setProgressLabelText:(NSString *)text;

@end
