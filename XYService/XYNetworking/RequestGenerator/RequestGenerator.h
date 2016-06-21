//
//  RequestGenerator.h
//  test
//
//  Created by Charlie on 15/8/13.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                                   params:(NSDictionary *)params
                                               methodName:(NSString *)methodName;

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                                   params:(NSDictionary *)params
                                               methodName:(NSString *)methodName;

- (NSMutableURLRequest *)generateUploadWithServiceIdentifer:(NSString *)serviceIdentifier
                                                     params:(NSDictionary *)params
                                                 methodName:(NSString *)methodName;
@end
