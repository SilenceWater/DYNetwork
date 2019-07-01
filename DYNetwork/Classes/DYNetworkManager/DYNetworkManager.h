//
//  DYNetworkManager.h
//  DYNetwork
//
//  Created by 破晓工作室 on 2019/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DYNetworkRequest;
/**
 管理请求类
 */
@interface DYNetworkManager : NSObject

+ (instancetype)sharedInstance;

/**
 添加request到请求栈中，并启动

 @param request 一个基于DYNetworkRequest的实例
 */
- (void)addRequest:(__kindof DYNetworkRequest *)request;

/**
 结束一个请求，并从请求栈中移除

 @param request 一个基于DYNetworkRequest的实例
 */
- (void)removeRequest:(__kindof DYNetworkRequest *)request;



@end

NS_ASSUME_NONNULL_END
