
#import "BSDealRecord.h"
@implementation BSDealRecord
+ (NSDictionary*) JSONKeyPathsByPropertyKey
{
    return @{@"identifier":@"identifier",

            };
}

+ (NSValueTransformer*) identifierJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:TMDStringValueTransformerName];
}
    

@end
