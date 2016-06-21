//
//  MyGithubInfo.m
//  XYService
//
//  Created by Charlie on 16/6/17.
//  Copyright © 2016年 XY. All rights reserved.
//

#import "MyGithubInfo.h"
#import "XYService.h"

@implementation MyGithubInfo

- (void)getGithubReposForUser:(NSString *)user withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError * error))faiilure {
    XYCommonService *service = [[XYCommonService alloc] init];
    [service downloadFileWithUrlString:[NSString stringWithFormat:@"https://api.github.com/users/%@/repos",user] successBlock:^(NSDictionary *responseObject) {
        success(responseObject);
    } failBlock:^(NSError *error) {
        faiilure(error);
    }];
}

@end
