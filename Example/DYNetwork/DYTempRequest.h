//
//  DYTempRequest.h
//  DYNetwork_Example
//
//  Created by 破晓工作室 on 2019/6/25.
//  Copyright © 2019 昌. All rights reserved.
//

#import <DYNetwork/DYNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYTempRequest : DYNetworkRequest

@property (nonatomic, copy) NSString *CellPhoneNumber;

@property (nonatomic, copy) NSString *Password;

@end

NS_ASSUME_NONNULL_END
