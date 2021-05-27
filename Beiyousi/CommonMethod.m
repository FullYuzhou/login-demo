//
//  CommonMethod.m
//  Chalvyun
//
//  Created by mMac on 2020/4/23.
//  Copyright © 2020 Tryine. All rights reserved.
//

#import "CommonMethod.h"
#import <CommonCrypto/CommonDigest.h>
#import "GKPhotoBrowser.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>

//#import <AVFoundation/AVAsset.h>
//#import <AVFoundation/AVAssetImageGenerator.h>
//#import <AVFoundation/AVTime.h>
//#import <CoreImage/CoreImage.h>

@implementation CommonMethod

+ (UserInfoModel *)acquireUserInfoAction {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary  *userDic = [userDefaults objectForKey:USERINFO];
    UserInfoModel *userInfoMod = [[UserInfoModel alloc] initWithDictionary:userDic error:nil];
//    UserInfoModel *userInfoMod = [[UserInfoModel alloc] initWithDictionary:userDic];//此处接收数据
    return userInfoMod;
}

+ (BOOL)isEmpty:(id)object{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        return [object isEqualToString:@""];
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object isEqualToNumber:@(0)];
    }
    return NO;
}

//替换本地用户数据
+ (void)modificationUserInfoAction:(NSString *)objectStr key:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary  *userDic = [userDefaults objectForKey:USERINFO];
    NSMutableDictionary *mineDic = [NSMutableDictionary dictionary];
    [mineDic setDictionary:userDic];
    [mineDic setObject:objectStr forKey:key];
    [userDefaults setObject:mineDic forKey:USERINFO];
    [userDefaults synchronize];
}

/**
 返回中间带*加密字符串
 @param idCardNumber 完整的身份证号码串 （idCard）
 @return 隐私身份证号码
 */
+ (NSString *)idCardNumber:(NSString *)idCardNumber {
    NSString *tempStr = @"";
    NSInteger numberLength = idCardNumber.length-7;
    if (numberLength > 0) {
        for (int i=0; i < numberLength; i++) {
            tempStr = [tempStr stringByAppendingString:@"*"];
        }
        //身份证号取前三位和后四位 中间拼接 tempSt（*）
        idCardNumber = [NSString stringWithFormat:@"%@%@%@", [idCardNumber substringToIndex:4], tempStr, [idCardNumber substringFromIndex:idCardNumber.length - 4]];
    }
    return idCardNumber;
}

//把大长串的数字做单位处理
+ (NSString *)changeAsset:(NSString *)amountStr {
    if(amountStr && ![amountStr isEqualToString:@""]) {
        NSInteger num = [amountStr integerValue];
        if(num >=10000) {
            NSString *str = [NSString stringWithFormat:@"%.2f",num/10000.0];
            return [NSString stringWithFormat:@"%@w",str];
        }else if(num >=1000) {
            NSString *str = [NSString stringWithFormat:@"%.2f",num/1000.0];
            return [NSString stringWithFormat:@"%@k",str];
        }else {
            return amountStr;
        }
    }else {
        return @"0";
    }
    
    return amountStr;
}

+ (NSString *)currentDateAndTime {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    [dateFormatter setTimeZone:zone];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

#pragma mark - NSDictionary转NSString
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableString *responseString = [NSMutableString stringWithString:jsonString];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    
    return jsonString;
}

#pragma mark - NSString转NSDictionary
+ (id)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - 获取时间戳
+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];

    return [NSString stringWithFormat:@"%ld",timeSp];
}

#pragma mark - 时间格式化
+ (NSString *)compareCurrentTime:(NSString *)str {
    
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSDate *nowDate = [NSDate date]; // 当前日期
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:timeDate];;
    timeInterval = timeInterval;
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 30) {
        result = [NSString stringWithFormat:@"刚刚"];
    }else if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"1分钟前"];
    }else if((temp = timeInterval/60) <60) {
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if((temp = temp/60) <24) {
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if((temp = temp/24) <=2) {
        result = @"昨天";
    }else if((temp = temp/24) <30) {
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"MM-dd"];
        //NSDate转NSString
        NSString *currentDateString = [dateFormatter stringFromDate:timeDate];
        result = currentDateString;
    }else {
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //NSDate转NSString
        NSString *currentDateString = [dateFormatter stringFromDate:timeDate];
        result = currentDateString;
    }
    
    return  result;
}

#pragma mark - 生成随机整数（从xx-xx）
+ (NSString *)getRandomInt:(int)from to:(int)to {
    int randomInt = (int)(from + (arc4random() % (to - from + 1)));
    
    return [NSString stringWithFormat:@"%d",randomInt];
}

#pragma mark - 大图浏览
+ (void)largerImageBrowsing:(NSArray *)imgArr currentIndex:(NSInteger)indexTag viewController:(UIViewController *)viewController sourceView:(UIImageView *)sourceImageView {
    
    //大图浏览
    NSArray *photosArr = imgArr;
    NSMutableArray *photoArrs = [NSMutableArray new];
    
    [photosArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        if ([obj isKindOfClass:[UIImage class]]) {
            photo.image = obj;
        }else {
            photo.url = [NSURL URLWithString:obj];
        }
        photo.sourceImageView = sourceImageView;//来源ImgView
        [photoArrs addObject:photo];
    }];
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoArrs currentIndex:indexTag];
    browser.showStyle       = GKPhotoBrowserShowStyleZoom;
    browser.hideStyle       = GKPhotoBrowserHideStyleZoomScale;
    browser.failStyle       = GKPhotoBrowserFailStyleOnlyImage;
//    browser.isSingleTapDisabled = YES;  // 不响应默认单击事件
    browser.failureText     = @"图片加载失败";
    browser.failureImage    = [UIImage imageNamed:@"error"];
//    browser.isLowGifMemory  = YES;//降低内存
//    browser.isSlideHide     = NO;
    browser.isPopGestureEnabled = NO;
    
    [browser showFromVC:viewController];
    
}

#pragma mark - 获取视频第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)path
{
    //本地视频
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
    //网络视频
    AVURLAsset *asset2 = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset2];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    if (videoImage == nil) {
        videoImage = [UIImage imageNamed:@""];
    }
    return videoImage;
}

+(NSString *)translationArabicNum:(NSString *)arabicNum{
    NSInteger chinese = [arabicNum integerValue];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    return chineseNumeralsArray[chinese - 1];
}

+ (void)viewAddShadow:(UIView *)view {
    //阴影层的扩散半径
    view.layer.shadowRadius = 1.0f;
    //阴影层的透明度
    view.layer.shadowOpacity = 0.5;
    //阴影层的颜色
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影层的偏移
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.masksToBounds = NO;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [CommonMethod getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) { // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {// 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){// 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {// 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
