//
//  DYNetworkRequest.h
//  DYNetwork
//
//  Created by 破晓工作室 on 2019/6/25.
//

#import <Foundation/Foundation.h>
#import "DYNetworkAccessoryProtocol.h"
#import "DYNetworkRequestConfigProtocol.h"
#import "DYNetworkResponseProtocol.h"
#import "DYNetworkServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 单体请求
 */
@interface DYNetworkRequest : NSObject

/*! 请求tag 区分同一个代理存在多个请求 */
@property (nonatomic, assign) NSInteger tag;

/*! 请求载体 */
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;

/*! 请求配置协议 */
@property (nonatomic, weak, readonly) NSObject <DYNetworkRequestConfigProtocol>*requestConfigProtocol;

/*! 响应协议 */
@property (nonatomic, weak) id <DYNetworkResponseProtocol>responseDelegate;

/*! 插件协议 */
@property (nonatomic, weak) id <DYNetworkAccessoryProtocol>accessoryDelegate;

/*! 重复次数 */
@property (nonatomic, assign) NSUInteger retryCount;

/*! 优先级（默认 DYNetworkPriorityTypeDefaultNormal ） */
@property (nonatomic, assign, readonly) DYNetworkPriorityType priorityType;

/*! 容器类（单体请求可以为空） */
@property (nonatomic, weak) id containerClass;


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
 添加实现了DYNetworkAccessoryProtocol的插件对象
 @waring 在启动请求之前添加插件 可添加多个
 @param accessoryDelegate accessoryDelegate 插件对象
 */
- (void)addNetworkAccessoryObject:(id<DYNetworkAccessoryProtocol>)accessoryDelegate;

@end

NS_ASSUME_NONNULL_END
