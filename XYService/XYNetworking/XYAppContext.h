//
//  XYAppContext.h
//  2030
//
//  Created by Charlie on 15/11/10.
//  Copyright © 2015年 Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYAppContext : NSObject

+ (id)shareContext;

@property (nonatomic ,copy ,readonly) NSString * publicKey; //加密参数
@property (nonatomic ,copy ,readonly) NSString * v; //string(50)   版本号
@property (nonatomic ,copy ,readonly) NSString * sys; //string(20)   设备系统（ios/android）
@property (nonatomic ,copy ,readonly) NSString * time;  //int(11)    时间戳


/**
 得到密钥
 参数：act（int）
      jsonString（string）
 */
- (NSString *)signWithAct:(NSInteger)act paramString:(NSString *)jsonString;

@end
