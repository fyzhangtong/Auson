//
//  ZTWebViewController.m
//  FanBookClub
//
//  Created by zhangtong on 2017/12/25.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ZTWebViewController.h"
#import <WebKit/WebKit.h>
#import "ZTWebViewHandle.h"


@interface ZTWebViewController ()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *webTitle;
@property (nonatomic, copy) NSString *rightButtonTitle;
@property (nonatomic, copy) NSString *rightButtonImageString;
@property (nonatomic, copy) void(^rightButtonAction)(void);


@end

@implementation ZTWebViewController
+ (void)openUrl:(NSString *)url webTitle:(NSString *)webTitle rightButtonTitle:(NSString *)rightButtonTitle rightButtonAction:(void(^)(void))rightButtonAction controller:(UIViewController *)controller
{
    [ZTWebViewController openUrl:url webTitle:webTitle rightButtonTitle:rightButtonTitle rightButtonImage:nil rightButtonAction:rightButtonAction controller:controller];
}
+ (void)openUrl:(NSString *)url webTitle:(NSString *)webTitle rightButtonTitle:(NSString *)rightButtonTitle rightButtonImage:(NSString *)rightButtonImage rightButtonAction:(void(^)(void))rightButtonAction controller:(UIViewController *)controller
{
    if (controller == nil) {
        return;
    }
    if (url.length == 0) {
        return;
    }
    NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    NSURL *newUrl = [NSURL URLWithString:urlString];
    if ([newUrl.scheme isEqualToString:@"xfanread"]){
        [ZTWebViewHandle jumpTo:newUrl];
    }else{
        ZTWebViewController *webVC = [[ZTWebViewController alloc] init];
        webVC.url = url;
        webVC.webTitle = webTitle;
        webVC.rightButtonTitle = rightButtonTitle;
        webVC.rightButtonImageString = rightButtonImage;
        webVC.rightButtonAction = rightButtonAction;
        [controller.navigationController pushViewController:webVC animated:YES];
    }
}
+ (void)openUrl:(NSString *)url webTitle:(NSString *)webTitle controller:(UIViewController *)controller
{
    [ZTWebViewController openUrl:url webTitle:webTitle rightButtonTitle:nil rightButtonAction:nil controller:controller];
}
+ (void)openUrl:(NSString *)url controller:(UIViewController *)controller
{
    [ZTWebViewController openUrl:url webTitle:nil controller:controller];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeView];
    NSLog(@"****************要加载的url：%@",self.url);
    /// 加载url
    if ([ZTWebViewHandle checkIsChinese:self.url]) {
        self.url = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    }
    NSURL *url = [NSURL URLWithString:self.url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}
- (void)makeView
{
    [self addLeftBackButton];
    if (self.webTitle) {
        [self setCenterTitle:self.webTitle];
    }
    
    if (self.rightButtonImageString) {
        [self setRightButtonImage:[UIImage imageNamed:self.rightButtonImageString]];
    }else if (self.rightButtonTitle){
        [self setRightButtonTitle:self.rightButtonTitle titleColor:[UIColor colorWithHexString:@"#666666"]];
    }
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ownNavigationBar.mas_bottom);
        make.left.and.bottom.and.right.mas_equalTo(self.view);
    }];
}
#pragma mark - getter

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[ZTWKWebView alloc] initWithFrame:CGRectZero ztWebViewDelegate:self];
    }
    return _webView;
}

#pragma mark - action
- (void)leftButtonClick:(UIButton *)sender
{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
    } else {
        [self closeNative];
    }
}
- (void)rightButtonClick:(UIButton *)sender
{
    if (self.rightButtonAction) {
        self.rightButtonAction();
    }
}
#pragma mark - ZTWebViewDelegate
- (void)webViewTitleChanged
{
    if (!self.webTitle) {
        [self setCenterTitle:self.webView.title];
    }
}
//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:YES];
}
/// 显示右上角分享
- (void)shareOpenWithData:(NSDictionary *)shareData
{

}
/// 隐藏右上角分享
- (void)shareClose
{
    self.rightBarButton.hidden = YES;
    self.rightButtonAction = nil;
}
/// 显示预分享按钮
- (void)preShareShow
{
    [self setRightButtonImage:[UIImage imageNamed:@"share_icon_xiangqing"]];
    self.rightBarButton.hidden = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
