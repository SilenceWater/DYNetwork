//
//  DYNetworkBatchRequest.h
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/26.
//

#import <Foundation/Foundation.h>
#import "DYNetworkBatchResponseProtocol.h"
#import "DYNetworkAccessoryProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class DYNetworkRequest;

/**
 批次请求
 */
@interface DYNetworkBatchRequest : NSObject

/*! 批量请求响应代理 */
@property (nonatomic, weak) id <DYNetworkBatchResponseProtocol> delegate;

/*! 最大并发量 默认3 */
@property (nonatomic, assign) NSInteger maxConcurrentCount;


/**
 初始化批量请求。创建批量请求对象，只可使用此初始化方法
 
 @param requestArray 需要放在一起批量请求的请求对象集合
 @return 批量请求的对象
 */
- (instancetype)initWithRequestArray:(NSArray <DYNetworkRequest *>*)requestArray NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new  NS_UNAVAILABLE;


/**
 开始批量请求
 */
- (void)startBatchRequest;


/**
 取消批量请求
 */
- (void)stopBatchRequest;

/**
 添加实现了DYNetworkAccessoryProtocol的插件对象
 @waring 在启动请求之前添加插件 可添加多个
 @param accessoryDelegate accessoryDelegate 插件对象
 */
- (void)addNetworkAccessoryObject:(id<DYNetworkAccessoryProtocol>)accessoryDelegate;


@end

NS_ASSUME_NONNULL_END
