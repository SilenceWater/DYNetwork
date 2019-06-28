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
    
    NSArray *tempArr = [self.requestArray sortedArrayUsingComparator:^NSComparisonResult(DYNetworkRequest * _Nonnull obj1, DYNetworkRequest * _Nonnull obj2) {
        if ((int)obj1.priorityType > (int)obj2.priorityType) {
            return NSOrderedAscending;
        }else if ((int)obj1.priorityType == (int)obj2.priorityType) {
            return NSOrderedSame;
        }
        return NSOrderedDescending;
    }];
    
//    NSSortDescriptor *priorityTypes = [NSSortDescriptor sortDescriptorWithKey:@"priorityType" ascending:NO];
//    NSArray *arr = [self.requestArray sortedArrayUsingDescriptors:@[priorityTypes]];
    
    self.requestArray = tempArr;
    
    if (_sema == nil) {
        _sema = dispatch_semaphore_create(self.maxConcurrentCount);
    }
    
    [self.requestArray enumerateObjectsUsingBlock:^(DYNetworkRequest * _Nonnull networkRequest, NSUInteger idx, BOOL * _Nonnull stop) {
        networkRequest.responseDelegate = self;
        networkRequest.containerClass = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[DYNetworkManager sharedInstance] addRequest:networkRequest];
            dispatch_semaphore_signal(self -> _sema);
        });
        
        dispatch_semaphore_wait(self-> _sema, DISPATCH_TIME_FOREVER);
    }];
    
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
