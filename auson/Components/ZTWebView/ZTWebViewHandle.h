//
//  ZTWebViewHandle.h
//  FanBookClub
//
//  Created by zhangtong on 2020/6/19.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTWebViewHandle : NSObject

//本地页面跳转
+ (void)jumpTo:(NSURL *)url;

/// 是否包含中文
+ (BOOL)checkIsChinese:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
