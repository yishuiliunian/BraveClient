//
//  MSError.m
//  BraveClient
//
//  Created by baidu on 15/6/17.
//  Copyright (c) 2015年 dzpqzb. All rights reserved.
//

#import "MSError.h"

@implementation MSError
- (instancetype) initWithCode:(int)code message:(NSString *)message
{
    if (!message) {
        message = @"";
    }
    self = [super initWithDomain:@"com.dzpqzb.network.error" code:code userInfo:@{NSLocalizedDescriptionKey:message}];
    if (!self) {
        return self;
    }

    return self;
}

- (instancetype) initWithDeaultErrorCode:(int)code
{
    self = [self initWithCode:code message:@""];
    if (!self) {
        return self;
    }
    
    return self;
}
@end
