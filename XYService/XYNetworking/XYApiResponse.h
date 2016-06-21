//
//  XYApiResponse.h
//  test
//
//  Created by Charlie on 15/8/17.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYApiResponse : NSObject
/**
 response 返回的object
 */
@property (nonatomic, strong) id resultObject;
@property (nonatomic, strong) NSError * error;
@property (nonatomic, strong) NSDictionary * resultDictionary;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, assign) NSInteger status;

@end
