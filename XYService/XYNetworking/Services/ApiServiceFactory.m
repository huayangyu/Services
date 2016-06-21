//
//  ApiServiceFactory.m
//  test
//  THANKS TO CASA.
//  Created by Charlie on 15/8/14.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import "ApiServiceFactory.h"

@interface ApiServiceFactory ()

@property (copy, nonatomic) NSMutableDictionary * storeServices;

@end

@implementation ApiServiceFactory


+ (instancetype)sharedInstance {
    static ApiServiceFactory * serviceFactory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceFactory = [[ApiServiceFactory alloc] init];
    });
    return serviceFactory;
}

- (NSMutableDictionary *)storeServices {
    if (!_storeServices) {
        _storeServices = [NSMutableDictionary dictionary];
    }
    return _storeServices;
}

- (ApiService *)serviceWithIdentifier:(NSString *)identifier {
    if (!self.storeServices[identifier]) {
        self.storeServices[identifier] = [self newApiServiceWithIdentifier:identifier];
    }
    return self.storeServices[identifier];
}

- (ApiService *)newApiServiceWithIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:@"XYShareApi"]) {
        return [[ApiService alloc] init];
    }
    return [[ApiService alloc] init];
}

@end
