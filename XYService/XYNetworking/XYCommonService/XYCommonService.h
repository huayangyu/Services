//
//  XYCommonService.h
//  piaDemo
//
//  Created by Charlie on 16/6/12.
//  Copyright © 2016年 Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XYCommonServiceSuccessBlock)(NSDictionary * responseObject);
typedef void(^XYCommonServiceFailureBlock)(NSError * error);

@interface XYCommonService : NSObject

@property (nonatomic ,copy) XYCommonServiceSuccessBlock successBlock;
@property (nonatomic ,copy) XYCommonServiceFailureBlock failBlock;

- (void)downloadFileWithUrlString:(NSString *)urlStr successBlock:(XYCommonServiceSuccessBlock)successBlock failBlock:(XYCommonServiceFailureBlock)failBlock;

@end
