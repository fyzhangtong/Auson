//
//  ZTNetworking.h
//  auson
//
//  Created by zhanZTong on 2021/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum{
    
    StatusUnknown           = -1,  //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
    
}NetworkStatus;

@class ZTNetWorkingResponse;

typedef void( ^ ZTResponseSuccess)(ZTNetWorkingResponse *response);
typedef void( ^ ZTResponseFail)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);
typedef void( ^ ZTUploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);
typedef void( ^ ZTDownloadProgress)(int64_t bytesProgress,
                                    int64_t totalBytesProgress);

@interface ZTNetWorkingResponse : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSDictionary *data;

@end

@interface ZTNetworking : NSObject

/**
 *  获取网络
 */
@property (nonatomic,assign)NetworkStatus networkStats;


/**
 *  get请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 */

+(NSURLSessionDataTask *)getWithUrl:(NSString *)url
           params:(NSDictionary * _Nullable)params
          success:(ZTResponseSuccess _Nullable)success
             fail:(ZTResponseFail _Nullable)fail;
/**
 *  get请求方法,可控制是否显示登陆页
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param showLoginIfNeed 如果未登录是否提示
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 */

+(NSURLSessionDataTask *)getWithUrl:(NSString *)url
           params:(NSDictionary * _Nullable)params
  showLoginIfNeed:(BOOL)showLoginIfNeed
          success:(ZTResponseSuccess _Nullable)success
             fail:(ZTResponseFail _Nullable)fail;
/// post请求方法,block回调（3.2版本弃用，之后用base请求，jsonRequest传YES）
+(NSURLSessionDataTask *)postWithUrl:(NSString *)url
            params:(NSDictionary * _Nullable)params
   showLoginIfNeed:(BOOL)showLoginIfNeed
           success:(ZTResponseSuccess _Nullable)success
              fail:(ZTResponseFail _Nullable)fail;

/// base网络请求
/// @param type 1:get，2post
/// @param jsonRequest （3.2版本后所有post网络请求jsonRequest传YES，其他传NO）
+(NSURLSessionDataTask *)requestWithType:(NSUInteger)type
            url:(NSString *)url
         params:(NSDictionary * _Nullable)params
    jsonRequest:(BOOL)jsonRequest
showLoginIfNeed:(BOOL)showLoginIfNeed
timeoutInterval:(NSInteger)timeoutInterval
        success:(ZTResponseSuccess)success
           fail:(ZTResponseFail)fail;

@end

NS_ASSUME_NONNULL_END
