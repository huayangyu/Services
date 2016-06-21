//
//  XYAppContext.m
//  2030
//
//  Created by Charlie on 15/11/10.
//  Copyright © 2015年 Charlie. All rights reserved.
//

#import "XYAppContext.h"

@implementation XYAppContext

/*      短版本号        */
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

+ (id)shareContext {
    static XYAppContext * appContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appContext = [[XYAppContext alloc] init];
    });
    return appContext;
}

#pragma mark - 加密参数
- (NSString *)signWithAct:(NSInteger)act paramString:(NSString *)jsonString {
    return @"";
//    NSString * string = [NSString stringWithFormat:@"%ld%@%@%@",(long)act,jsonString,self.publicKey,self.time];
//    NSLog(@"signString %@",string);
//    return [string MD5Digest];
}

#pragma mark -Get
- (NSString *)publicKey {
    return @"Qg715Buy";
}

- (NSString *)v {
    return XcodeAppVersion;
}

- (NSString *)sys {
    return @"iOS";
}

- (NSString *)time {
    
    return [NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970];
}

@end
