//
//  MSSyncCenter.h
//  MoShang
//
//  Created by stonedong on 15/2/7.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MSDefaultSyncCenter [MSSyncCenter defaultCenter]
#define MSPerformRequestWithDelegateSelf(request) [MSDefaultSyncCenter performRequest:request withUIDelegate:self]
@protocol MSRequestUIDelegate;
@class MSRequest;
@interface MSSyncCenter : NSObject
+ (MSSyncCenter*) defaultCenter;
- (int) performRequest:(MSRequest*)request;
- (int) performRequest:(MSRequest *)request withUIDelegate:(id<MSRequestUIDelegate>)delegate;
@end
