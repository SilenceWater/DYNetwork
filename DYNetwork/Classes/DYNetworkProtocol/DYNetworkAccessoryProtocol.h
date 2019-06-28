//
//  DYNetworkAccessoryProtocol.h
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/25.
//

#import <Foundation/Foundation.h>
#import "DYNetworkEnumerator.h"
#import "DYNetworkResponse.h"

NS_ASSUME_NONNULL_BEGIN

/// 插件协议
@protocol DYNetworkAccessoryProtocol <NSObject>

@optional

/**
 请求将要执行 will
 */
- (void)networkRequestAccessoryWillStart;

/**
 请求已经执行 did
 */
- (void)networkRequestAccessoryDidStart;

/**
 请求已经完成 finish
 */
- (void)networkRequestAccessoryDidFinish;

/**
 请求完成执行 end 与 networkRequestAccessoryDidEndByResponse: 会同时被调用（只适用于 单体请求）

 @param networkStatus 网络请求状态值
 */
- (void)networkRequestAccessoryByStatus:(DYNetworkStatus)networkStatus;

/**
 请求完成执行 与 networkRequestAccessoryByStatus: 会同时被调用（只适用于 单体请求）

 @param response 请求响应数据
 */
- (void)networkRequestAccessoryDidEndByResponse:(DYNetworkResponse *)response;


@end

NS_ASSUME_NONNULL_END
