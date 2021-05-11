//
//  ApiDefinition.h
//  auson
//
//  Created by fdxdz on 2021/5/11.
//

#ifndef ApiDefinition_h
#define ApiDefinition_h

#define AUSONHOST @"http://api.app.wangyx.wang:80/core"

#define AUSONAPI(u) [NSString stringWithFormat:@"%@%@",AUSONHOST,(u)]

/// 获取短信验证码
#define AUSONAPI_SMSCODE_GET AUSON(@"/common/validate/smscode/get")
/// 用户登陆 post
#define AUSONAPI_USER_LOGIN AUSON(@"/user/login")
/// 用户登陆 post
#define AUSONAPI_USER_LOGIN AUSON(@"/user/login")
/// 回去用户 post
#define AUSONAPI_USER_GET AUSON(@"/user/get")


#endif /* ApiDefinition_h */
