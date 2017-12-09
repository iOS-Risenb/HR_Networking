

#import <Foundation/Foundation.h>
#import "HR_Network_Constant.h"

@interface HR_Network_LogModel : NSObject

@property (nonatomic, assign) HR_Net_Method requestMethod;

@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, copy) NSString *requestPara;

@property (nonatomic, assign) BOOL requestStatus;

@property (nonatomic, copy) NSString *requestData;

@property (nonatomic, copy) NSString *requestErrMsg;

@end
