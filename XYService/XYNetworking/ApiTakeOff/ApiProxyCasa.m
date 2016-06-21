//
//  ApiProxyCasa.m
//  test
//
//  Created by Charlie on 15/8/13.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import "ApiProxyCasa.h"
#import "RequestGenerator.h"
#import "XYApiResponse.h"
#import <AFNetworking.h>

@interface ApiProxyCasa ()
@property (strong ,nonatomic) NSNumber                     * recordedRequestId;
@property (strong ,nonatomic) AFHTTPSessionManager         * sessionManager;
//used to cancel the request operation
@property (strong ,nonatomic) NSMutableDictionary          * dispatchTable;

@end

@implementation ApiProxyCasa

//proxy casa is a singleton
+ (instancetype)sharedInstance {
    static ApiProxyCasa * casa = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        casa = [[ApiProxyCasa alloc] init];
    });
    return casa;
}

- (NSMutableDictionary *)dispatchTable {
    if (!_dispatchTable) {
        _dispatchTable = [NSMutableDictionary dictionary];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] init];
    }
    return _sessionManager;
}

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier delegate:(UIViewController *)delegate methodName:(NSString *)methodName success:(ApiProxyCallBack)success fail:(ApiProxyCallBack)fail {
    NSURLRequest * request = [[RequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:serviceIdentifier params:params methodName:methodName];
    NSNumber * requestId = [self callApiWithRequest:request delegate:delegate success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier delegate:(UIViewController *)delegate methodName:(NSString *)methodName success:(ApiProxyCallBack)success fail:(ApiProxyCallBack)fail {
    NSURLRequest * request = [[RequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:serviceIdentifier params:params methodName:methodName];
    NSNumber * requestId = [self callApiWithRequest:request delegate:delegate success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callUPLOADWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier delegate:(UIViewController *)delegate methodName:(NSString *)methodName success:(ApiProxyCallBack)success fail:(ApiProxyCallBack)fail {
    NSMutableURLRequest * request = [[RequestGenerator sharedInstance] generateUploadWithServiceIdentifer:serviceIdentifier params:params methodName:methodName];
    NSNumber * requestId = [self callUploadApiWithRequest:request delegate:delegate success:success fail:fail];
    return [requestId integerValue];
}

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request delegate:(UIViewController *)delegate success:(ApiProxyCallBack)success fail:(ApiProxyCallBack)fail {

    NSNumber * requestId = [self generateRequestId];
    //跑到block里，表示requestOperation已经完成任务了，casa的话说是回到主线程了

    NSLog(@"%@",request.URL.absoluteString);
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSURLSessionDataTask *sessionTask = self.dispatchTable[requestId];
        if (!error) {
            if (sessionTask == nil) {
                return;
            } else {
                [_dispatchTable removeObjectForKey:requestId];
            }

            XYApiResponse * response = [[XYApiResponse alloc] init];
            response.resultObject = responseObject;
            response.message = ((NSDictionary *)responseObject)[@"message"];
            response.resultDictionary = (NSDictionary *)responseObject[@"result"];
            response.status = [((NSDictionary *)responseObject)[@"status"] integerValue];
            success?success(response):nil;
        } else {
            if (sessionTask == nil) {
                return;
            } else {
                [_dispatchTable removeObjectForKey:requestId];
            }

            XYApiResponse * response = [[XYApiResponse alloc] init];
            response.error = error;
            fail?fail(response):nil;
        }
    }];

    [task resume];
    self.dispatchTable[requestId] = task;
    return requestId;
}

- (NSNumber *)callUploadApiWithRequest:(NSURLRequest *)request delegate:(UIViewController *)delegate  success:(ApiProxyCallBack)success fail:(ApiProxyCallBack)fail {
    
    NSNumber * requestId = [self generateRequestId];
    //跑到block里，表示requestOperation已经完成任务了，casa的话说是回到主线程了
    NSLog(@"%@",request.URL.absoluteString);

    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress: %@",uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress: %@",downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSURLSessionDataTask *sessionTask = self.dispatchTable[requestId];
        if (!error) {
            if (sessionTask == nil) {
                return;
            } else {
                [_dispatchTable removeObjectForKey:requestId];
            }

            XYApiResponse * response = [[XYApiResponse alloc] init];
            response.resultObject = responseObject;
            response.message = ((NSDictionary *)responseObject)[@"message"];
            response.resultDictionary = (NSDictionary *)responseObject[@"result"];
            response.status = [((NSDictionary *)responseObject)[@"status"] integerValue];
            success?success(response):nil;
        } else {
            if (sessionTask == nil) {
                return;
            } else {
                [_dispatchTable removeObjectForKey:requestId];
            }

            XYApiResponse * response = [[XYApiResponse alloc] init];
            response.error = error;
            fail?fail(response):nil;
        }
    }];

    [task resume];
    self.dispatchTable[requestId] = task;
    return requestId;
}

- (NSNumber *)generateRequestId {
    if (!_recordedRequestId) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

- (void)checkStatus:(NSUInteger)status {
    switch (status) {
        case 10:
        {
            //不在服务时间
        }
            break;
        case 20:
        {
            //无权限访问
        }
        default:
            break;
    }
}

@end
