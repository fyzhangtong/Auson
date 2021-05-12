//
//  ZTWebViewJavascriptBridge.m
//
//
//  Created by zhangtong on 2018/6/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ZTWebViewJavascriptBridge.h"

#import "ZTWebViewHandle.h"
#import <WebKit/WebKit.h>


@interface ZTWebViewJavascriptBridge()<WKNavigationDelegate>


@end

@implementation ZTWebViewJavascriptBridge

+ (instancetype)bridgeForWebView:(WKWebView *)webView delegate:(id<WKNavigationDelegate>)delegate ZTWebViewDelegate:(id<ZTWebViewDelegate> _Nullable)ZTWebViewDelegate
{
    ZTWebViewJavascriptBridge *bridge = [super bridgeForWebView:webView];
    [bridge setWebViewDelegate:delegate];
    
    //页面跳转
    [bridge registerHandler:@"jumpTo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"调用 jumpTo......");
        [ZTWebViewHandle jumpTo:[NSURL URLWithString:(NSString *)data]];
        responseCallback(nil);
    }];
    
   return bridge;
}


+ (UIViewController *)getControllerFromView:(UIView *)view {
    // 遍历响应者链。返回第一个找到视图控制器
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]]){
            return (UIViewController *)responder;
        }
    }
    // 如果没有找到则返回nil
    return nil;
}
@end
