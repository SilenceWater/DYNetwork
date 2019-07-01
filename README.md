# DYNetwork

[![CI Status](https://img.shields.io/travis/昌/DYNetwork.svg?style=flat)](https://travis-ci.org/昌/DYNetwork)
[![Version](https://img.shields.io/cocoapods/v/DYNetwork.svg?style=flat)](https://cocoapods.org/pods/DYNetwork)
[![License](https://img.shields.io/cocoapods/l/DYNetwork.svg?style=flat)](https://cocoapods.org/pods/DYNetwork)
[![Platform](https://img.shields.io/cocoapods/p/DYNetwork.svg?style=flat)](https://cocoapods.org/pods/DYNetwork)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

此库是对AFNetworking的二次封装，属于离散式接口封装。
若您对此类库问题有什么看法或建议，欢迎您的反馈！
#### 1、服务对象配置
创建配置服务对象DYNetworkServiceProtocol
DYNetwork可配置不同服务环境的请求。这需要针对不同服务创建出不同的服务配置对象。

此服务配置对象需要实现协议DYNetworkServiceProtocol
```
@required

/**
 服务接口地址的基础URL
 
 @return 接口基础地址
 */
- (NSString *)serviceApiBaseUrlString;


/**
 服务接口 Acceptable-Content 配置
 
 @return Acceptable-Content Types;
 */
- (NSSet<NSString *> *)serviceResponseAcceptableContentTypes;

@optional

/**
 默认DYRequestSerializerTypeHTTP

 @return [AFHTTPRequestSerializer serializer]
 */
- (DYRequestSerializerType)serviceRequestSerializerType;


/**
 默认DYResponseSerializerTypeJSON

 @return [AFJSONResponseSerializer serializer]
 */
- (DYResponseSerializerType)serviceResponseSerializerType;


/**
 返回需要统一设定的请求头

 @return 请求头的字典
 */
- (NSDictionary<NSString *,NSString *> *)serviceBaseHTTPRequestHeaders;


/**
 基本的请求参数，在较多接口都会使用到的参数，这些参数可以作为base参数设定，比如用户名、app标示、版本 等等

 @return “基本”参数字典
 */
- (NSDictionary<NSString *,NSString *> *)serviceBaseParamSource;

/**
 针对特定服务的请求响应数据的统一验证。将影响响应数据的状态
 
 @param networkRequest 网络接口请求对象
 @param response 网络接口响应数据
 @return 验证结果状态
 */
- (DYServiceAuthenticationStatus)serviceBaseAuthenticationWithNetworkRequest:(DYNetworkRequest *)networkRequest response:(id)response;


/**
 请求失败之后的重试次数，最大设置为3次，默认为0
 @warning 仅限DYNetworkResponseFailureStatus 或 DYNetworkNotReachableStatus 失败状态下，起作用
 @return 重试次数
 */
- (NSUInteger)serviceRequestRetryCountWhenFailure;


/**
 请求超时时间，默认15秒

 @return 服务的请求超时时间
 */
- (NSTimeInterval)serviceRequestTimeoutInterval;

/*******以下协议的设定用于服务端返回数据的第一层格式统一，设定后，便于更深一层的取到数据 *********/


/**
 响应数据提示信息的key
 
 @return message key
 */
- (NSString *)responseMessageKey;


/**
 响应数据定制code的key
 
 @return code key
 */
- (NSString *)responseCodeKey;


/**
 响应数据具体内容的key
 
 @return content key
 */
- (NSString *)responseContentDataKey;

```

##### 统一设定请求头(部分)参数

```
- (NSDictionary<NSString *,NSString *> *)serviceBaseHTTPRequestHeaders {
    return @{
             @"system" : @"iOS 10.0",
             @"version" : @"1.0.0",
             @"time" : @"2016-06-04 14:18:05",
             @"token" : @"8046DB4D7844617E0F9EC72A46CE4317",
             };
};
```
一旦设定有值，默认每个请求都会合并使用这个请求头参数，你可通过 DYNetworkRequestConfigProtocol 中的 useBaseHTTPRequestHeaders 方法来决定单个的请求是否使用。 你也可以通过 DYNetworkRequestConfigProtocol 中的 customHTTPRequestHeaders 来定制单个请求的请求头。最终的请求头将会合并你所设定的值。
```
- (NSDictionary<NSString *,NSString *> *)serviceBaseParamSource{
    //根据自己的接口中大部分接口所必须的参数，进行统一设定
    return @{
             @"username" : @"001",
             @"password" : @"123"
             };
};
```

一旦设定有值，默认每个请求都会合并使用这个基础请求参数，你可以通过 DYNetworkRequestConfigProtocol 中的 useBaseRequestParamSource 方法来决定是否合并使用这里设定的基础参数。

```
- (BOOL)serviceBaseAuthenticationWithNetworkRequest:(DYNetworkRequest *)networkRequest response:(id)response{
    //可根据networkRequest、response进行验证。这里书写你的验证逻辑标准。
    if(response[@"sign"] == nil) {
        return NO;
    }
    return YES;
};
```

一旦设定有值，默认每个请求都会使用这个 Block 里的方法去验证请求到的数据，你可以通过 DYNetworkRequestConfigProtocol 中的 useBaseAuthentication 方法来决定是否使用这个验证方法。

设定返回数据第一层对应的key字段
比如服务端返回的数据：
```
{
"code" : "100",
"msg" : "请求成功",
"data" : [
			{"name" : "Paul","age" : "28"},
			{"name" : "James","age" : "27"}
		]
}
```
```
- (NSString *)responseMessageKey {
    return @"msg";
}
- (NSString *)responseCodeKey {
    return @"code";
}
- (NSString *)responseContentDataKey {
    return @"data";
}
```
这样设定之后，你就可以通过 DYNetworkResponse 对象直接拿到你想要的数据（responseContentData、responseCode、responseMessage）。

请根据自己需求灵活运用这些服务的配置，你可以在 didFinishLaunchingWithOptions 中设置你的服务配置


## Installation

DYNetwork is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DYNetwork'
```

## Author

昌, dyzhcs

## License

DYNetwork is available under the MIT license. See the LICENSE file for more info.
