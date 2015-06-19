
#import "MSRequest.h"
#import "BSDealRecord.h"
@interface __BSAddDealRequest : MSRequest

@property(nonatomic,strong) NSString* identifier;


- (void) didGetMessage:(BSDealRecord*)message;
@end
    
