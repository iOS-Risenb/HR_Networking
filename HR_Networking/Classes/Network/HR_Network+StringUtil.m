

#import "HR_Network+StringUtil.h"

@implementation HR_Network (StringUtil)

+ (NSString *)HR_ProtocolString:(HR_Net_Protocol)protocol {
    switch (protocol) {
        case HR_Net_Protocol_HTTP:
            return @"http";
            break;
        case HR_Net_Protocol_HTTPS:
            return @"https";
            break;
        default:
            return @"";
            break;
    }
}

+ (NSString *)HR_MethodString:(HR_Net_Method)method {
    switch (method) {
        case HR_Net_Method_GET:
            return @"GET";
            break;
        case HR_Net_Method_POST:
            return @"POST";
            break;
        case HR_Net_Method_FORM:
            return @"FORM";
            break;
        default:
            return @"";
            break;
    }
}

@end
