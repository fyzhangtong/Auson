//
//  HtmlStringWebView.h
//  
//
//  Created by zhangtong on 2020/6/9.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HtmlStringWebViewDelegate <NSObject>

- (void)refreshHtmlHeight:(CGFloat)height;

@end

@interface HtmlStringWebView : UIView

@property (nonatomic, weak) id<HtmlStringWebViewDelegate> delgegate;

@property (nonatomic, strong) WKWebView *articleWeb;

- (void)reloadHtmlData:(NSString *)htmlContent;

@end

NS_ASSUME_NONNULL_END
