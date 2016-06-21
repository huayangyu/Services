//
//  BaseApiManager.m
//  test
//  source is from CASA.
//  Created by Charlie on 15/8/13.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import "BaseApiManager.h"
#import "ApiProxyCasa.h"
#import <AFNetworkReachabilityManager.h>

#define AXCallAPI(REQUEST_METHOD, REQUEST_ID)                                            \
{                                                                                         \
    REQUEST_ID = [[ApiProxyCasa sharedInstance]                                            \
    call##REQUEST_METHOD##WithParams:apiParams                                              \
                   serviceIdentifier:self.child.serviceType                                  \
                            delegate:self.delegate                                            \
                          methodName:self.child.methodName                                    \
                             success:^(XYApiResponse *response){                               \
                                [self successCallingApi:response];                              \
                              } fail:^(XYApiResponse *response){                                 \
                                [self failCallingApi:response];                                   \
    }];                                                                                            \
    [self.requestIdList addObject:@(REQUEST_ID)];                                                   \
}

@interface BaseApiManager ()
@property (strong, nonatomic) NSMutableArray * requestIdList;
@property (nonatomic ,strong) AFNetworkReachabilityManager * reachManager;
@end

@implementation BaseApiManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(BaseApiManagerProtocol)]) {
            self.child = (id <BaseApiManagerProtocol>)self;
        }
    }
    return self;
}

- (NSInteger)loadData {
    
    NSDictionary* params = [self.datasource paramsForApi:self];
    NSInteger requestID  = [self loadDataWithParams:params];
    return requestID;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    NSInteger requestID      = 0;
    NSDictionary * apiParams = [self reformParams:params];
    
    if ([self.validator manager:self isCorrectWithApiParamsData:params]) {
        switch ([self.child requestType]) {
            case BaseApiRequestTypeGet:
                AXCallAPI(GET, requestID);
                break;
            case BaseApiRequestTypePost:
                AXCallAPI(POST, requestID);
                break;
            case BaseApiRequestTypeUpload:
                AXCallAPI(UPLOAD, requestID);
                break;
            default:
                break;
        }
    }
    
    return requestID;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    return params;
}

- (AFNetworkReachabilityManager *)reachManager {
    if (!_reachManager) {
        _reachManager = [AFNetworkReachabilityManager sharedManager];
    }
    return _reachManager;
}

#pragma mark -
- (void)successCallingApi:(XYApiResponse *)response {
    _errorType = BaseApiErrorTypeSuccess;

    if ([self.validator respondsToSelector:@selector(manager:isCorrectWithCallBackData:)]) {
        if ([self.validator manager:self isCorrectWithCallBackData:(NSDictionary *)response.resultObject]) {
            [self.delegate managerCallAPIDidSuccess:self responseObject:response];
        } else {
            if ([self.delegate respondsToSelector:@selector(managerCallAPIDidFailed:responseObject:)]) {
                [self.delegate managerCallAPIDidFailed:self responseObject:response];
            }
        }
    }
}

- (void)failCallingApi:(XYApiResponse *)response {
    if (!self.reachManager.reachable) {
        NSLog(@"NETWORK DOWN");
        _errorType = BaseApiErrorTypeNoNetwork;
    } else {
        _errorType = BaseApiErrorTypeDefault;
    }

    if ([self.delegate respondsToSelector:@selector(managerCallAPIDidFailed:responseObject:)]) {
        [self.delegate managerCallAPIDidFailed:self responseObject:response];
    }
    NSLog(@"%@",response.error.debugDescription);
}

@end
