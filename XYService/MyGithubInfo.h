//
//  MyGithubInfo.h
//  XYService
//
//  Created by Charlie on 16/6/17.
//  Copyright © 2016年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGithubInfo : NSObject

- (void)getGithubReposForUser:(NSString *)user withSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))faiilure;

@end
