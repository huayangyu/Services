//
//  Tests.m
//  Tests
//
//  Created by Charlie on 16/6/17.
//  Copyright © 2016年 XY. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MyGithubInfo.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self testGetReposForCharlie];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testGetReposForCharlie {
    MyGithubInfo *gifhubInfo = [[MyGithubInfo alloc] init];
    XCTAssertNotNil(gifhubInfo, @"githubInfo should not be nil");

    __block id json;
    hxRunInMainLoop(^(BOOL *done) {
        [gifhubInfo getGithubReposForUser:@"huayangyu" withSuccess:^(id responseObject) {
            *done = YES;
            json = responseObject;
        } failure:^(NSError *error) {
            *done = YES;
            json = error;
        }];
    });

    NSLog(@"%@",json);
    XCTAssertNotNil(json, @"json not nil");
}

static inline void hxRunInMainLoop(void(^block)(BOOL *done)) {
    __block BOOL down = NO;
    block(&down);
    while (!down) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
    }
}

@end
