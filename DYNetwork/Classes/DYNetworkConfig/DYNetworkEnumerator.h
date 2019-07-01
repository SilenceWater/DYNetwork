//
//  DYNetworkEnumerator.h
//  DYNetwork
//
//  Created by 破晓工作室 on 2019/6/25.
//

#ifndef DYNetworkEnumerator_h
#define DYNetworkEnumerator_h

/**
 网络请求状态值

 - DYNetworkRequestCancelStatus: 请求被取消，暂不提供响应回调
 - DYNetworkNotReachableStatus: 网络不可达
 - DYNetworkRequestParamIncorrectStatus: 请求参数错误
 - DYNetworkResponseFailureStatus: 请求失败
 - DYNetworkResponseDataIncorrectStatus: 请求返回的数据错误，可能是接口错误等
 - DYNetworkResponseDataAuthenticationFailStatus: 请求返回的数据没有通过验证
 - DYNetworkResponseDataSuccessStatus: 数据请求成功
 */
typedef NS_ENUM(NSUInteger, DYNetworkStatus) {
    DYNetworkRequestCancelStatus,
    DYNetworkNotReachableStatus,
    DYNetworkRequestParamIncorrectStatus,
    DYNetworkResponseFailureStatus,
    DYNetworkResponseDataIncorrectStatus,
    DYNetworkResponseDataAuthenticationFailStatus,
    DYNetworkResponseDataSuccessStatus,
};


/**
 网络接口请求方式

 - DYRequestMethodPost: Post请求
 - DYRequestMethodGet: Get请求
 */
typedef NS_ENUM(NSUInteger, DYRequestMethod) {
    DYRequestMethodPost,
    DYRequestMethodGet,
};


/**
 请求序列化类型

 - DYRequestSerializerTypeHTTP: http
 - DYRequestSerializerTypeJSON: JSON
 - DYRequestSerializerTypePropertyList: Plist
 */
typedef NS_ENUM(NSUInteger, DYRequestSerializerType) {
    DYRequestSerializerTypeHTTP,
    DYRequestSerializerTypeJSON,
    DYRequestSerializerTypePropertyList,
};


/**
 响应数据序列化类型

 - DYResponseSerializerTypeJSON: json
 - DYResponseSerializerTypeHTTP: http
 - DYResponseSerializerTypeXMLParser: xml
 - DYResponseSerializerTypePropertyList: plist
 - DYResponseSerializerTypeImage: img
 */
typedef NS_ENUM(NSUInteger, DYResponseSerializerType) {
    DYResponseSerializerTypeJSON,
    DYResponseSerializerTypeHTTP,
    DYResponseSerializerTypeXMLParser,
    DYResponseSerializerTypePropertyList,
    DYResponseSerializerTypeImage,
};


/**
 处理正在执行的前一个相同方法的请求的方式

 - DYRequestHandleSameRequestTypeCancelCurrent: 取消正要启动的请求
 - DYRequestHandleSameRequestTypeCancelPrevious: 取消正在进行的请求
 - DYRequestHandleSameRequestTypeBothContinue: 不取消请求，请求同时执行
 */
typedef NS_ENUM(NSUInteger, DYRequestHandleSameRequestType) {
    DYRequestHandleSameRequestTypeCancelCurrent,
    DYRequestHandleSameRequestTypeCancelPrevious,
    DYRequestHandleSameRequestTypeBothContinue,
};


/**
 服务的验证结果状态
 
 - DYServiceAuthenticationStatusPass: 通过
 - DYServiceAuthenticationStatusWarning: 警告
 - DYServiceAuthenticationStatusWrong: 错误
 */
typedef NS_ENUM(NSInteger , DYServiceAuthenticationStatus) {
    DYServiceAuthenticationStatusPass = 0,
    DYServiceAuthenticationStatusWarning,
    DYServiceAuthenticationStatusWrong
};



/**
 队列处理优先级
 
 - DYNetworkPriorityTypeVeryHigh:      非常高
 - DYNetworkPriorityTypeDefaultHigh:   高
 - DYNetworkPriorityTypeDefaultNormal: 正常
 - DYNetworkPriorityTypeDefaultLow:    低
 - DYNetworkPriorityTypeVeryLow:       非常低
 */
typedef int  DYNetworkPriorityType NS_TYPED_EXTENSIBLE_ENUM;
static const DYNetworkPriorityType DYNetworkPriorityTypeVeryHigh      NS_AVAILABLE_IOS(10_0) = 1000;
static const DYNetworkPriorityType DYNetworkPriorityTypeDefaultHigh   NS_AVAILABLE_IOS(10_0) = 750;
static const DYNetworkPriorityType DYNetworkPriorityTypeDefaultNormal NS_AVAILABLE_IOS(10_0) = 500;
static const DYNetworkPriorityType DYNetworkPriorityTypeDefaultLow    NS_AVAILABLE_IOS(10_0) = 250;
static const DYNetworkPriorityType DYNetworkPriorityTypeVeryLow       NS_AVAILABLE_IOS(10_0) = 50;

#endif /* DYNetworkEnumerator_h */
