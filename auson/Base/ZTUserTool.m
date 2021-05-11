//
//  ZTUserTool.m
//  auson
//
//  Created by zhangtong on 2021/5/11.
//

#import "ZTUserTool.h"

#define USERTOKEN @"USERTOKEN"

@implementation ZTUserTool

+ (void)setUseraToken:(NSString *)Token {
    if (!Token) {
        return;
    }
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    [defaults setValue:Token forKey:USERTOKEN];
    [defaults synchronize];
}

+ (NSString *)userToken {
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:USERTOKEN];
}

+ (void)removeUser
{
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USERTOKEN];
    [defaults synchronize];
}

@end
