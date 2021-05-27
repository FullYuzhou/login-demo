//
//  BYSUserHandle.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/10.
//

#import "BYSUserHandle.h"
#import "AppDelegate.h"
#import "CSTabBarVC.h"

@interface BYSUserHandle()

@property (nonatomic,strong) NSUserDefaults *localUser;//本地信息存储

@end

@implementation BYSUserHandle

static BYSUserHandle *sharedObj = nil;
/**
 * @breif 获取实例
 */
+ (BYSUserHandle*) sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil){
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}
/**
 * @breif 重写allocWithZone方法
 */
+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}
/**
 * @breif 重写copyWithZone方法
 */
- (id) copyWithZone:(NSZone *)zone
{
    return self;
}
//重写get方法
-(UserInfoModel *)userInfo{
    
    NSData *userdata = [_localUser objectForKey:USERINFO];
    if (userdata.length!=0) {
        UserInfoModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userdata];
        _userInfo = userInfo;
    }
    return _userInfo;
}
/**
 * @breif 重写init方法
 */
- (id)init
{
    @synchronized(self)
    {
        if (self = [super init])
        {
            _userInfo = [[UserInfoModel alloc] init];
            
            //用户登录信息
            _localUser = [NSUserDefaults standardUserDefaults];
            NSData *userdata = [_localUser objectForKey:USERINFO];
            if (userdata.length!=0) {
                UserInfoModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userdata];
                _userInfo = userInfo;
            }
        }
        return self;
    }
}



/**
 * @breif 保存用户信息
 */
- (void)saveLocalUser:(UserInfoModel *)info{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
        [_localUser setObject:data forKey:USERINFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

//清除沙盒存储（退出登录时）
-(void)exitAccount{
    self.userInfo = nil;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USERINFO];
    [defaults synchronize];
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = [[CSTabBarVC alloc] init];
}


/**
 *  @brief 检测用户是否登录
 *  @return BOOL 是否登录
 */
- (BOOL)isUserLogin{
    NSData *userdata = [_localUser objectForKey:USERINFO];
    UserInfoModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userdata];
    if (userInfo.accountId.length<=0) {
        return YES;
    }
    return NO;
}
@end
