//
//  ZTWebViewHandle.m
//  FanBookClub
//
//  Created by zhangtong on 2020/6/19.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ZTWebViewHandle.h"

#define AppScheme @"auson"

@implementation ZTWebViewHandle

//页面跳转
+ (void)jumpTo:(NSURL *)url
{
    if ([url.scheme isEqualToString:AppScheme]) {
//        if ([url.host isEqualToString:@"bookDetail"]) {
//            //图书详情
//            if (url.query) {
//                NSDictionary* query = [self queryContentsUsingEncoding:NSUTF8StringEncoding string:url.query];
//                NSArray *array = query[@"id"];
//                if (!array) {
//                    return;
//                }
//            }
//
//        }
    }
}
//将id=62&type=1这类字符串转成字典
+ (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding string:(NSString *)string
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:string];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByRemovingPercentEncoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByRemovingPercentEncoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}
/// 是否包含中文
+ (BOOL)checkIsChinese:(NSString *)string{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}
/**
 获取url中莫个参数对应的值

 @param parameter 参数值
 @param url 原URL
 @return 返回的参数
 */
+ (NSString *)getParameter:(NSString *)parameter urlStr:(NSString *)url {
    
    NSError *error;
    
    if (!url) {
        
        return @"";
        
    }
    
    NSString *regTags = [[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",parameter];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *matches = [regex matchesInString:url options:0 range:NSMakeRange(0, [url length])];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]]; //分组2所对应的串
        
        return tagValue;
        
    }
    
    return @"";
    
}
/**
 删除url中的莫个参数键值对

 @param parameter 要删除的key
 @param originUrl 原url
 @return 删除键值对后的URL
 */
+ (NSString *)deleteParameter:(NSString *)parameter WithOriginUrl:(NSString *)originUrl {
    
    NSString *finalStr = [NSString string];
    
    NSMutableString * mutStr = [NSMutableString stringWithString:originUrl];
    
    NSArray *strArray = [mutStr componentsSeparatedByString:parameter];
    
    NSMutableString *firstStr = [strArray objectAtIndex:0];
    
    NSMutableString *lastStr = [strArray lastObject];
    
    NSRange characterRange = [lastStr rangeOfString:@"&"];
    
    if (characterRange.location !=NSNotFound) {
        
        NSArray *lastArray = [lastStr componentsSeparatedByString:@"&"];
        
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:lastArray];
        
        [mutArray removeObjectAtIndex:0];
        
        NSString *modifiedStr = [mutArray componentsJoinedByString:@"&"];
        
        finalStr = [[strArray objectAtIndex:0]stringByAppendingString:modifiedStr];
        
    } else {
        
        //以'?'、'&'结尾
        finalStr = [firstStr substringToIndex:[firstStr length] -1];
        
    }
    
    return finalStr;
    
}
@end
