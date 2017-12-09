

#import <Foundation/Foundation.h>
#import "HR_Network_Constant.h"

@protocol HR_Network_ENVProtocol <NSObject>

@optional
/**
 Develop environment config.
 ps: call this method in Appdelete

 @param protocol protocol
 @param host host
 @param port port
 @param prefix prefix
 */
+ (void)hr_DevProtocol:(HR_Net_Protocol)protocol   // e.g. "https"
                  host:(NSString *)host       // e.g. "192.168.0.1"
                  port:(NSString *)port       // e.g. "8080"
                prefix:(NSString *)prefix;    // e.g. "/prefix"

/**
 Test environment config
 ps: 
    1. call this method in Appdelete
    2. change build configuration to 'Debug' at 'Product->Scheme->Edit Scheme->Archive->Build Configuration' when you archive a ipa file
 
 @param protocol protocol
 @param host host
 @param port port
 @param prefix prefix
 */
+ (void)hr_TestProtocol:(HR_Net_Protocol)protocol
                   host:(NSString *)host
                   port:(NSString *)port
                 prefix:(NSString *)prefix;

/** online environment */
/**
 Online environment config
 ps: 
    1. call this method in Appdelete
    2. change build configuration to 'Release' at 'Product->Scheme->Edit Scheme->Archive->Build Configuration' when you archive a ipa file
 
 @param protocol protocol
 @param host host
 @param port port
 @param prefix prefix
 */
+ (void)hr_OnlineProtocol:(HR_Net_Protocol)protocol
                     host:(NSString *)host
                     port:(NSString *)port
                   prefix:(NSString *)prefix;

@end
