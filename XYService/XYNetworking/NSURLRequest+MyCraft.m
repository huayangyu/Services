//
//  NSURLRequest+MyCraft.m
//  test
//
//  Created by Charlie on 15/8/14.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import "NSURLRequest+MyCraft.h"
#import <objc/runtime.h>

static void *MyCraftRequstParams;

@implementation NSURLRequest (MyCraft)

- (void)setRequestParams_test:(NSDictionary *)requestParams {
    objc_setAssociatedObject(self, &MyCraftRequstParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams_test {
    return objc_getAssociatedObject(self, &MyCraftRequstParams);
}

@end
