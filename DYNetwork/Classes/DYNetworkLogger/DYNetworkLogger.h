//
//  DYNetworkLogger.h
//  DYNetwork
//
//  Created by 破晓工作室 on 2019/6/25.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN

@interface DYNetworkLogger : NSObject

/**
 接口请求信息日志输出方法
 
 @param url 请求的url
 @param httpMethod 请求方式
 @param params 请求参数
 @param reachabilityStatus 网络状态
 */
+ (void)logDebugRequestInfoWithURL:(NSString *)url
                        httpMethod:(NSInteger)httpMethod
                            params:(NSDictionary *)params
                reachabilityStatus:(NSInteger)reachabilityStatus
                   networkPriority:(int)priority;


/**
 接口响应信息日志输出方法
 
 @param sessionDataTask 执行请求的sessionDataTask
 @param response 响应数据
 @param authentication 是否通过验证
 @param error error对象
 */
+ (void)logDebugResponseInfoWithSessionDataTask:(NSURLSessionDataTask *)sessionDataTask
                                 responseObject:(id)response
                                 authentication:(BOOL)authentication
                                          error:(NSError *)error;

@end

//NS_ASSUME_NONNULL_END
