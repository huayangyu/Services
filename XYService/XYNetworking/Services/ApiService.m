//
//  ApiService.m
//  test
//
//  Created by Charlie on 15/8/13.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import "ApiService.h"
#import "XYService.h"

@implementation ApiService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.child = self;
    }
    return self;
}

- (NSString *)apiBaseUrl {
        
#ifdef DEBUG
    return [NSString stringWithFormat:@"http://%@/api/",kServerPath];
#else
    return [NSString stringWithFormat:@"http://%@/api/",kServerPath];
#endif
}

- (NSString *)apiVersion {
    return nil;
}

@end
