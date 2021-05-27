//
//  CommonMethod.h
//  Chalvyun
//
//  Created by mMac on 2020/4/23.
//  Copyright © 2020 Tryine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonMethod : NSObject

//获取用户信息
+ (UserInfoModel *)acquireUserInfoAction;

/**
 *  判断对象是否为空
 *  常见的：nil、NSNil、@""、@(0) 以上4种返回YES
 *  如果需要判断字典与数组，可以自行添加
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)isEmpty:(id)object;

//字符串中间带*加密
+ (NSString *)idCardNumber:(NSString *)idCardNumber;
//把大长串的数字做单位处理
+ (NSString *)changeAsset:(NSString *)amountStr;
+ (NSString *)currentDateAndTime;//时间
//获取当前时间戳
+(NSString *)getNowTimeTimestamp;
//时间格式化
+ (NSString *)compareCurrentTime:(NSString *)str;
//大图浏览
+ (void)largerImageBrowsing:(NSArray *)imgArr currentIndex:(NSInteger)indexTag viewController:(UIViewController *)viewController sourceView:(UIImageView *)sourceImageView;
//获取视频第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)path;
//数字月份转中文
+(NSString *)translationArabicNum:(NSString *)arabicNum;
//添加阴影
+ (void)viewAddShadow:(UIView *)view;
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;
//替换本地用户数据
+ (void)modificationUserInfoAction:(NSString *)objectStr key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
