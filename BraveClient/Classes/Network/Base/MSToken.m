//
//  MSToken.m
//  MoShang
//
//  Created by stonedong on 15/2/1.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import "MSToken.h"
@implementation MSToken
+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}
+ (NSValueTransformer *)experiedDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+(NSDictionary*) JSONKeyPathsByPropertyKey
{
    return @{
             @"account":@"account",
             @"account":@"account"
             };
}
- (instancetype) initWithAccount:(NSString *)account
{
    self = [super init];
    if (!self) {
        return self;
    }
    _account = account;
    _experiedDate = [NSDate dateWithTimeIntervalSinceNow:60*10];
    return self;
}

@end
