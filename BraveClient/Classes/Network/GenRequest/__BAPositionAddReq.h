
#import "MSRequest.h"
#import "BSPositionAddRsp.h"
@interface __BAPositionAddReq : MSRequest

@property(nonatomic,strong) NSString* userName;


- (void) didGetMessage:(BSPositionAddRsp*)message;
@end
    
