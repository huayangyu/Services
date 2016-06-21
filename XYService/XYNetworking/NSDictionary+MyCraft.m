//
//  NSDictionary+MyCraft.m
//  test
//
//  Created by Charlie on 15/8/14.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import "NSDictionary+MyCraft.h"

@implementation NSDictionary (MyCraft)

- (NSArray *)MyCraft_transformDictionaryToArray {
    NSMutableArray * resultArray = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@",obj];
        }
        if ([obj length] > 0) {
            [resultArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }
    }];
    NSArray * sortedResult = [resultArray sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}


@end
