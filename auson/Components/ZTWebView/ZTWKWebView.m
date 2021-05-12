//
//  ZTWKWebView.m
//  FanBookClub
//
//  Created by zhangtong on 2020/6/19.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ZTWKWebView.h"
//#import <MTAHybrid.h>

@interface ZTWKWebView ()<WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, weak) id<ZTWebViewDelegate> ztWebViewDelegate;

@end

@implementation ZTWKWebView

- (instancetype)initWithFrame:(CGRect)frame ztWebViewDelegate:(id<ZTWebViewDelegate>)ztWebViewDelegate
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    if (@available(iOS 10.0,*)) {
        config.mediaTypesRequiringUserActionForPlayback = false;
    }
    if (@available(iOS 13.0,*)){
        config.defaultWebpagePreferences.preferredContentMode = WKContentModeMobile;
    }
    self = [super initWithFrame:frame configuration:config];
    /// 设置bridge
    self.bridge = [ZTWebViewJavascriptBridge bridgeForWebView:self delegate:self ZTWebViewDelegate:ztWebViewDelegate];
    self.ztWebViewDelegate = ztWebViewDelegate;
    [self makeView];
    [self addKVOToWebView];
    [self addNotificationCenterObserver];
    [self setUA];
    return self;
}
- (void)setUA
{
    /// 设置userAgent
    if (@available(iOS 12.0, *)){
        /// 修改iOS 12，iOS 12.1 下获取 ua失败的问题！
        NSString *baseAgent = [self valueForKey:@"applicationNameForUserAgent"];
        NSString *userAgent = [NSString stringWithFormat:@"%@ TencentMTA/1 xfanread",baseAgent];
        [self setValue:userAgent forKey:@"applicationNameForUserAgent"];
    }
    __weak typeof(self) weakSelf = self;
    [self evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable agent, NSError * _Nullable error) {
        NSString *oldAgent = agent;
        if ([oldAgent containsString:@"TencentMTA/1 xfanread"]) {
            return ;
        }
        // 给User-Agent添加额外的信息
        NSString *newAgent = [NSString stringWithFormat:@"%@ %@", oldAgent, @"TencentMTA/1 xfanread"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (@available(iOS 9.0,*)) {
            weakSelf.customUserAgent = newAgent;
        }else{
            // 设置global User-Agent
            [weakSelf setValue:newAgent forKey:@"applicationNameForUserAgent"];
        }
    }];
}
#pragma mark - getter
- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.progressTintColor = GlobalColor;
        
    }
    return _progressView;
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 处理MTA混合统计请求的代码
//    if ([MTAHybrid handleAction:navigationAction
//        fromWKWebView:webView]) {
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
//    打电话
//    NSURL *URL = navigationAction.request.URL;
//    NSString *scheme = [URL scheme];
//    if ([scheme isEqualToString:@"tel"]) {
//        NSString *resourceSpecifier = [URL resourceSpecifier];
//        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
//        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
//        dispatch_async(dispatch_get_global_queue(0,0), ^{
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
//                //设备系统为IOS 10.0或者以上的
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
//            }else{
//                 //设备系统为IOS 10.0以下的
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//            }
//        });
//        decisionHandler(WKNavigationActionPolicyCancel);
//    return;
//    }
    // 原有的代码
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - webView KVO title 和 进度
- (void)addKVOToWebView
{
    [self addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)removeObserverToWebView
{
    [self removeObserver:self forKeyPath:@"title"];
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
    [self removeObserver:self forKeyPath:@"canGoBack"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"title"] && object == self){
        if (self.ztWebViewDelegate && [self.ztWebViewDelegate respondsToSelector:@selector(webViewTitleChanged)]) {
            [self.ztWebViewDelegate webViewTitleChanged];
        }
    }else if ([keyPath isEqualToString:@"estimatedProgress"] && object == self){
        [self.progressView setProgress:self.estimatedProgress];
        self.progressView.hidden = self.estimatedProgress == 1;
    }else if ([keyPath isEqualToString:@"canGoBack"] && object == self){
//        self.closeButton.hidden = !self.webView.canGoBack;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)addNotificationCenterObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}
#pragma mark - 监听
/// 进入后台
- (void)resignActiveNotification
{

}
/// 进入前台
- (void)enterForegroundNotification
{
}
- (void)makeView
{
    [self addSubview:self.progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
    }];
}

- (void)dealloc
{
    NSLog(@"dealloc:%@",NSStringFromClass(self.class));
    [self removeObserverToWebView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
