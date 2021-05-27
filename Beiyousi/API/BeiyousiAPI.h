//
//  BeiyousiAPI.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/10.
//

#import <Foundation/Foundation.h>

//请求超时
#define TIMEOUT 30

@interface BeiyousiAPI : NSObject

/**
 @param URLString 网址
 @param success 成功回调
 @param failure 失败回调
 */
-(void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *failure))failure;

/**
post 请求发送json数据

@param urlString url
@param parameters 参数的 字典形式
@param success 成功的调用
*/
-(void)postJsonWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void(^)(NSError *failure))failure;
/**
 @param URLString 网址
 @param success 成功回调
 @param failure 失败回调
 */
-(void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *failure))failure;

@end
