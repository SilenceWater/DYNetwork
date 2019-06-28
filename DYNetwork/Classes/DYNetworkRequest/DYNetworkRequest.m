//
//  DYNetworkRequest.m
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/25.
//

#import "DYNetworkRequest.h"
#import "DYNetworkManager.h"
#import "DYNetworkResponse.h"

@interface DYNetworkRequest ()

@property (nonatomic, weak) id <DYNetworkRequestConfigProtocol> requestConfigProtocol;

@property (nonatomic, strong) NSMutableArray *accessoryArray;

@property (nonatomic, assign) DYNetworkPriorityType priorityType;

@end

@implementation DYNetworkRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(DYNetworkRequestConfigProtocol)]) {
            _requestConfigProtocol = (id <DYNetworkRequestConfigProtocol>)self;
        } else {
            NSAssert(NO, @"子类必须实现DYNetworkRequestConfigProtocol协议");
        }
    }
    return self;
}

- (DYNetworkPriorityType)priorityType {
    if (!_priorityType) {
        if ([self.requestConfigProtocol respondsToSelector:@selector(networkPriorityType)]) {
            _priorityType = [self.requestConfigProtocol networkPriorityType];
        }else {
            _priorityType = DYNetworkPriorityTypeDefaultNormal;
        }
    }
    return _priorityType;
}

- (void)startRequest {
    [self accessoryWillStart];
    [[DYNetworkManager sharedInstance] addRequest:self];
    [self accessoryDidStart];
}


- (void)stopRequestByStatus:(DYNetworkStatus)status {
    [[DYNetworkManager sharedInstance] removeRequest:self];
    DYNetworkResponse *cancelResponse = [[DYNetworkResponse alloc] initWithResponseData:nil serviceIdentifierKey:nil requestTag:self.tag networkStatus:DYNetworkRequestCancelStatus];
    [self accessoryFinishByResponse:cancelResponse];
}

- (void)stopRequestByResponse:(DYNetworkResponse *)response {
    [[DYNetworkManager sharedInstance] removeRequest:self];
    [self accessoryFinishByResponse:response];
}

- (void)dealloc {
    if (self.containerClass) {
        _containerClass = nil;
    }
    [[DYNetworkManager sharedInstance] removeRequest:self];
}

#pragma mark-
#pragma mark-Accessory

- (void)addNetworkAccessoryObject:(id <DYNetworkAccessoryProtocol>)accessoryDelegate {
    if (accessoryDelegate == nil)  return;
    
    if (_accessoryArray == nil) {
        _accessoryArray = [NSMutableArray array];
    }
    [self.accessoryArray addObject:accessoryDelegate];
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


- (void)accessoryFinishByResponse:(DYNetworkResponse *)response {
    for (id<DYNetworkAccessoryProtocol>accessory in self.accessoryArray) {
        
        if ([accessory respondsToSelector:@selector(networkRequestAccessoryDidFinish)]) {
            [accessory networkRequestAccessoryDidFinish];
        }
        
        if ([accessory respondsToSelector:@selector(networkRequestAccessoryByStatus:)]) {
            [accessory networkRequestAccessoryByStatus:response.networkStatus];
        }
        
        if ([accessory respondsToSelector:@selector(networkRequestAccessoryDidEndByResponse:)]) {
            [accessory networkRequestAccessoryDidEndByResponse:response];
        }
    }
}

@end
