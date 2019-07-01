//
//  DYHudAccessoryView.h
//  DYNetwork_Example
//
//  Created by 破晓工作室 on 2019/6/25.
//  Copyright © 2019 昌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DYNetwork/DYNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYHudAccessory : UIView <DYNetworkAccessoryProtocol>

- (instancetype)initWithView:(UIView *)view msg:(NSString *)msg;


@end

NS_ASSUME_NONNULL_END
