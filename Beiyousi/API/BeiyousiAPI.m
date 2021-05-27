//
//  BeiyousiAPI.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/10.
//

#import "BeiyousiAPI.h"
#import <AFNetworking/AFNetworking.h>

@implementation BeiyousiAPI

-(void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *failure))failure{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    
//    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer=[AFHTTPResponseSerializer serializer];

//    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *str = BASE_URL;
    NSString * urlString =[str stringByAppendingString:URLString];

    [manager POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD showTip:@"网络错误"];
            failure(error);
        }];
}

/**
post 请求发送json数据

@param URLString url
@param parameters 参数的 字典形式
@param success 成功的调用
*/
-(void)postJsonWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void(^)(NSError *failure))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *str = BASE_URL;
    NSString * urlString =[str stringByAppendingString:URLString];
    
    [manager POST:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD showTip:@"网络错误"];
            failure(error);
        }];
}

-(void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *failure))failure{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    NSString *str = BASE_URL;
    NSString * urlString =[str stringByAppendingString:URLString];
    
    [manager GET:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
}


@end
