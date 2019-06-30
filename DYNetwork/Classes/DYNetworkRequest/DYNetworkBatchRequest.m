//
//  DYNetworkBatchRequest.m
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/26.
//

#import "DYNetworkBatchRequest.h"
#import "DYNetworkResponseProtocol.h"
#import "DYNetworkRequest.h"
#import "DYNetworkManager.h"
#import "DYNetworkResponse.h"

@interface DYNetworkBatchRequest ()<DYNetworkResponseProtocol>

@property (nonatomic) NSInteger completedCount;
@property (nonatomic, strong) NSArray<DYNetworkRequest *> *requestArray;
@property (nonatomic, strong) NSMutableArray<DYNetworkResponse *> *responseArray;
@property (nonatomic, strong) NSMutableArray *accessoryArray;

@end

@implementation DYNetworkBatchRequest {
    dispatch_semaphore_t _sema;
}

- (instancetype)initWithRequestArray:(NSArray<DYNetworkRequest *> *)requestArray {
    self = [super init];
    if (self) {
        _maxConcurrentCount = 3;
        _requestArray = requestArray;
        _responseArray = [NSMutableArray array];
        _completedCount = -1;
    }
    return self;
}

- (void)startBatchRequest {
    if (self.completedCount > -1 ) {
        NSLog(@"\n\n\n🐷🐷🐷 ->批量请求正在进行，请勿重复启动!<- 🐷🐷🐷\n\n\n");
        return;
    }
    [self accessoryWillStart];
    
    _completedCount = 0;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = self.maxConcurrentCount
    for (DYNetworkRequest * _Nonnull networkRequest in self.requestArray) {
        networkRequest.responseDelegate = self;
        networkRequest.containerClass = self;
        NSOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            [[DYNetworkManager sharedInstance] addRequest:networkRequest];
        }];
        switch (networkRequest.priorityType) {
                case DYNetworkPriorityTypeVeryHigh:
                op.queuePriority = NSOperationQueuePriorityVeryHigh;
                break;
                case DYNetworkPriorityTypeDefaultHigh:
                op.queuePriority = NSOperationQueuePriorityHigh;
                break;
                case DYNetworkPriorityTypeDefaultLow:
                op.queuePriority = NSOperationQueuePriorityLow;
                break;
                case DYNetworkPriorityTypeVeryLow:
                op.queuePriority = NSOperationQueuePriorityVeryLow;
                break;
            default:
                op.queuePriority = NSOperationQueuePriorityNormal;
                break;
        }
        [queue addOperation:op];
    }
    
    [self accessoryDidStart];
}


- (void)stopBatchRequest {
    _delegate = nil;
    for (DYNetworkRequest *networkRequest in self.requestArray) {
        [[DYNetworkManager sharedInstance] removeRequest:networkRequest];
    }
}

#pragma mark -
#pragma mark - DYNetworkAccessoryProtocol

- (void)addNetworkAccessoryObject:(id<DYNetworkAccessoryProtocol>)accessoryDelegate {
    if (!accessoryDelegate) return;
    if (!_accessoryArray) {
        _accessoryArray = [[NSMutableArray alloc]init];
    }
    [_accessoryArray addObject:accessoryDelegate];
}

- (void)accessoryWillStart {
    for (id<DYNetworkAccessoryProtocol>accessory in self.accessoryArray) {
        if ([accessory respondsToSelector:@selector(networkRequestAccessoryWillStart)]) {
            [accessory networkRequestAccessoryWillStart];
        }
    }
}

- (void)accessoryDidStart {
    for (id<DYNetworkAccessoryProtocol>accessory in self.accessoryArray) {
        if ([accessory respondsToSelector:@selector(networkRequestAccessoryDidStart)]) {
            [accessory networkRequestAccessoryDidStart];
        }
    }
}

- (void)accessoryFinish {
    for (id<DYNetworkAccessoryProtocol>accessory in self.accessoryArray) {
        if ([accessory respondsToSelector:@selector(networkRequestAccessoryDidFinish)]) {
            [accessory networkRequestAccessoryDidFinish];
        }
    }
}

- (void)accessoryFinishByResponse:(DYNetworkResponse *)response {
    for (id<DYNetworkAccessoryProtocol>accessory in self.accessoryArray) {
        if ([accessory respondsToSelector:@selector(networkRequestAccessoryByStatus:)]) {
            [accessory networkRequestAccessoryByStatus:response.networkStatus];
        }
        
        if ([accessory respondsToSelector:@selector(networkRequestAccessoryDidEndByResponse:)]) {
            [accessory networkRequestAccessoryDidEndByResponse:response];
        }
    }
}

#pragma mark-
#pragma mark-DYNetworkResponseProtocol

- (void)networkRequest:(DYNetworkRequest *)networkRequest succeedByResponse:(DYNetworkResponse *)response {
    self.completedCount++;
    [self.responseArray addObject:response];
    if (self.completedCount == self.requestArray.count) {
        [self networkBatchRequestCompleted];
    }
}

- (void)networkRequest:(DYNetworkRequest *)networkRequest failedByResponse:(DYNetworkResponse *)response {
    self.completedCount++;
    [self.responseArray addObject:response];
    
    if (self.completedCount == self.requestArray.count) {
        [self networkBatchRequestCompleted];
    }
}

- (void)networkBatchRequestCompleted {
    
    if ([self.delegate respondsToSelector:@selector(networkBatchRequest:completedByResponseArray:)]) {
        [self.delegate networkBatchRequest:self completedByResponseArray:self.responseArray];
    }
    self.completedCount = -1;
    [self accessoryFinish];
}

- (void)dealloc {
//    for (DYNetworkRequest *networkRequest in self.requestArray) {
//        [[DYNetworkManager sharedInstance] removeRequest:networkRequest];
//    }
    [self accessoryFinish];
}


@end
