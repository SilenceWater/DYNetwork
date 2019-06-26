//
//  DYNetworkConfig.h
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/25.
//

#import <Foundation/Foundation.h>
#import "DYNetworkServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYNetworkConfig : NSObject

/**
 网络接口配置单例
 */
+ (DYNetworkConfig *)sharedInstance;

/*! 是否打开debug日志 */
@property (nonatomic, assign) BOOL enableDebug;

/**
 获取网络接口不同服务配置对象

 @param serviceIdentifier 服务配置对象的存储标示
 @return 网络接口不同服务配置对象
 */
- (NSObject<DYNetworkServiceProtocol> *)serviceObjectWithServiceIdentifier:(NSString *)serviceIdentifier;

/**
 设置网络接口所需的服务配置对象

 @param serviceObject 服务配置对象
 @param serviceIdentifier 服务配置对象的存储标示
 */
- (void)registerServiceObject:(NSObject<DYNetworkServiceProtocol> *)serviceObject serviceIdentifier:(NSString *)serviceIdentifier;


@end

NS_ASSUME_NONNULL_END
