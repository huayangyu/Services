//
//  ApiServiceFactory.h
//  test
//
//  Created by Charlie on 15/8/14.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiService.h"

@interface ApiServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (ApiService *)serviceWithIdentifier:(NSString *)identifier;
- (ApiService *)newApiServiceWithIdentifier:(NSString *)identifier;
@end
