
#import <Foundation/Foundation.h>
#import "HR_Network_Constant.h"
#import "HR_Network_ENVModel.h"

@interface HR_Network_ENVViewModel : NSObject

/**
 Singleton

 @return self
 */
+ (instancetype)HR_Init;

/** current network environment*/
@property (nonatomic, assign) HR_Net_ENV env;

/** all environment configuration */
@property (nonatomic, strong) NSMutableDictionary <NSString *, HR_Network_ENVModel *>*envInfos;

/** manual input environment configuration */
@property (nonatomic, strong) HR_Network_ENVModel *localEnv;

@end 
