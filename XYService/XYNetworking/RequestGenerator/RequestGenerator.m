//
//  RequestGenerator.m
//  test
//
//  Created by Charlie on 15/8/13.
//  Copyright (c) 2015年 Charlie. All rights reserved.
//

#import "RequestGenerator.h"
#import "ApiServiceFactory.h"
#import "NSDictionary+MyCraft.h"
#import "NSURLRequest+MyCraft.h"
#import "AFNetworking.h"
#import "XYAppContext.h"

@interface RequestGenerator ()
@property (nonatomic, strong) AFHTTPRequestSerializer * httpRequestSerializer;
@property (nonatomic ,strong) XYAppContext * appContext;
@end

@implementation RequestGenerator

+ (instancetype)sharedInstance {
    static RequestGenerator * generator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generator = [[RequestGenerator alloc] init];
    });
    return generator;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [[AFHTTPRequestSerializer alloc] init];
        _httpRequestSerializer.timeoutInterval = 15;
        [_httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _httpRequestSerializer;
}

- (XYAppContext *)appContext {
    if (!_appContext) {
        _appContext = [XYAppContext shareContext];
    }
    return _appContext;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier params:(NSDictionary *)params methodName:(NSString *)methodName {
    
#ifdef RELEASE
    return [self generatePOSTRequestWithServiceIdentifier:serviceIdentifier params:params methodName:methodName];
#endif
    
    //设置参数
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    ApiService *service = [[ApiServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",service.apiBaseUrl,methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:paramsDic error:NULL];
    request.timeoutInterval = 10;   //设置超时时间是20S
    request.requestParams_test = paramsDic;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier params:(NSDictionary *)params methodName:(NSString *)methodName {
    
    ApiService * service = [[ApiServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",service.apiBaseUrl,methodName];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData* postBody = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    unsigned long long postLength = postBody.length;
    NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];

    // This should all look familiar...
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postBody];
    request.timeoutInterval = 10;
    return request;
}

- (NSMutableURLRequest *)generateUploadWithServiceIdentifer:(NSString *)serviceIdentifier params:(NSDictionary *)params methodName:(NSString *)methodName {
    NSData * file = nil;    //上传的字节流
    NSString * dataKey = nil;   //上传的字节流的key

    //搜索字典，将data赋值给file, 字节流的key赋值给dataKey
    for (NSString * key in params.allKeys) {
        id value = params[key];
        if ([value isKindOfClass:[NSData class]]) {
            file = value;
            dataKey = key;
            break;
        }
    }

    if (!file) {
        if ([serviceIdentifier isEqualToString:@"1005"]) {
            file = [[NSData alloc] init];
            dataKey = @"1005";
        } else {
            //如果图片没传 就调普通的POST请求
            return [[self generatePOSTRequestWithServiceIdentifier:serviceIdentifier params:params methodName:methodName] copy];
        }
    }

    //如果file存在
    NSMutableDictionary * m_params = [NSMutableDictionary dictionaryWithDictionary:params];
    [m_params removeObjectForKey:dataKey];

    ApiService * service = [[ApiServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",service.apiBaseUrl,methodName];
    NSMutableURLRequest * request = [self.httpRequestSerializer
                                     multipartFormRequestWithMethod:@"POST"
                                     URLString:urlString
                                     parameters:m_params
                                     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                         if ([serviceIdentifier isEqualToString:@"1011"]) {
                                             //purchase receipt verify
                                             [formData appendPartWithFileData:file name:dataKey fileName:[NSString stringWithFormat:@"%@",dataKey] mimeType:@""];
                                         } else {
                                             //upload jpg
                                             [formData appendPartWithFileData:file name:dataKey fileName:[NSString stringWithFormat:@"%@.jpg",dataKey] mimeType:@"image/jpeg"];
                                         }
                                     } error:NULL];
    request.timeoutInterval = 20;
    return request;
}

- (NSMutableURLRequest *)debug_generateUploadWithServiceIdentifer:(NSString *)serviceIdentifier params:(NSDictionary *)params methodName:(NSString *)methodName {
    
    //设置参数
    NSArray * file = nil;
    if ([params.allKeys containsObject:@"file"]) {
        if ([params[@"file"] isKindOfClass:[NSArray class]]) {
            file = params[@"file"]; //存在file 数组
        }
    }
    
    if (!file) {
        //如果图片没传 就调普通的POST请求
        return [[self generateGETRequestWithServiceIdentifier:serviceIdentifier params:params methodName:methodName] copy];
    }
    
    //将params中关于data的部分从jsonString中移除
    NSMutableDictionary * paramJson = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([params.allKeys containsObject:@"file"]) {
        [paramJson removeObjectForKey:@"file"];
    }
    
    //jsonString 业务参数
    NSError *parseError = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:paramJson options:NSJSONWritingPrettyPrinted error:&parseError];   //json data
    NSMutableString * pre_jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];              //转成json string
    NSString * jsonString_n = [pre_jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];                          //去掉json string 中的\n
    NSMutableString * string = [[NSMutableString alloc] initWithString:jsonString_n];
    NSString * jsonString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];                                     //去掉jsonString 中的空格
    
    //act 用 method name来传
    NSInteger act = [methodName integerValue];
    //sign
    NSString * sign = [self.appContext signWithAct:act paramString:jsonString];
    //time
    NSInteger time = [self.appContext.time integerValue];
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramsDic setObject:@(act) forKey:@"act"]; //跳转urlcode 编号
    [paramsDic setObject:self.appContext.v forKey:@"v"];    //版本号
    [paramsDic setObject:self.appContext.sys forKey:@"sys"];    //设备系统（ios/android）
    [paramsDic setObject:sign forKey:@"sign"];  //签名
    [paramsDic setObject:jsonString forKey:@"param"];  //json字符串
    [paramsDic setObject:@(time) forKey:@"strtime"];  //时间戳
    
    if (file && [file isKindOfClass:[NSArray class]]) {
        [paramsDic setObject:@(file.count) forKey:@"filenum"];    //文件数量
        [paramsDic removeObjectForKey:@"file"];
        for (NSInteger i = 1; i <= file.count; i++) {
            NSString * key = [NSString stringWithFormat:@"file%ld",i];
            [paramsDic setObject:file[i - 1] forKey:key];
        }

    }
    
    ApiService * service = [[ApiServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString * urlString = [NSString stringWithFormat:@"%@",service.apiBaseUrl];
    NSMutableURLRequest * request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:paramsDic error:NULL];
    request.timeoutInterval = 20;

    return request;
}

@end
