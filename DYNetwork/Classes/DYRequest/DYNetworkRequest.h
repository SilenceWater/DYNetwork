//
//  DYNetworkRequest.h
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/25.
//

#import <Foundation/Foundation.h>
#import "DYNetworkAccessoryProtocol.h"
//#import "DYNetworkInterceptorProtocol.h"
#import "DYNetworkRequestConfigProtocol.h"
#import "DYNetworkResponseProtocol.h"
#import "DYNetworkServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYNetworkRequest : NSObject

/*! 请求tag 区分同一个代理存在多个请求 */
@property (nonatomic, assign) NSInteger tag;

/*! 请求载体 */
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;

/*! 请求配置协议 */
@property (nonatomic, weak, readonly) NSObject <DYNetworkRequestConfigProtocol>*requestConfigProtocol;

/*! 响应协议 */
@property (nonatomic, weak) id <DYNetworkResponseProtocol>responseDelegate;

/*! 拦截协议 */
//@property (nonatomic, weak) id <DYNetworkInterceptorProtocol>interceptorDelegate;

/*! 插件协议 */
@property (nonatomic, weak) id <DYNetworkAccessoryProtocol>accessoryDelegate;

/*! 重复次数 */
@property (nonatomic, assign) NSUInteger retryCount;


/**
 开始网络请求，使用delegate 方式使用这个方法
 */
- (void)startRequest;


/**
 停止网络请求

 @param status 网络接口状态
 */
- (void)stopRequestByStatus:(DYNetworkStatus)status;

/**
 停止网络请求

 @param response 返回实体
 */
- (void)stopRequestByResponse:(DYNetworkResponse *)response;

/**
 *  @brief 添加实现了SANetworkAccessoryProtocol的插件对象
 *
 *  @param accessoryDelegate 插件对象
 *  @warning 务必在启动请求之前添加插件。
 */
- (void)addNetworkAccessoryObject:(id<DYNetworkAccessoryProtocol>)accessoryDelegate;

@end

NS_ASSUME_NONNULL_END
