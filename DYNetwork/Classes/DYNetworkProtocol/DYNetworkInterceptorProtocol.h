//
//  DYNetworkInterceptorProtocol.h
//  DYNetwork
//
//  Created by 破晓工作室 on 2019/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DYNetworkRequest;
@class DYNetworkResponse;

/**
 拦截协议
 */
@protocol DYNetworkInterceptorProtocol <NSObject>

@optional

/**
 在请求成功回调之前执行

 @param networkRequest 网络接口请求对象
 @param networkResponse 网络接口响应对象
 */
- (void)networkRequest:(DYNetworkRequest *)networkRequest beforePerformSuccessWithResponse:(DYNetworkResponse *)networkResponse;


/**
 在请求成功回调之后执行

 @param networkRequest 网络接口请求对象
 @param networkResponse 网络接口响应对象
 */
- (void)networkRequest:(DYNetworkRequest *)networkRequest afterPerformSuccessWithResponse:(DYNetworkResponse *)networkResponse;


/**
 在请求失败回调之前执行
 
 @param networkRequest 网络接口请求对象
 @param networkResponse 网络接口响应对象
 */
- (void)networkRequest:(DYNetworkRequest *)networkRequest beforePerformFailWithResponse:(DYNetworkResponse *)networkResponse;

/**
 在请求失败回调之后执行
 
 @param networkRequest 网络接口请求对象
 @param networkResponse 网络接口响应对象
 */
- (void)networkRequest:(DYNetworkRequest *)networkRequest afterPerformFailWithResponse:(DYNetworkResponse *)networkResponse;


@end

NS_ASSUME_NONNULL_END
