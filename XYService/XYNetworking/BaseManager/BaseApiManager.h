//
//  BaseApiManager.h
//  test
//
//  Created by Charlie on 15/8/13.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYApiResponse.h"

@class BaseApiManager;


typedef NS_ENUM(NSUInteger, BaseApiRequestType) {
    BaseApiRequestTypeGet,
    BaseApiRequestTypePost,
    BaseApiRequestTypeUpload
};

typedef NS_ENUM(NSUInteger, BaseApiErrorType) {
    BaseApiErrorTypeDefault,
    BaseApiErrorTypeSuccess,
    BaseApiErrorTypeNoContent,
    BaseApiErrorTypeParamError,
    BaseApiErrorTypeTimeout,
    BaseApiErrorTypeNoNetwork
};

/*************************************************************************************************/
/*                                    API着陆回调                                                 */
/*************************************************************************************************/
@protocol BaseApiCallBackDelegate <NSObject>
 @required
- (void)managerCallAPIDidSuccess:(BaseApiManager *)manager responseObject:(XYApiResponse *)response;
 @optional
- (void)managerCallAPIDidFailed:(BaseApiManager *)manager responseObject:(XYApiResponse *)response;
@end



/*************************************************************************************************/
/*                                    API参数源                                                   */
/*************************************************************************************************/
@protocol BaseApiParamSourceDelegate <NSObject>

 @required
- (NSDictionary *)paramsForApi:(BaseApiManager *)manager;

@end



/*************************************************************************************************/
/*                                    API参数验证                                                  */
/*************************************************************************************************/
@protocol BaseApiValidateDelegate <NSObject>

 @required
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
- (BOOL)manager:(BaseApiManager *)manager isCorrectWithApiParamsData:(NSDictionary *)data;

@end


/*************************************************************************************************/
/*                                        子类                                                    */
/*************************************************************************************************/
@protocol BaseApiManagerProtocol <NSObject>

 @required
- (NSString *)methodName;
- (NSString *)serviceType;
- (BaseApiRequestType)requestType;
@end


@interface BaseApiManager : NSObject
@property (nonatomic, weak) id<                    BaseApiCallBackDelegate      > delegate;
@property (nonatomic, weak) id<                    BaseApiParamSourceDelegate   > datasource;
@property (nonatomic, weak) id<                    BaseApiValidateDelegate      > validator;
@property (nonatomic, weak) id<                    BaseApiManagerProtocol       > child;

@property (nonatomic, strong, readonly, nullable) NSString* errorMessage;
@property (nonatomic, readonly) BaseApiErrorType errorType;

- (NSInteger)loadData;
@end