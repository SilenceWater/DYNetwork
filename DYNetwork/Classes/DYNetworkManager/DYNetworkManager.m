//
//  DYNetworkManager.m
//  DYNetwork
//
//  Created by 破晓工作室 on 2019/6/25.
//

#import "DYNetworkManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking/AFNetworking.h>
#import "DYNetworkConfig.h"
#import "DYNetworkRequest.h"
#import "DYNetworkResponse.h"
#import "DYNetworkLogger.h"

@interface DYNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableDictionary <NSString *, __kindof DYNetworkRequest *> *requestRecordDict;

@property (nonatomic, strong) NSMutableArray <NSString *> *historyCustomHeaderKeys;

@end

@implementation DYNetworkManager

#pragma mark -
#pragma mark - Initialize

+ (DYNetworkManager *)sharedInstance {
    static DYNetworkManager *networkAgentInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkAgentInstance = [[self alloc] init];
    });
    return networkAgentInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestRecordDict = [NSMutableDictionary dictionary];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 4;
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        jsonResponseSerializer.removesKeysWithNullValues = YES;
        _sessionManager.responseSerializer = jsonResponseSerializer;
    }
    return _sessionManager;
}


#pragma mark -
#pragma mark - Methods

- (void)addRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    
    if ([_requestRecordDict.allValues containsObject:request]) {
        NSLog(@"\n\n\n------------- 重复启动请求！相同的请求正在执行中 -----------");
        return;
    }
    
    
    NSString *requestURLString = [self urlStringByRequest:request];
    NSDictionary *requestParam = [self requestParamByRequest:request];
    
    //检查参数配置
    if (![self isCorrectByRequestParams:requestParam request:request]) {
        NSLog(@"参数配置有误！请查看isCorrectWithRequestParams: !");
        DYNetworkResponse *paramIncorrectResponse = [[DYNetworkResponse alloc] initWithResponseData:nil serviceIdentifierKey:nil requestTag:request.tag networkStatus:DYNetworkRequestParamIncorrectStatus];
        [request stopRequestByResponse:paramIncorrectResponse];
        if ([request.responseDelegate respondsToSelector:@selector(networkRequest:failedByResponse:)]) {
            [request.responseDelegate networkRequest:request failedByResponse:paramIncorrectResponse];
        }
        return;
    }
    
    DYRequestHandleSameRequestType handleSameRequestType = [self handleSameRequestTypeByRequest:request];
    if (handleSameRequestType != DYRequestHandleSameRequestTypeBothContinue) {
        //检查是否存在相同请求方法未完成，并根据协议接口决定是否结束之前的请求
        BOOL isContinuePerform = YES;
        for (DYNetworkRequest<DYNetworkRequestConfigProtocol> *requestingObj in self.requestRecordDict.allValues) {
            if ([[self urlStringByRequest:requestingObj] isEqualToString:requestURLString]) {
                switch (handleSameRequestType) {
                    case DYRequestHandleSameRequestTypeCancelCurrent:
                        isContinuePerform = NO;
                        break;
                    case DYRequestHandleSameRequestTypeCancelPrevious:{
                        DYNetworkResponse *cancelResponse = [[DYNetworkResponse alloc] initWithResponseData:nil serviceIdentifierKey:nil requestTag:requestingObj.tag networkStatus:DYNetworkRequestCancelStatus];
                        [requestingObj stopRequestByResponse:cancelResponse];
                    }
                        break;
                    default:
                        break;
                }
                break;
            }
        }
        
        if (isContinuePerform == NO) {
            NSLog(@"\n\n---------------------有个相同URL请求未完成，这个请求被取消了（可设置handleSameRequestType）---------------------\n\n");
            DYNetworkResponse *cancelResponse = [[DYNetworkResponse alloc] initWithResponseData:nil serviceIdentifierKey:nil requestTag:request.tag networkStatus:DYNetworkRequestCancelStatus];
            [request stopRequestByResponse:cancelResponse];
            return;
        }
    }
    
    if ([request respondsToSelector:@selector(enableDebugLog)]) {
        if ([request enableDebugLog]) {
            [DYNetworkLogger logDebugRequestInfoWithURL:requestURLString httpMethod:[self requestMethodByRequest:request] params:requestParam reachabilityStatus:[[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] networkPriority:request.priorityType];
        }
    }else if ([DYNetworkConfig sharedInstance].enableDebug) {
        [DYNetworkLogger logDebugRequestInfoWithURL:requestURLString httpMethod:[self requestMethodByRequest:request] params:requestParam reachabilityStatus:[[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] networkPriority:request.priorityType];
    }
    
    [self setupSessionManagerRequestSerializerByRequest:request];
    
    __weak typeof(self)weakSelf = self;
    __block DYNetworkRequest<DYNetworkRequestConfigProtocol> *blockRequest = request;
    switch ([self requestMethodByRequest:request]) {
        case DYRequestMethodGet:{
            request.sessionDataTask = [self.sessionManager GET:requestURLString
                                                    parameters:requestParam
                                                      progress:^(NSProgress * _Nonnull downloadProgress) {
                                                          [weakSelf handleRequestProgress:downloadProgress request:blockRequest];
                                                      }
                                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                           [weakSelf handleRequestSuccess:task responseObject:responseObject];
                                                       }
                                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                           [weakSelf handleRequestFailure:task error:error];
                                                       }];
        }
            break;
        case DYRequestMethodPost:{
            AFConstructingBlock constructingBlock = [self constructingBlockByRequest:request];
            if (constructingBlock) {
                request.sessionDataTask = [self.sessionManager POST:requestURLString
                                                         parameters:requestParam
                                          constructingBodyWithBlock:constructingBlock
                                                           progress:^(NSProgress * _Nonnull uploadProgress) {
                                                               [weakSelf handleRequestProgress:uploadProgress request:blockRequest];
                                                           }
                                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                [weakSelf handleRequestSuccess:task responseObject:responseObject];
                                                            }
                                                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                                [weakSelf handleRequestFailure:task error:error];
                                                            }];
            }else{
                request.sessionDataTask = [self.sessionManager POST:requestURLString
                                                         parameters:requestParam
                                                           progress:^(NSProgress * _Nonnull uploadProgress) {
                                                               [weakSelf handleRequestProgress:uploadProgress request:blockRequest];
                                                           }
                                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                [weakSelf handleRequestSuccess:task responseObject:responseObject];
                                                            }
                                                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                                [weakSelf handleRequestFailure:task error:error];
                                                            }];
            }
        }
            break;
        default:
            break;
    }
    [self addRequestObject:request];
    
}

- (void)removeRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    if(request.sessionDataTask == nil)  return;
    
    [request.sessionDataTask cancel];
    NSString *taskKey = [self keyForSessionDataTask:request.sessionDataTask];
    @synchronized(self) {
        [_requestRecordDict removeObjectForKey:taskKey];
    }
}

#pragma makr -
#pragma makr - BathRequest


#pragma mark -
#pragma mark - Getter

- (NSObject<DYNetworkServiceProtocol> *)serviceObjectByRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    NSString *serviceKey = [request.requestConfigProtocol serviceIdentifierKey];
    NSAssert(serviceKey.length, @"你应该设置服务标示的key");
    NSObject<DYNetworkServiceProtocol> *serviceObject = [[DYNetworkConfig sharedInstance] serviceObjectWithServiceIdentifier:serviceKey];
    return serviceObject;
}

- (NSString *)urlStringByRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    NSString *detailUrl = @"";
    if ([request.requestConfigProtocol respondsToSelector:@selector(requestMethodName)]) {
        detailUrl = [request.requestConfigProtocol requestMethodName];
    }
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    
    NSString *serviceURLString = nil;
    
    serviceURLString = [[self serviceObjectByRequest:request] serviceApiBaseUrlString];
    if ([serviceURLString hasPrefix:@"http"]) {
        return [serviceURLString stringByAppendingPathComponent:detailUrl];
    }else {
        NSLog(@"\n\n\n请设置正确的URL\n\n\n");
        return nil;
    }
}

- (NSDictionary *)requestParamByRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    if ([request.requestConfigProtocol respondsToSelector:@selector(requestParamDictionary)]) {
        NSDictionary *paramDict = [request.requestConfigProtocol requestParamDictionary];
        if (paramDict != nil) {
            [tempDict addEntriesFromDictionary:paramDict];
        }
    }
    
    if ((![request.requestConfigProtocol respondsToSelector:@selector(useBaseRequestParamSource)] || [request.requestConfigProtocol useBaseRequestParamSource])) {
        NSObject<DYNetworkServiceProtocol> *serviceObject = [self serviceObjectByRequest:request];
        if ([serviceObject respondsToSelector:@selector(serviceBaseParamSource)]) {
            NSDictionary *baseRequestParamSource = [serviceObject serviceBaseParamSource];
            if (baseRequestParamSource != nil) {
                [tempDict addEntriesFromDictionary:baseRequestParamSource];
            }
        }
    }
    if (tempDict.count == 0) {
        return nil;
    }
    return [NSDictionary dictionaryWithDictionary:tempDict];
}

- (BOOL)isCorrectByRequestParams:(NSDictionary *)requestParams request:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    if ([request.requestConfigProtocol respondsToSelector:@selector(isCorrectWithRequestParams:)]) {
        return [request.requestConfigProtocol isCorrectWithRequestParams:requestParams];
    }
    return YES;
}

- (DYRequestHandleSameRequestType)handleSameRequestTypeByRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    if ([request.requestConfigProtocol respondsToSelector:@selector(handleSameRequestType)]) {
        return [request.requestConfigProtocol handleSameRequestType];
    }
    return DYRequestHandleSameRequestTypeCancelCurrent;
}

- (DYRequestMethod)requestMethodByRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    if ([request.requestConfigProtocol respondsToSelector:@selector(requestMethod)]) {
        return [request.requestConfigProtocol requestMethod];
    }
    return DYRequestMethodPost;
}

- (NSURLRequestCachePolicy)cachePolicyByRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    if ([request.requestConfigProtocol respondsToSelector:@selector(cachePolicy)]) {
        NSURLRequestCachePolicy cachePolicy = [request.requestConfigProtocol cachePolicy];
        if (cachePolicy == NSURLRequestUseProtocolCachePolicy) {
            if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
                return NSURLRequestReturnCacheDataDontLoad;
            }
            return NSURLRequestUseProtocolCachePolicy;
        }
        return cachePolicy;
    }
    return NSURLRequestReloadIgnoringCacheData;
}

#pragma mark -
#pragma mark - Setter

- (void)setSessionManagerRequestSerializerByRequestSerializerType:(DYRequestSerializerType)requestSerializerType {
    switch (requestSerializerType) {
        case DYRequestSerializerTypeHTTP:
            self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case DYRequestSerializerTypeJSON:
            if (![self.sessionManager.requestSerializer isKindOfClass:[AFJSONRequestSerializer class]]) {
                self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
            }
            break;
        case DYRequestSerializerTypePropertyList:
            if (![self.sessionManager.requestSerializer isKindOfClass:[AFPropertyListRequestSerializer class]]) {
                self.sessionManager.requestSerializer = [AFPropertyListRequestSerializer serializer];
            }
            break;
        default:
            break;
    }
}

- (void)setSessionManagerResponseSerializerByResponseSerializerType:(DYResponseSerializerType)responseSerializerType {
    switch (responseSerializerType) {
        case DYResponseSerializerTypeHTTP:
            self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case DYResponseSerializerTypeJSON:
            if (![self.sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
                AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
                jsonResponseSerializer.removesKeysWithNullValues = YES;
                self.sessionManager.responseSerializer = jsonResponseSerializer;
            }
            break;
        case DYResponseSerializerTypeImage:
            if (![self.sessionManager.responseSerializer isKindOfClass:[AFImageResponseSerializer class]]) {
                self.sessionManager.responseSerializer = [AFImageResponseSerializer serializer];
            }
            break;
        case DYResponseSerializerTypeXMLParser:
            if (![self.sessionManager.responseSerializer isKindOfClass:[AFXMLParserResponseSerializer class]]) {
                self.sessionManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            }
            break;
        case DYResponseSerializerTypePropertyList:
            if (![self.sessionManager.responseSerializer isKindOfClass:[AFPropertyListResponseSerializer class]]) {
                self.sessionManager.responseSerializer = [AFPropertyListResponseSerializer serializer];
            }
            break;
        default:
            break;
    }
    
}

- (void)setupSessionManagerRequestSerializerByRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    //配置requestSerializerType
    NSObject<DYNetworkServiceProtocol> *serviceObject = [self serviceObjectByRequest:request];
    DYRequestSerializerType requestSerializerType;
    if ([request.requestConfigProtocol respondsToSelector:@selector(requestSerializerType)]) {
        requestSerializerType = [request.requestConfigProtocol requestSerializerType];
    }else if([serviceObject respondsToSelector:@selector(serviceRequestSerializerType)]){
        requestSerializerType = [serviceObject serviceRequestSerializerType];
    }else {
        requestSerializerType = DYRequestSerializerTypeHTTP;
    }
    [self setSessionManagerRequestSerializerByRequestSerializerType:requestSerializerType];
    
    //配置请求头
    if (self.historyCustomHeaderKeys.count) {
        [self.historyCustomHeaderKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.sessionManager.requestSerializer setValue:nil forHTTPHeaderField:obj];
        }];
        [self.historyCustomHeaderKeys removeAllObjects];
    }
    
    if ((![request.requestConfigProtocol respondsToSelector:@selector(useBaseHTTPRequestHeaders)] || [request.requestConfigProtocol useBaseHTTPRequestHeaders])) {
        if ([serviceObject respondsToSelector:@selector(serviceBaseHTTPRequestHeaders)]) {
            NSDictionary *requestHeaders = [serviceObject serviceBaseHTTPRequestHeaders];
            [requestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
            }];
        }
    }
    
    if ([request.requestConfigProtocol respondsToSelector:@selector(customHTTPRequestHeaders)]) {
        NSDictionary *customRequestHeaders = [request.requestConfigProtocol customHTTPRequestHeaders];
        if (_historyCustomHeaderKeys == nil) {
            _historyCustomHeaderKeys = [[NSMutableArray alloc] init];
        }
        [self.historyCustomHeaderKeys addObjectsFromArray:customRequestHeaders.allKeys];
        [customRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[NSString class]]) {
                [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
            }else if ([obj isKindOfClass:[NSNumber class]]) {
                [self.sessionManager.requestSerializer setValue:[(NSNumber *)obj stringValue] forHTTPHeaderField:key];
            }else {
                [self.sessionManager.requestSerializer setValue:nil forHTTPHeaderField:key];
            }
        }];
    }
    
    //配置请求超时时间
    NSTimeInterval timeoutInterval = 15.0f;
    if ([request.requestConfigProtocol respondsToSelector:@selector(requestTimeoutInterval)]) {
        timeoutInterval = [request.requestConfigProtocol requestTimeoutInterval];
    } else if ([serviceObject respondsToSelector:@selector(serviceRequestTimeoutInterval)]) {
        timeoutInterval = [serviceObject serviceRequestTimeoutInterval];
    }
    self.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
    
    //配置responseSerializerType
    DYResponseSerializerType responseSerializerType = DYResponseSerializerTypeJSON;
    if ([request.requestConfigProtocol respondsToSelector:@selector(responseSerializerType)]) {
        responseSerializerType = [request.requestConfigProtocol responseSerializerType];
    }else if ([serviceObject respondsToSelector:@selector(serviceResponseSerializerType)]){
        responseSerializerType = [serviceObject serviceResponseSerializerType];
    }
    [self setSessionManagerResponseSerializerByResponseSerializerType:responseSerializerType];
    
    if ([request.requestConfigProtocol respondsToSelector:@selector(responseAcceptableContentTypes)] && [request.requestConfigProtocol responseAcceptableContentTypes]) {
        self.sessionManager.responseSerializer.acceptableContentTypes = [request.requestConfigProtocol responseAcceptableContentTypes];
    } else {
        self.sessionManager.responseSerializer.acceptableContentTypes = [serviceObject serviceResponseAcceptableContentTypes];
    }
    
    //配置请求缓存策略
    self.sessionManager.requestSerializer.cachePolicy = [self cachePolicyByRequest:request];
}

- (AFConstructingBlock)constructingBlockByRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    if ([request.requestConfigProtocol respondsToSelector:@selector(constructingBodyBlock)]) {
        return [request.requestConfigProtocol constructingBodyBlock];
    }
    return nil;
}

- (NSUInteger)retryCountWhenFailureByRequest:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    NSObject<DYNetworkServiceProtocol> *serviceObject = [self serviceObjectByRequest:request];
    NSUInteger retryCount = 0;
    if ([request.requestConfigProtocol respondsToSelector:@selector(requestRetryCountWhenFailure)]) {
        retryCount = [request.requestConfigProtocol requestRetryCountWhenFailure];
    } else if ([serviceObject respondsToSelector:@selector(serviceRequestRetryCountWhenFailure)]) {
        retryCount = [serviceObject serviceRequestRetryCountWhenFailure];
    }
    if (retryCount > 3) {
        retryCount = 3;
    }
    return retryCount;
}

#pragma mark -
#pragma mark - 处理请求响应结果

- (void)beforePerformFailWithResponse:(DYNetworkResponse *)response request:(DYNetworkRequest *)request{
//    if ([request.interceptorDelegate respondsToSelector:@selector(networkRequest:beforePerformFailWithResponse:)]) {
//        [request.interceptorDelegate networkRequest:request beforePerformFailWithResponse:response];
//    }
}
- (void)afterPerformFailWithResponse:(DYNetworkResponse *)response request:(DYNetworkRequest *)request{
//    if ([request.interceptorDelegate respondsToSelector:@selector(networkRequest:afterPerformFailWithResponse:)]) {
//        [request.interceptorDelegate networkRequest:request afterPerformFailWithResponse:response];
//    }
}

- (void)handleRequestProgress:(NSProgress *)progress request:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    if ([request.responseDelegate respondsToSelector:@selector(networkRequest:requestingByProgress:)]) {
        [request.responseDelegate networkRequest:request requestingByProgress:progress];
    }
}

- (void)handleRequestSuccess:(NSURLSessionDataTask *)sessionDataTask responseObject:(id)response {
    NSString *taskKey = [self keyForSessionDataTask:sessionDataTask];
    DYNetworkRequest<DYNetworkRequestConfigProtocol> *request = _requestRecordDict[taskKey];
    if (request == nil){
        NSLog(@"\n\n--------------------请求实例被意外释放!--------------------\n\n");
        return;
    }
    
    request.retryCount = 0;
    
    DYServiceAuthenticationStatus authenticationStatus = DYServiceAuthenticationStatusPass;
    if ((![request.requestConfigProtocol respondsToSelector:@selector(useBaseAuthentication)] || [request.requestConfigProtocol useBaseAuthentication])) {
        NSObject<DYNetworkServiceProtocol> *serviceObject = [self serviceObjectByRequest:request];
        if ([serviceObject respondsToSelector:@selector(serviceBaseAuthenticationWithNetworkRequest:response:)]) {
            authenticationStatus = [serviceObject serviceBaseAuthenticationWithNetworkRequest:request response:response];
        }
    }
    if(authenticationStatus ==  DYServiceAuthenticationStatusPass && [request.requestConfigProtocol isCorrectWithResponseData:response]){
        DYNetworkResponse *successResponse = [[DYNetworkResponse alloc] initWithResponseData:response serviceIdentifierKey:[request serviceIdentifierKey] requestTag:request.tag networkStatus:DYNetworkResponseDataSuccessStatus];
        [request stopRequestByResponse:successResponse];

        if ([request.responseDelegate respondsToSelector:@selector(networkRequest:succeedByResponse:)]) {
            [request.responseDelegate networkRequest:request succeedByResponse:successResponse];
        }

    } else {
        DYNetworkStatus failStatus;
        switch (authenticationStatus) {
            case DYServiceAuthenticationStatusPass:
                failStatus = DYNetworkResponseDataIncorrectStatus;
                break;
            case DYServiceAuthenticationStatusWarning:
                failStatus = DYNetworkResponseDataAuthenticationFailStatus;
                break;
            default:
                failStatus = DYNetworkRequestCancelStatus;
                break;
        }
        DYNetworkResponse *dataErrorResponse = [[DYNetworkResponse alloc] initWithResponseData:response serviceIdentifierKey:[request serviceIdentifierKey] requestTag:request.tag networkStatus:failStatus];
        [request stopRequestByResponse:dataErrorResponse];
        if (authenticationStatus != DYServiceAuthenticationStatusWrong) {
            [self beforePerformFailWithResponse:dataErrorResponse request:request];
            if ([request.responseDelegate respondsToSelector:@selector(networkRequest:failedByResponse:)]) {
                [request.responseDelegate networkRequest:request failedByResponse:dataErrorResponse];
            }
            [self afterPerformFailWithResponse:dataErrorResponse request:request];
        }
    }
    
    if ([request respondsToSelector:@selector(enableDebugLog)]) {
        if ([request enableDebugLog]) {
            [DYNetworkLogger logDebugResponseInfoWithSessionDataTask:sessionDataTask responseObject:response authentication:authenticationStatus ==  DYServiceAuthenticationStatusPass error:nil];
        }
    }else if ([DYNetworkConfig sharedInstance].enableDebug) {
        [DYNetworkLogger logDebugResponseInfoWithSessionDataTask:sessionDataTask responseObject:response authentication:authenticationStatus ==  DYServiceAuthenticationStatusPass error:nil];
    }
}

- (void)handleRequestFailure:(NSURLSessionDataTask *)sessionDataTask error:(NSError *)error {
    NSString *taskKey = [self keyForSessionDataTask:sessionDataTask];
    DYNetworkRequest<DYNetworkRequestConfigProtocol> *request = _requestRecordDict[taskKey];
    if (request == nil) {
        NSLog(@"\n\n--------------------请求实例被意外释放!--------------------\n\n");
        return;
    }
    
    //请求失败时，重试
    NSUInteger retryCount = [self retryCountWhenFailureByRequest:request];
    if (request.retryCount < retryCount) {
        [self removeRequest:request];
        request.retryCount++;
        [self performSelector:@selector(addRequest:) withObject:request afterDelay:2.0f];
        return;
    }
    
    DYNetworkStatus failStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable ? DYNetworkNotReachableStatus : DYNetworkResponseFailureStatus;
    DYNetworkResponse *failureResponse = [[DYNetworkResponse alloc] initWithResponseData:nil serviceIdentifierKey:[request serviceIdentifierKey] requestTag:request.tag networkStatus:failStatus];
    [request stopRequestByResponse:failureResponse];
    [self beforePerformFailWithResponse:failureResponse request:request];
    if ([request.responseDelegate respondsToSelector:@selector(networkRequest:failedByResponse:)]) {
        [request.responseDelegate networkRequest:request failedByResponse:failureResponse];
    }
    [self afterPerformFailWithResponse:failureResponse request:request];
    
    if ([request respondsToSelector:@selector(enableDebugLog)]) {
        if ([request enableDebugLog]) {
            [DYNetworkLogger logDebugResponseInfoWithSessionDataTask:sessionDataTask responseObject:nil authentication:NO error:error];
        }
    }else if ([DYNetworkConfig sharedInstance].enableDebug) {
        [DYNetworkLogger logDebugResponseInfoWithSessionDataTask:sessionDataTask responseObject:nil authentication:NO error:error];
    }
}

#pragma mark -
#pragma mark - 处理 请求集合
- (NSString *)keyForSessionDataTask:(NSURLSessionDataTask *)sessionDataTask {
    return [@(sessionDataTask.taskIdentifier) stringValue];
}

- (void)addRequestObject:(__kindof DYNetworkRequest<DYNetworkRequestConfigProtocol> *)request {
    if (request.sessionDataTask == nil)    return;
    
    NSString *taskKey = [self keyForSessionDataTask:request.sessionDataTask];
    @synchronized(self) {
        _requestRecordDict[taskKey] = request;
    }
}



@end
