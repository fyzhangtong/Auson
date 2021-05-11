//
//  MBProgressHUD+GTStyle.m
//  GeeTimerApp
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 zhangtong. All rights reserved.
//

#import "MBProgressHUD+GTStyle.h"

@implementation MBProgressHUD (GTStyle)

/*********************************************华丽的分割线***********************************************************/
+ (instancetype)showWindowWhiteHud
{
    [MBProgressHUD hideWindowHud];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    return hud;
}
+ (instancetype)showWindowWhiteHudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showWindowWhiteHud];
    hud.label.text = title;
    return hud;
}
+ (instancetype)showWindowWhiteHudWithTitle:(NSString *)title hideAfterDelay:(CGFloat)time
{
    MBProgressHUD *hud = [MBProgressHUD showWindowWhiteHudWithTitle:title];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:time];
    return hud;
}
/*********************************************华丽的分割线***********************************************************/
+ (instancetype)showWindowBlackHud
{
    MBProgressHUD *hud = [MBProgressHUD showWindowWhiteHud];
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.label.numberOfLines = 0;
    hud.contentColor = [UIColor whiteColor];
    
    return hud;
}
+ (instancetype)showWindowBlackHudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showWindowBlackHud];
    hud.label.text = title;
    return hud;
}
+ (instancetype)showWindowBlackHudWithTitle:(NSString *)title hideAfterDelay:(CGFloat)time
{
    MBProgressHUD *hud = [MBProgressHUD showWindowBlackHudWithTitle:title];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:time];
    return hud;
}
/*********************************************华丽的分割线***********************************************************/
+ (BOOL)hideWindowHud
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    return [MBProgressHUD hideHUDForView:window animated:YES];
}
/*********************************************华丽的分割线***********************************************************/
/**
 显示带有进度的hud

 @return hud
 */
+ (instancetype)showGTProgress
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [window addSubview:hud];
    UILabel *progressLabel = [UILabel new];
    [hud.bezelView addSubview:progressLabel];
    progressLabel.font = [UIFont systemFontOfSize:9];
    progressLabel.textColor = [UIColor whiteColor];
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(hud.bezelView);
        make.centerY.mas_equalTo(hud.bezelView.mas_centerY).mas_offset(-9);
    }];
    hud.progressLabel = progressLabel;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.detailsLabel.text = @"正在保存到本地";
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    return hud;
}
static const char MJRefreshFooterKey = '\0';
/**
 进度label的setter方法

 @param progressLabel label
 */
- (void)setProgressLabel:(UILabel *)progressLabel
{
    if (progressLabel != self.progressLabel) {
        // 删除旧的，添加新的
        
        // 存储新的
        [self willChangeValueForKey:@"progressLabel"]; // KVO
        objc_setAssociatedObject(self, &MJRefreshFooterKey,
                                 progressLabel, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"progressLabel"]; // KVO
    }
}

/**
 进度label

 @return label
 */
- (UILabel *)progressLabel
{
    return objc_getAssociatedObject(self, &MJRefreshFooterKey);
}
- (void)setProgressLabelText:(NSString *)text
{
    self.progressLabel.text = text;
}

@end
