//
//  DYNetworkServiceObject.m
//  DYNetwork_Example
//
//  Created by 德一智慧城市 on 2019/6/25.
//  Copyright © 2019 昌. All rights reserved.
//

#import "DYNetworkServiceObject.h"

@implementation DYNetworkServiceObject

/**
 服务接口地址的基础URL
 
 @return 接口基础地址
 */
- (NSString *)serviceApiBaseUrlString {
    return @[
             @"http://111.6.79.11:11021/api/",
             @"https://www.baidu.com/cit/",
             @"https://www.baidu.com/pro/"
             ][self.serviceType];
}


/**
 服务接口 Acceptable-Content 配置
 
 @return Acceptable-Content Types;
 */
- (NSSet<NSString *> *)serviceResponseAcceptableContentTypes {
    return [NSSet setWithObjects:@"application/json",@"text/html",@"application/javascript",nil];
    return [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
}

/**
 默认SARequestSerializerTypeHTTP
 
 @return [AFHTTPRequestSerializer serializer]
 */
- (DYRequestSerializerType)serviceRequestSerializerType {
    return DYRequestSerializerTypeHTTP;
}


/**
 默认SAResponseSerializerTypeJSON
 
 @return [AFJSONResponseSerializer serializer]
 */
- (DYResponseSerializerType)serviceResponseSerializerType {
    return DYResponseSerializerTypeJSON;
}


/**
 返回需要统一设定的请求头
 
 @return 请求头的字典
 */
- (NSDictionary<NSString *,NSString *> *)serviceBaseHTTPRequestHeaders {
    return nil;
    return @{
             @"system" : @"iOS 9.0",
             @"version" : @"1.0.0",
             @"time" : @"2016-06-04 14:18:05",
             @"token" : @"8046DB4D7844617E0F9EC72A46CE4317",
             };
}


/**
 基本的请求参数，在较多接口都会使用到的参数，这些参数可以作为base参数设定，比如用户名、app标示、版本 等等
 
 @return “基本”参数字典
 */
- (NSDictionary<NSString *,NSString *> *)serviceBaseParamSource {
    return nil;
}

/**
 针对特定服务的请求响应数据的统一验证。将影响响应数据的状态
 
 @param networkRequest 网络接口请求对象
 @param response 网络接口响应数据
 @return 验证结果状态
 */
- (DYServiceAuthenticationStatus)serviceBaseAuthenticationWithNetworkRequest:(DYNetworkRequest *)networkRequest response:(id)response {
    
    
    
    return DYServiceAuthenticationStatusPass;
}


/**
 请求失败之后的重试次数，最大设置为3次，默认为0
 @warning 仅限SANetworkResponseFailureStatus 或 SANetworkNotReachableStatus 失败状态下，起作用
 @return 重试次数
 */
- (NSUInteger)serviceRequestRetryCountWhenFailure {
    return 0;
}


/**
 请求超时时间，默认15秒
 
 @return 服务的请求超时时间
 */
- (NSTimeInterval)serviceRequestTimeoutInterval {
    return 3;
}

/*******以下协议的设定用于服务端返回数据的第一层格式统一，设定后，便于更深一层的取到数据 *********/


/**
 响应数据提示信息的key
 
 @return message key
 */
- (NSString *)responseMessageKey {
    return @"msg";
}


/**
 响应数据定制code的key
 
 @return code key
 */
- (NSString *)responseCodeKey {
    return @"code";
}


/**
 响应数据具体内容的key
 
 @return content key
 */
- (NSString *)responseContentDataKey {
    return @"data";
}

@end
