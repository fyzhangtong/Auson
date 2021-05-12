//
//  ZTWKWebView.h
//  
//
//  Created by zhangtong on 2020/6/19.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "ZTWebViewDelegate.h"
#import "ZTWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTWKWebView : WKWebView<WKNavigationDelegate>

@property (nonatomic, strong) ZTWebViewJavascriptBridge *bridge;

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame ztWebViewDelegate:(id<ZTWebViewDelegate>)ztWebViewDelegate;

@end

NS_ASSUME_NONNULL_END
