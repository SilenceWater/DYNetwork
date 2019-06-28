//
//  DYNetworkBatchResponseProtocol.h
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DYNetworkBatchRequest;
@class DYNetworkResponse;

/**
 批次响应协议
 */
@protocol DYNetworkBatchResponseProtocol <NSObject>

/**
 批量请求结束回调方法

 @param batchRequest 批量请求的对象
 @param responseArray 批量请求里的所有请求响应数据集合
 */
- (void)networkBatchRequest:(DYNetworkBatchRequest *)batchRequest completedByResponseArray:(NSArray<DYNetworkResponse *> *)responseArray;


@end

NS_ASSUME_NONNULL_END
