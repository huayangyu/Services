//
//  ApiService.h
//  test
//
//  Created by Charlie on 15/8/13.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiService : NSObject

@property (strong, readonly, nonatomic) NSString * apiBaseUrl;
@property (strong, readonly, nonatomic) NSString * apiVersion;

@property (weak, nonatomic) id child;
@property (copy, nonatomic) NSString * identifier;

@end
