//
//  NSValueTransformer+NSString.m
//  LuTu
//
//  Created by stonedong on 15/5/28.
//  Copyright (c) 2015年 Road.Inc. All rights reserved.
//

#import "NSValueTransformer+NSString.h"
#import <Mantle.h>

NSString * const TMDStringValueTransformerName = @"TMDStringValueTransformerName";

@implementation NSValueTransformer (NSString)
+ (void)load {
    @autoreleasepool {
        MTLValueTransformer *stringValueTransformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(id value) {
            if ([value isKindOfClass:[NSNumber class]]) {
                return [(NSNumber*)value stringValue];
            } else {
                return (NSString*)value;
            }
        } reverseBlock:^(NSString *value) {
            return value;
        }];
        
        [NSValueTransformer setValueTransformer:stringValueTransformer forName:TMDStringValueTransformerName];
    }
}

+ (NSValueTransformer*) sJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:TMDStringValueTransformerName];
}
@end
