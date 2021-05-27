//
//  BeiyousiAPI.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/10.
//

#import "BeiyousiAPI.h"

@interface LoginAPI : BeiyousiAPI

-(void)smsLogin:(NSString *)phoneNum success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure;

//验证码登录
-(void)codeLogin:(NSString *)phoneNum code:(NSString *)code success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure;

//设置新密码发送验证码
-(void)forgetPwdCode:(NSString *)phoneNum success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure;

//重置密码
-(void)resetPasswd:(NSString *)phoneNum code:(NSString *)code password:(NSString *)password success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure;

//切换身份 获取用户信息
-(void)userCheckType:(NSString *)accountId type:(NSString *)type success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure;

//账号密码登录
-(void)userLoginJsonApp:(NSString *)password phone:(NSString *)phone success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure;

//用户获取账户电话号码
-(void)userGetPhone:(NSString *)accountId success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure;

@end
