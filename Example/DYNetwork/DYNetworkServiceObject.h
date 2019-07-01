//
//  DYNetworkServiceObject.h
//  DYNetwork_Example
//
//  Created by 破晓工作室 on 2019/6/25.
//  Copyright © 2019 昌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DYNetwork/DYNetwork.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DYNetworkServiceType) {
    DYNetworkServiceTypeDEV,
    DYNetworkServiceTypeCIT,
    DYNetworkServiceTypeUAT,
};

@interface DYNetworkServiceObject : NSObject <DYNetworkServiceProtocol>

@property (nonatomic, assign) DYNetworkServiceType serviceType;



@end

NS_ASSUME_NONNULL_END
