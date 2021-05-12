//
//  HtmlStringWebView.m
//  FanBookClub
//
//  Created by zhangtong on 2020/6/9.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "HtmlStringWebView.h"

@interface HtmlStringWebView ()<WKNavigationDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) ZTWebViewJavascriptBridge *bridge;

@end

@implementation HtmlStringWebView

- (instancetype)init
{
    self = [super init];
    [self makeView];
    return self;
}
- (void)makeView
{
    [self addSubview:self.articleWeb];
    [_articleWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
- (WKWebView *)articleWeb
{
    if (!_articleWeb) {
        
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
            
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.processPool = [[WKProcessPool alloc] init];
        WKUserContentController *con = [[WKUserContentController alloc] init];
        [con addUserScript:wkUScript];
        config.userContentController = con;

        
        _articleWeb = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        _articleWeb.navigationDelegate = self;
        _articleWeb.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _articleWeb;
}
- (void)tapAction
{
    
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.superview animated:YES];
    
    
    [webView evaluateJavaScript:@"Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)"
                 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (!error) {
            if (self.delgegate && [self.delgegate respondsToSelector:@selector(refreshHtmlHeight:)]) {
                [self.delgegate refreshHtmlHeight:[result floatValue]];
            }
        }
  }];
    
}

- (void)reloadHtmlData:(NSString *)htmlContent {
    
    self.bridge = [ZTWebViewJavascriptBridge bridgeForWebView:self.articleWeb delegate:self ZTWebViewDelegate:nil];
//    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *html = [self adaptWebViewForHtml:htmlContent];
    [self.articleWeb loadHTMLString:html baseURL:nil];
}

//HTML适配图片文字
- (NSString *)adaptWebViewForHtml:(NSString *) htmlStr
{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
//    [headHtml appendString : @"<html>" ];
    
//    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];

    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
     //适配图片宽度，让图片宽度最大等于屏幕宽度
//    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];

    
   //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
    
}
@end
