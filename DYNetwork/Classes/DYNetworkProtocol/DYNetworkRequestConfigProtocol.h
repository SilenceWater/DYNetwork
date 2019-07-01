//
//  DYNetworkRequestConfigProtocol.h
//  DYNetwork
//
//  Created by 破晓工作室 on 2019/6/25.
//

#import <Foundation/Foundation.h>
#import "DYNetworkEnumerator.h"
#import <AFNetworking/AFURLRequestSerialization.h>

NS_ASSUME_NONNULL_BEGIN

/**
 上传数据构造Block
 
 @param formData 要注入的上传信息
 */
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);

/**
 请求配置协议
 */
@protocol DYNetworkRequestConfigProtocol <NSObject>

@required

/**
 *  属于哪个服务
 *  @warning 需要注意的是若想取到这个key对应的服务，要先使用这个key配置DYNetworkConfig的setServiceObject:serviceIdentifier:。
 *  @return 服务的key （string）
 */
- (NSString *)serviceIdentifierKey;


/**
 接口地址。若设置带有http的请求地址，将会忽略DYNetworkConfig设置的url

 @return 接口地址 or 配置路径
 */
- (NSString *)requestMethodName;

/**
 检查返回数据是否正确，这样将在response里的succeed和failed 直接使用数据。

 @param responseData 返回的完整数据
 @return 是否正确
 */
- (BOOL)isCorrectWithResponseData:(id)responseData;

@optional


/**
   请求方式，默认为 DYRequestMethodPost
 */
- (DYRequestMethod)requestMethod;


/**
 请求所需要的参数

 @return 参数字典
 */
- (NSDictionary *)requestParamDictionary;


/**
 定制缓存策略，默认NSURLRequestUseProtocolCachePolicy

 @return 缓存策略
 */
- (NSURLRequestCachePolicy)cachePolicy;


/**
 请求失败之后的重试次数，默认为0
 @warning 仅限DYNetworkResponseFailureStatus 或 DYNetworkNotReachableStatus 失败状态下，起作用
 @return 重试次数
 */
- (NSUInteger)requestRetryCountWhenFailure;


/**
 请求连接的超时时间。默认15秒

 @return 超时时长
 */
- (NSTimeInterval)requestTimeoutInterval;


/**
 请求队列执行优先级
 @waring 跟NSOperation.queuePriority 对应
 @return 优先级
 */
- (DYNetworkPriorityType)networkPriorityType;

    
/**
 检查请求参数

 @param params 请求参数
 @return 是否执行请求
 */
- (BOOL)isCorrectWithRequestParams:(NSDictionary *)params;

/**
 请求的SerializerType 默认DYRequestSerializerTypeJSON, 可通过DYNetworkConfig设置默认值

 @return 服务端接受数据类型
 */
- (DYRequestSerializerType)requestSerializerType;


/**
 响应数据的responseSerializerType，默认DYResponseSerializerTypeJSON，可通过DYNetworkConfig设置默认值

 @return 服务端返回的数据类型
 */
- (DYResponseSerializerType)responseSerializerType;


- (NSSet <NSString *> *)responseAcceptableContentTypes;


/**
 当POST的内容带有文件等富文本时使用

 @return ConstructingBlock
 */
- (AFConstructingBlock)constructingBodyBlock;

/**
 处理正在执行相同方法的请求（参数可能不同），默认取消正要启动的请求DYRequestHandleSameRequestTypeCancelCurrentType

 @return 处理方式
 */
- (DYRequestHandleSameRequestType)handleSameRequestType;

/**
 很多请求都会需要相同的请求参数，可设置DYNetworkConfig的baseParamSourceBlock，这个block会返回你所设置的基础参数。默认YES

 @return 是否使用基础参数
 */
- (BOOL)useBaseRequestParamSource;

/**
 DYNetworkConfig设置过baseHTTPRequestHeadersBlock后，可通过此协议方法决定是否使用baseHTTPRequestHeaders，默认使用（YES）

 @return 是否使用baseHTTPRequestHeaders
 */
- (BOOL)useBaseHTTPRequestHeaders;

/**
 定制请求头 ###只作用于此接口

 @return 请求头数据
 */
- (NSDictionary *)customHTTPRequestHeaders;


/**
 是否启用DYNetworkConfig设定的请求验证，若设定了验证的Block，默认使用YES

 @return 是否使用基础的请求验证
 */
- (BOOL)useBaseAuthentication;


/**
 定制是否输出log日志

 @return 定制，将忽略DYNetworkConfig的enableDebug
 */
- (BOOL)enableDebugLog;



@end

NS_ASSUME_NONNULL_END
