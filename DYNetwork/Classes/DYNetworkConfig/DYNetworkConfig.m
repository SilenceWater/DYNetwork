//
//  DYNetworkConfig.m
//  DYNetwork
//
//  Created by 德一智慧城市 on 2019/6/25.
//

#import "DYNetworkConfig.h"

@interface DYNetworkConfig ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSObject<DYNetworkServiceProtocol> *> *serviceStorageDictionary;

@end

@implementation DYNetworkConfig

+ (DYNetworkConfig *)sharedInstance {
    static DYNetworkConfig *networkConfigInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkConfigInstance = [[DYNetworkConfig alloc] init];
    });
    return networkConfigInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enableDebug = NO;
    }
    return self;
}

- (NSMutableDictionary<NSString *, NSObject<DYNetworkServiceProtocol> *> *)serviceStorageDictionary {
    if (_serviceStorageDictionary == nil) {
        _serviceStorageDictionary = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorageDictionary;
}

- (NSObject<DYNetworkServiceProtocol> *)serviceObjectWithServiceIdentifier:(NSString *)serviceIdentifier {
    if (self.serviceStorageDictionary[serviceIdentifier] == nil) {
        NSAssert(NO, @"无法找到 %@ 相匹配的服务对象", serviceIdentifier);
        return nil;
    }
    return self.serviceStorageDictionary[serviceIdentifier];
}

- (void)registerServiceObject:(NSObject<DYNetworkServiceProtocol> *)serviceObject serviceIdentifier:(NSString *)serviceIdentifier {
    if (serviceObject == nil)   return;
    
    NSAssert([serviceObject conformsToProtocol:@protocol(DYNetworkServiceProtocol)], @"你提供的Service没有遵循DYNetworkServiceProtocol");
    self.serviceStorageDictionary[serviceIdentifier] = serviceObject;
}

@end
