//
//  ZTUserTool.h
//  auson
//
//  Created by zhangtong on 2021/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTUserTool : NSObject

+ (void)setUseraToken:(NSString *)Token;
+ (NSString *)userToken;
/// 登出移除用户
+ (void)removeUser;

@end

NS_ASSUME_NONNULL_END
