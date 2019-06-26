//
//  DYNetworkResponse.h
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/25.
//

#import <Foundation/Foundation.h>
#import "DYNetworkEnumerator.h"

//NS_ASSUME_NONNULL_BEGIN

@interface DYNetworkResponse : NSObject

/*! 请求得到的全部数据 */
@property (nonatomic, copy, readonly) id responseData;

/*! 网络接口状态 */
@property (nonatomic, assign, readonly) DYNetworkStatus networkStatus;

/*! 网络接口请求的tag */
@property (nonatomic, assign, readonly) NSInteger requestTag;

/**
 初始化网络接口响应对象
 
 @param responseData 响应的原始数据
 @param serviceIdentifierKey 服务配置对象的存储标示
 @param requestTag 网络接口请求的tag
 @param networkStatus 网络接口的状态
 @return 网络接口响应对象
 */
- (instancetype)initWithResponseData:(id)responseData
                serviceIdentifierKey:(NSString *)serviceIdentifierKey
                          requestTag:(NSInteger)requestTag
                       networkStatus:(DYNetworkStatus)networkStatus;


/***  以下属性取决于你服务端返回的数据格式，以及对应Service对象是否设定了对应属性值的key值  ***/

/*! 请求无网、失败、参数错误、验证失败的情况，此属性都有值 */
@property (nonatomic, copy, readonly) NSString *responseMessage;

/*! 响应数据的具体内容 */
@property (nonatomic, copy, readonly) id responseContentData;

/*! 响应数据的定制code值 */
@property (nonatomic, assign, readonly) NSInteger responseCode;





@end




//NS_ASSUME_NONNULL_END
