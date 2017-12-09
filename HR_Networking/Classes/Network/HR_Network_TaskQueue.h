
#import <Foundation/Foundation.h>

@interface HR_Network_TaskQueue : NSObject

+ (void)HR_AddTask:(NSURLSessionDataTask *)task;

+ (void)HR_CancelAll;

@end
