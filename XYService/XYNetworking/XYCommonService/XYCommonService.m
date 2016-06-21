
//
//  XYCommonService.m
//  piaDemo
//
//  Created by Charlie on 16/6/12.
//  Copyright © 2016年 Charlie. All rights reserved.
//

#import "XYCommonService.h"
#import <AFNetworking.h>

@interface XYCommonService ()

@end

@implementation XYCommonService

- (void)downloadFileWithUrlString:(NSString *)urlStr successBlock:(XYCommonServiceSuccessBlock)successBlock failBlock:(XYCommonServiceFailureBlock)failBlock {
    self.successBlock = successBlock;
    self.failBlock = failBlock;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (_failBlock) {
                _failBlock(error);
            }
        } else {
            if (_successBlock) {
                _successBlock((NSDictionary *)responseObject);
            }
        }
    }];
    [dataTask resume];
}
@end
