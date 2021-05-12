//
//  ZTNetworking.m
//  auson
//
//  Created by zhanZTong on 2021/5/11.
//

#import "ZTNetworking.h"
#import <AFNetworking.h>

@implementation ZTNetWorkingResponse

@end

@implementation ZTNetworking

+(NSURLSessionDataTask *)getWithUrl:(NSString *)url
           params:(NSDictionary * _Nullable)params
          success:(ZTResponseSuccess)success
             fail:(ZTResponseFail)fail{
    
    return [self requestWithType:1 url:url params:params jsonRequest:NO showLoginIfNeed:YES timeoutInterval:30 success:success fail:fail];
}
+(NSURLSessionDataTask *)getWithUrl:(NSString *)url
           params:(NSDictionary * _Nullable)params
  showLoginIfNeed:(BOOL)showLoginIfNeed
          success:(ZTResponseSuccess)success
             fail:(ZTResponseFail)fail{
    return [self requestWithType:1 url:url params:params jsonRequest:NO showLoginIfNeed:showLoginIfNeed timeoutInterval:30 success:success fail:fail];
}

+(NSURLSessionDataTask *)postWithUrl:(NSString *)url
            params:(NSDictionary * _Nullable)params
   showLoginIfNeed:(BOOL)showLoginIfNeed
           success:(ZTResponseSuccess)success
              fail:(ZTResponseFail)fail{
    
    return [self requestWithType:2 url:url params:params jsonRequest:NO showLoginIfNeed:showLoginIfNeed timeoutInterval:30 success:success fail:fail];
}

+(NSURLSessionDataTask *)requestWithType:(NSUInteger)type
                   url:(NSString *)url
                params:(NSDictionary * _Nullable)params
           jsonRequest:(BOOL)jsonRequest
       showLoginIfNeed:(BOOL)showLoginIfNeed
       timeoutInterval:(NSInteger)timeoutInterval
               success:(ZTResponseSuccess)success
                  fail:(ZTResponseFail)fail
{
    if (!url) {
        return nil;
    }
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url]?url:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //网络请求的manager
    AFHTTPSessionManager *manager = [self getAFManagerWithParams:params type:type jsonRequest:jsonRequest];
    manager.requestSerializer.timeoutInterval=timeoutInterval;
    
    void(^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);
    void (^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
    failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求url:%@;\nparams:%@;\nerror=%@",url,params,error);
        
        NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
        if (r.statusCode == 401) {
            //未登录
            if (showLoginIfNeed) {
                
                if (fail) {
                    fail(task,error);
                }
            }else{
                if (fail) {
                    fail(task,error);
                }
            }
        }else{
            if (fail) {
                fail(task,error);
            }
        }
    };
    successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求url:%@;\nparams:%@;\n结果:%@",url,params,responseObject);
        
        ZTNetWorkingResponse *response = [ZTNetWorkingResponse yy_modelWithJSON:responseObject];
        NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
        if (r.statusCode == 200){
            //正常返回
            if (success) {
                success(response);
            }
        }else{
            if (fail) {
                NSError *error = [NSError errorWithDomain:url code:r.statusCode userInfo:@{NSLocalizedDescriptionKey:@"服务器异常"}];
                fail(task,error);
            }
        }
    };
    NSURLSessionDataTask *task;
    if (type == 1) {
           task = [manager GET:url parameters:params headers:nil progress:nil success:successBlock failure:failureBlock];
       }else{

           task = [manager POST:urlStr parameters:params headers:nil progress:nil success:successBlock failure:failureBlock];
       }
    return task;
}
#pragma mark - 开始监听网络连接
+(AFHTTPSessionManager *)getAFManagerWithParams:(NSDictionary *)params type:(NSInteger)type jsonRequest:(BOOL)jsonRequest
{
 
    AFHTTPSessionManager *manager = manager = [AFHTTPSessionManager manager];
    //设置https连接暂无证书校验模式：
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    if (jsonRequest) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];//设置请求数据为json
    }else{
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
  
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
    
    
    //需要签名的字典
    NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
    if (type == 1) {
        //get请求
        [dic setDictionary:params];
    }
    NSString *token = [ZTUserTool userToken];
    if (token) {
        [dic setObject:token forKey:@"token"];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    //版本
    [manager.requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"App-Version"];
    //系统版本
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]] forHTTPHeaderField:@"Auson-System"];
    
    return manager;
}

@end
