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
#import "DYHudAccessory.h"

static NSInteger const kTempOneTag = 11;

@interface DYViewController () <DYNetworkResponseProtocol,DYNetworkBatchResponseProtocol>
@property (strong, nonatomic) UIButton *startButton;

@end

@implementation DYViewController {
    DYNetworkBatchRequest *_bathRequest;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startButton setTitle:@"start Request" forState:UIControlStateNormal];
    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startButton setBackgroundColor:[UIColor cyanColor]];
    _startButton.frame = CGRectMake(100, 100, 200, 50);
    [_startButton addTarget:self action:@selector(pressStartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
    UIButton *batchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [batchButton setTitle:@"start Bath Request" forState:UIControlStateNormal];
    [batchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [batchButton setBackgroundColor:[UIColor cyanColor]];
    batchButton.frame = CGRectMake(100, 200, 200, 50);
    [batchButton addTarget:self action:@selector(pressStartBathButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:batchButton];
    
}

#pragma mark -
#pragma mark - Reuqest

- (void)sendTempRequest {
    DYTempRequest *request = [[DYTempRequest alloc]init];
    request.responseDelegate = self;
    request.CellPhoneNumber = @"15038895697";
    request.Password = @"123456";
    DYHudAccessory *hud = [[DYHudAccessory alloc]initWithView:self.view msg:@"lazyloading..."];
    [request addNetworkAccessoryObject:hud];
    request.tag = kTempOneTag;
    [request startRequest];
}

- (void)sendRequestByCount:(NSInteger)count {
    
    NSMutableArray *tempArr = [NSMutableArray new];
    for (NSInteger i = 0; i < count; i++) {
        DYTempRequest *request = [[DYTempRequest alloc]init];
        request.CellPhoneNumber = @"15038895697";
        request.Password = @"123456";
        
        [tempArr addObject:request];
    }
    
    DYNetworkBatchRequest *bathRequest = [[DYNetworkBatchRequest alloc]initWithRequestArray:tempArr];
    bathRequest.delegate = self;
    DYHudAccessory *hud = [[DYHudAccessory alloc]initWithView:self.view msg:@"lazyloading..."];
    [bathRequest addNetworkAccessoryObject:hud];
    [bathRequest startBatchRequest];
    _bathRequest = bathRequest;
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
            NSLog(@"✌️request success...");
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
    NSLog(@"✋request fail...");
}

#pragma mark -
#pragma mark - DYNetworkBatchResponseProtocol

- (void)networkBatchRequest:(DYNetworkBatchRequest *)batchRequest completedByResponseArray:(NSArray<DYNetworkResponse *> *)responseArray {
    NSLog(@"全部请求完毕！");
}

#pragma mark -
#pragma mark - Event Response

- (void)pressStartButtonAction:(UIButton *)btn {
    [self sendTempRequest];
}

- (void)pressStartBathButtonAction:(UIButton *)btn {
    [self sendRequestByCount:25];
}

@end
