//
//  DYNetworkLogger.m
//  DYNetwork
//
//  Created by 破晓工作室 on 2019/6/25.
//

#import "DYNetworkLogger.h"

@implementation DYNetworkLogger

+ (void)logDebugRequestInfoWithURL:(NSString *)url
                        httpMethod:(NSInteger)httpMethod
                            params:(NSDictionary *)params
                reachabilityStatus:(NSInteger)reachabilityStatus
                    networkPriority:(int)priority {
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**********************************************************************************\n*                                  🚀Request🚀                                   *\n**********************************************************************************\n"];
    [logString appendFormat:@"URL:\t\t\t\t%@\n",url];
    [logString appendFormat:@"Priority:\t\t\t%@\n",@(priority)];
    [logString appendFormat:@"Method:\t\t\t\t%@\n",httpMethod == 0 ? @"Post" : @"Get"];
    [logString appendFormat:@"Param:\t\t\t%@\n",params.count ? params : @""];
    NSString *netReachability = nil;
    switch (reachabilityStatus) {
        case 2:
            netReachability = @"WIFI";
            break;
        case 1:
            netReachability = @"2G/3G/4G";
            break;
        case 0:
            netReachability = @"Not Reachable";
            break;
        default:
            netReachability = @"Unknown";
            break;
    }
    [logString appendFormat:@"Net:\t\t\t\t\t%@",netReachability];
    [logString appendFormat:@"\n**********************************************************************************\n*                                🚀Request End🚀                                 *\n**********************************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
}

+ (void)logDebugResponseInfoWithSessionDataTask:(NSURLSessionDataTask *)sessionDataTask
                                 responseObject:(id)response
                                 authentication:(BOOL)authentication
                                          error:(NSError *)error {
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==================================================================================\n=                                👇Net Response👇                                =\n==================================================================================\n"];
    [logString appendFormat:@"Request URL:\t\t%@\n", sessionDataTask.currentRequest.URL];
    if ([sessionDataTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
        [logString appendFormat:@"Status:\t\t\t\t\t%ld\n", (long)[(NSHTTPURLResponse *)sessionDataTask.response statusCode]];
    }
    BOOL shouldLogError = error ? YES : NO;
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }else{
        [logString appendFormat:@"Authentication:\t%@\n\n",authentication ? @"Pass" : @"Error ! ! !"];
    }
    [logString appendFormat:@"Response:\t\t\t\t%@", response];
    
    if ([(NSHTTPURLResponse *)sessionDataTask.response statusCode] != 200) {
        [logString appendFormat:@"\n\nHTTP Header:\n\t%@", sessionDataTask.currentRequest.allHTTPHeaderFields];
        if (sessionDataTask.currentRequest.HTTPBody) {
            [logString appendFormat:@"\n\nHTTP Body:\n\t%@", [[NSString alloc] initWithData:sessionDataTask.currentRequest.HTTPBody encoding:NSUTF8StringEncoding]];
        }
    }
    [logString appendFormat:@"\n==================================================================================\n=                             ☝️Net Response End☝️                               =\n==================================================================================\n\n\n\n"];
    NSLog(@"%@", logString);
}


@end
