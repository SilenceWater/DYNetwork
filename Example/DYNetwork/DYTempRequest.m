//
//  DYTempRequest.m
//  DYNetwork_Example
//
//  Created by 破晓工作室 on 2019/6/25.
//  Copyright © 2019 昌. All rights reserved.
//

#import "DYTempRequest.h"

@interface DYTempRequest () <DYNetworkRequestConfigProtocol>

@end

@implementation DYTempRequest

- (NSString *)serviceIdentifierKey {
    return @"com.dy.dev.service.identifier";
}

- (NSString *)requestMethodName {
    return @"Service/CustomerLogin";
    return @"http://r.qzone.qq.com/";
}

- (BOOL)isCorrectWithResponseData:(nonnull id)responseData {
    if (responseData) {
        return YES;
    }
    return NO;
}


/**
 请求方式，默认为 DYRequestMethodPost
 */
- (DYRequestMethod)requestMethod {
    return DYRequestMethodPost;
}

/**
 请求所需要的参数
 
 @return 参数字典
 */
- (NSDictionary *)requestParamDictionary {
//    return nil;
    return @{
             @"CellPhoneNumber" : self.CellPhoneNumber ?: @"",
             @"Password" : self.Password ?: @""
             };
}

/**
 定制缓存策略，默认NSURLRequestUseProtocolCachePolicy
 
 @return 缓存策略
 */
- (NSURLRequestCachePolicy)cachePolicy {
    return NSURLRequestUseProtocolCachePolicy;
}

/**
 请求失败之后的重试次数，默认为0
 @warning 仅限DYNetworkResponseFailureStatus 或 DYNetworkNotReachableStatus 失败状态下，起作用
 @return 重试次数
 */
- (NSUInteger)requestRetryCountWhenFailure {
    return 0;
}

/**
 请求连接的超时时间。默认15秒
 
 @return 超时时长
 */
- (NSTimeInterval)requestTimeoutInterval {
    return 3;
}


- (BOOL)isCorrectWithRequestParams:(NSDictionary *)params {
    return YES;
}

- (BOOL)enableDebugLog {
    return YES;
}

- (DYNetworkPriorityType)networkPriorityType {
    
    DYNetworkPriorityType type = (DYNetworkPriorityType)[@[@(DYNetworkPriorityTypeVeryHigh),@(DYNetworkPriorityTypeVeryLow),@(DYNetworkPriorityTypeDefaultLow),@(DYNetworkPriorityTypeDefaultHigh),@(DYNetworkPriorityTypeDefaultNormal)][arc4random()%5] intValue];
    return type;
}

- (DYRequestHandleSameRequestType)handleSameRequestType {
    return DYRequestHandleSameRequestTypeBothContinue;
}

@end
