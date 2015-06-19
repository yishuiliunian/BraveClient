//
//  MSTokenManager.h
//  MoShang
//
//  Created by stonedong on 15/2/4.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSToken.h"
@class LTAccount;
#define MSShareTokenManager [MSTokenManager shareManager]
#define MSShareToken [MSShareTokenManager token]
#define MSShareTokenString [MSShareToken token]
@interface MSTokenManager : NSObject
@property (nonatomic, strong, readonly) MSToken* token;
+ (MSTokenManager*) shareManager;
- (BOOL) isTokenVaild;
- (BOOL) revarifyCacheToken:(NSError*__autoreleasing*)error;
- (void) cacheToken:(MSToken*)token forAccount:(LTAccount*)ac;
@end
