//
//  BYSUserHandle.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/10.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface BYSUserHandle : NSObject


@property (nonatomic,strong) UserInfoModel *userInfo;    //用户信息

//重写get方法
-(UserInfoModel *)userInfo;

/**
 * @breif 获取实例
 */
+ (BYSUserHandle *) sharedInstance;

/**
 * @breif 保存用户信息
 */
- (void)saveLocalUser:(UserInfoModel *)info;

/**
 *  @brief 检测用户是否登录
 *  @return BOOL 是否登录
 */
- (BOOL)isUserLogin;

//清除沙盒存储（退出登录时）
-(void)exitAccount;

@end
