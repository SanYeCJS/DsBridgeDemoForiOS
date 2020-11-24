//
//  JSInvokeTest.m
//  iOSForDsBridge_Example
//
//  Created by chenjs on 2020/11/23.
//  Copyright © 2020 chenjs. All rights reserved.
//

#import "JSInvokeTest.h"
#import <dsbridge.h>

@implementation JSInvokeTest

/*
没参数的方法，必须带字典参数
方法不能重名
*/

//同步带参数
- (NSString *)saySyncHello:(NSString *)username {
    return [@"sync hello " stringByAppendingString:username];
}

//同步无参  必须带一个字典做参数才能正确调用
- (NSString *)saySyncHello2:(NSDictionary *) args {
    return @"sync no args";
}

//异步带参数
- (void)sayAsyncHello:(NSString *)username callBackBlock:(JSCallback)block {
    if (block) {
        block([@"async hi " stringByAppendingString:username], YES);
    }
}

//异步无参
- (void)sayAsyncHello2:(NSDictionary *)args withBlock:(JSCallback)block {
    if (block) {
        block(@"async with no args", YES);
    }
}

@end
