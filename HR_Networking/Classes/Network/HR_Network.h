
#import <Foundation/Foundation.h>
#import "HR_Network_ENVProtocol.h"
#import "HR_Network_Constant.h"

@interface HR_Network : NSObject <HR_Network_ENVProtocol>

/**
 Request framework (progress)
 
 ps: you don't have to use weakself in request block
 
 @param request request object callback in order to set request message
 @param progress progress callback
 @param success success callback
 @param failure failure callback
 @return self
 */
+ (instancetype)HR_Request:(void(^)(HR_Network *))request progress:(void(^)(CGFloat))progress success:(void(^)(id))success failure:(void(^)(NSString *))failure;

/**
 Request framework
 
 ps: you don't have to use weakself in request block
 
 @param request request object callback in order to set request message
 @param success success callback
 @param failure failure callback
 @return self
 */
+ (instancetype)HR_Request:(void(^)(HR_Network *hr))request success:(void(^)(id result))success failure:(void(^)(NSString *errMsg))failure;

/** request method */
@property (nonatomic, assign) HR_Net_Method method;

/** url */
@property (nonatomic, copy) NSString *url;
/** url.protocol */
@property (nonatomic, assign) HR_Net_Protocol protocol;
/** url.host */
@property (nonatomic, copy) NSString *host;
/** url.port */
@property (nonatomic, copy) NSString *port;
/** url.prfix */
@property (nonatomic, copy) NSString *prefix;
/** url.path */
@property (nonatomic, copy) NSString *path;

/** params */
@property (nonatomic, strong) NSMutableDictionary *para;

/** form data */
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSData *>*formData;

@property (nonatomic, strong) NSMutableDictionary *header;

/** call back - progress */
@property (nonatomic, copy) void(^progress)(CGFloat p);
/** call back - success */
@property (nonatomic, copy) void(^success)(id data);
/** call back - failure */
@property (nonatomic, copy) void(^failure)(NSString *errMsg);

/** timeout */
@property (nonatomic, assign) NSTimeInterval timeout;

/**
 Cancel task
 */
- (void)HR_CancelTask;

/**
 Cancel all tasks
 
 ps: you should callback this method at `-viewWillDisappear`, if you want to cancel all tasks in current viewcontroller.
 */
+ (void)HR_CancelAllTasks;

@end

