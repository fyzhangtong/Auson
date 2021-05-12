//
//  ZTWebViewJavascriptBridge.h
//  FanBookClub
//
//  Created by zhangtong on 2018/6/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WKWebViewJavascriptBridge.h"
#import "ZTWebViewDelegate.h"

@interface ZTWebViewJavascriptBridge : WKWebViewJavascriptBridge

+ (instancetype _Nonnull )bridgeForWebView:(WKWebView *)webView delegate:(id<WKNavigationDelegate>)delegate ZTWebViewDelegate:(id<ZTWebViewDelegate> _Nullable)ZTWebViewDelegate;

@end
