//
//  DYViewController.m
//  DYNetwork
//
//  Created by 昌 on 06/25/2019.
//  Copyright (c) 2019 昌. All rights reserved.
//

#import "DYViewController.h"
#import <DYNetwork/DYNetwork.h>
#import "DYTempRequest.h"
#import "DYHudAccessoryView.h"

static NSInteger const kTempOneTag = 11;

@interface DYViewController () <DYNetworkResponseProtocol>
@property (strong, nonatomic) UIButton *startButton;

@end

@implementation DYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startButton setTitle:@"startRequest" forState:UIControlStateNormal];
    [_startButton setBackgroundColor:[UIColor cyanColor]];
    _startButton.frame = CGRectMake(100, 100, 200, 50);
    [_startButton addTarget:self action:@selector(pressStartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
}

- (void)sendTempRequest {
    DYTempRequest *request = [[DYTempRequest alloc]init];
    request.responseDelegate = self;
    request.CellPhoneNumber = @"15038895697";
    request.Password = @"123456";
    DYHudAccessoryView *hud = [[DYHudAccessoryView alloc]initWithView:self.view msg:@"lazyloading..."];
    [request addNetworkAccessoryObject:hud];
    request.tag = kTempOneTag;
    [request startRequest];
}

#pragma mark -
#pragma mark - DYNetworkResponseProtocol

/**
 请求成功的回调
 
 @param networkRequest 请求对象
 @param response 响应的数据（DYNetworkResponse）
 */
- (void)networkRequest:(DYNetworkRequest *)networkRequest succeedByResponse:(DYNetworkResponse *)response {
    switch (response.requestTag) {
        case kTempOneTag:
        {
            
        }
            break;
            
        default:
            break;
    }
}

/**
 请求失败的回调
 
 @param networkRequest 请求对象
 @param response 响应的数据（DYNetworkResponse）
 */
- (void)networkRequest:(DYNetworkRequest *)networkRequest failedByResponse:(DYNetworkResponse *)response {
    NSLog(@"sbl");
}


- (void)pressStartButtonAction:(UIButton *)btn {
    [self sendTempRequest];
}

@end
