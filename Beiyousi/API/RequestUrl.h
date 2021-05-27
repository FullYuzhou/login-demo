//
//  RequestUrl.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/10.
//

#ifndef RequestUrl_h
#define RequestUrl_h

#pragma mark ----------------公共方法------------------

#pragma mark ----------------用户接口------------------
//账号密码登录
#define userAppLogin       @"/app/user/login"
//app获取验证码一键登录或者注册
#define userSmartGetcode   @"/app/user/smart/getcode"
//app通过验证码一键登录或者注册
#define userSmartEntry     @"/app/user/smart/entry"
//app获取重置密码的验证码
#define userResetPasswdGetcode @"/app/user/reset_passwd/getcode"
//重置密码
#define userResetPasswd    @"/app/user/reset/passwd"
//切换用户身份
#define userAppCheckType      @"/app/user/check/type"
//用户获取账户电话号码
#define userGetUserPhone      @"/app/user/get/user/phone"

#endif /* RequestUrl_h */
