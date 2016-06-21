//
//  ApiProxyCasa.h
//  test
//
//  Created by Charlie on 15/8/13.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYApiResponse.h"

typedef void(^ApiProxyCallBack)(XYApiResponse * response);

@interface ApiProxyCasa : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params
             serviceIdentifier:(NSString *)serviceIdentifier
                      delegate:(UIViewController *)delegate
                    methodName:(NSString *)methodName
                       success:(ApiProxyCallBack)success
                          fail:(ApiProxyCallBack)fail;

- (NSInteger)callPOSTWithParams:(NSDictionary *)params
              serviceIdentifier:(NSString *)serviceIdentifier
                       delegate:(UIViewController *)delegate
                     methodName:(NSString *)methodName
                        success:(ApiProxyCallBack)success
                           fail:(ApiProxyCallBack)fail;

- (NSInteger)callUPLOADWithParams:(NSDictionary *)params
              serviceIdentifier:(NSString *)serviceIdentifier
                       delegate:(UIViewController *)delegate
                     methodName:(NSString *)methodName
                        success:(ApiProxyCallBack)success
                           fail:(ApiProxyCallBack)fail;
@end
