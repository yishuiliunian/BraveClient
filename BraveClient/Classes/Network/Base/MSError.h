//
//  MSError.h
//  BraveClient
//
//  Created by baidu on 15/6/17.
//  Copyright (c) 2015年 dzpqzb. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MSCreateError(code, message)  [[MSError alloc] initWithCode:code message:message]
#define MSCreateDefaultError(code) [[MSError alloc]initWithDeaultErrorCode:code]

#define MSOccurError(errorPoint, code, message) \
if (error != NULL) {\
    *error = MSCreateError(code, message);\
}



typedef enum {
    MSErrorDecode = -4000,
    MSErrorEncode = MSErrorDecode-1,
    NSErrorNoData = MSErrorEncode - 1,
}MSNetworkErrorCode;
@interface MSError : NSError
- (instancetype) initWithCode:(int)code message:(NSString*)message;
- (instancetype) initWithDeaultErrorCode:(int)code;
@end
