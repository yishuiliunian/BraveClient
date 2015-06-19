
#import <Mantle.h>
#import "NSValueTransformer+NSString.h"


@interface BSDealRecord : MTLModel <MTLJSONSerializing>
@property(nonatomic,strong) NSString* identifier;

@end
  
