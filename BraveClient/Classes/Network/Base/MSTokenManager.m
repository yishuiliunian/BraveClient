//
//  MSTokenManager.m
//  MoShang
//
//  Created by stonedong on 15/2/4.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import "MSTokenManager.h"
#import <DZSingletonFactory.h>
@implementation MSTokenManager
+ (MSTokenManager*) shareManager {
    return DZSingleForClass([self class]);
}
- (NSString*) currentAccountIdentifier
{
    return @"xx";
}
- (MSToken*) loadTokenForAccount:(NSString*)accountID
{
    if (!accountID) {
        return nil;
    }
    id storeData=[[NSUserDefaults standardUserDefaults] objectForKey:accountID];
    
    NSData* dicData = nil;
    if (![storeData isKindOfClass:[NSData class]]) {
        return nil;
    }
    dicData = storeData;
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:dicData options:0 error:nil];
    if (dic) {
        MSToken* token = [MTLJSONAdapter modelOfClass:[MSToken class] fromJSONDictionary:dic error:nil];
        if (token) {
            return token;
        }
    }
    return nil;
    
}

- (void) storeTokenToLocalForAccount:(NSString*)accountID
{
    NSDictionary* dic = [MTLJSONAdapter JSONDictionaryFromModel:_token error:nil];
    if (dic && accountID) {
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:accountID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
   _token = [self loadTokenForAccount:[self currentAccountIdentifier]];
    return self;
}


- (void) cacheToken:(MSToken *)token forAccount:(id)ac
{
    NSParameterAssert(token);
    NSParameterAssert(ac);
    _token = token;
    [self storeTokenToLocalForAccount:ac];
}

- (BOOL) isTokenVaild
{
    if (!_token) {
        return NO;
    }
    if ( !_token.account) {
        return NO;
    }
    if (!_token.experiedDate) {
        return NO;
    }
    
    if ([_token.experiedDate timeIntervalSinceNow] < 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL) revarifyCacheToken:(NSError *__autoreleasing *)error
{
    if ([self isTokenVaild]) {
        return YES;
    }
    

    return YES;
}
@end
