//
//  ZTWebViewDelegate.h
//  
//
//  Created by zhangtong on 2020/6/19.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZTWebViewDelegate <NSObject>

@optional
/// 显示右上角分享
- (void)shareOpenWithData:(NSDictionary *)shareData;
/// 显示预分享按钮
- (void)preShareShow;
/// 隐藏右上角分享
- (void)shareClose;
//关闭H5页面，直接回到原生页面
- (void)closeNative;
- (void)webViewTitleChanged;

@end

NS_ASSUME_NONNULL_END
