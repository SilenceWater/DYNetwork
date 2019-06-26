//
//  DYNetworkResponseProtocol.h
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DYNetworkRequest;
@class DYNetworkResponse;


/**
 请求响应协议
 */
@protocol DYNetworkResponseProtocol <NSObject>

@optional

/**
 请求成功的回调

 @param networkRequest 请求对象
 @param response 响应的数据（DYNetworkResponse）
 */
- (void)networkRequest:(DYNetworkRequest *)networkRequest succeedByResponse:(DYNetworkResponse *)response;


/**
 请求失败的回调

 @param networkRequest 请求对象
 @param response 响应的数据（DYNetworkResponse）
 */
- (void)networkRequest:(DYNetworkRequest *)networkRequest failedByResponse:(DYNetworkResponse *)response;


/**
 请求进度的回调，一般适用于上传文件

 @param networkRequest 请求对象
 @param progress 进度
 */
- (void)networkRequest:(DYNetworkRequest *)networkRequest requestingByProgress:(NSProgress *)progress;

@end

NS_ASSUME_NONNULL_END
