//
//  MSRouter.m
//  MoShang
//
//  Created by stonedong on 15/2/4.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import "MSRouter.h"
#import <DZSingletonFactory.h>

NSString* const HttpMethodPOST = @"POST";
NSString* const HttpMethodGET = @"GET";

@implementation MSRouter
 + (MSRouter*) shareRouter
{
    return DZSingleForClass([self class]);
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _baseURL = [NSURL URLWithString:@"http://115.28.177.12:3344"];
    return self;
}
@end