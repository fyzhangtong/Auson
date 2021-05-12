//
//  ZTWebViewController.h
//  
//
//  Created by zhangtong on 2017/12/25.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "ZTWebViewDelegate.h"
#import "ZTWKWebView.h"

@interface ZTWebViewController : BaseViewController<ZTWebViewDelegate>

@property (nonatomic, strong) ZTWKWebView *webView;

+ (void)openUrl:(NSString *)url controller:(UIViewController *)controller;
/// 打开web，可设置标题
+ (void)openUrl:(NSString *)url webTitle:(NSString *)webTitle controller:(UIViewController *)controller;
/// 打开web，可设置右边按钮标题
+ (void)openUrl:(NSString *)url webTitle:(NSString *)webTitle rightButtonTitle:(NSString *)rightButtonTitle rightButtonAction:(void(^)(void))rightButtonAction controller:(UIViewController *)controller;
/// 打开web，可设置右边按钮图片
+ (void)openUrl:(NSString *)url webTitle:(NSString *)webTitle rightButtonTitle:(NSString *)rightButtonTitle rightButtonImage:(NSString *)rightButtonImage rightButtonAction:(void(^)(void))rightButtonAction controller:(UIViewController *)controller;

@end
