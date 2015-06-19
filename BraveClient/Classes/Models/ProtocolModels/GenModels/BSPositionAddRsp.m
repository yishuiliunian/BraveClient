
#import "BSPositionAddRsp.h"
@implementation BSPositionAddRsp
+ (NSDictionary*) JSONKeyPathsByPropertyKey
{
    return @{@"a":@"a",

            };
}

+ (NSValueTransformer*) aJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:TMDStringValueTransformerName];
}
    

@end
