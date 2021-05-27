//
//  BeiyousiAPI.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/10.
//


#import "LoginAPI.h"

@implementation LoginAPI

//登录发送验证码
-(void)smsLogin:(NSString *)phoneNum success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure{
    NSDictionary * parameters =@{@"phoneNum":phoneNum?:@""
                                 };
    [self POST:userSmartGetcode parameters:parameters success:^(id responseObject) {
        success(responseObject);

    } failure:^(NSError *error) {
        failure(error);
    }];
}

//验证码登录
-(void)codeLogin:(NSString *)phoneNum code:(NSString *)code success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure{
    NSDictionary * parameters =@{@"phoneNum":phoneNum?:@"",
                                 @"code":code?:@""
                                 };
    [self POST:userSmartEntry parameters:parameters success:^(id responseObject) {
        success(responseObject);

    } failure:^(NSError *error) {
        failure(error);
    }];
}

//设置新密码发送验证码
-(void)forgetPwdCode:(NSString *)phoneNum success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure{
    NSDictionary * parameters =@{@"phoneNum":phoneNum?:@""
                                 };
    [self POST:userResetPasswdGetcode parameters:parameters success:^(id responseObject) {
        success(responseObject);

    } failure:^(NSError *error) {
        failure(error);
    }];
}

//重置密码
-(void)resetPasswd:(NSString *)phoneNum code:(NSString *)code password:(NSString *)password success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure{
    NSDictionary * parameters =@{@"phoneNum":phoneNum?:@"",
                                 @"code":code?:@"",
                                 @"password":password?:@""
                                 };
    [self POST:userResetPasswd parameters:parameters success:^(id responseObject) {
        success(responseObject);

    } failure:^(NSError *error) {
        failure(error);
    }];
}

//切换身份（用户信息接口）
-(void)userCheckType:(NSString *)accountId type:(NSString *)type success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure{
    NSDictionary * parameters =@{@"accountId":accountId?:@"",
                                 @"type":type?:@""
                                 };
    [self POST:userAppCheckType parameters:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//账号密码登录
-(void)userLoginJsonApp:(NSString *)password phone:(NSString *)phone success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure{

    NSDictionary * parameters =@{@"password":password?:@"",
                                 @"phone":phone?:@""
                                 };
    [self postJsonWithURLString:userAppLogin parameters:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *failure) {
//        failure(error);
    }];
}

//用户获取账户电话号码
-(void)userGetPhone:(NSString *)accountId success:(void(^)(id model))success failure:(void(^)(NSError *failure))failure{
    NSDictionary * parameters =@{@"accountId":accountId?:@"",
                                 };
    [self POST:userGetUserPhone parameters:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
