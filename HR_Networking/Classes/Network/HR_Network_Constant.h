
#ifndef HR_Network_Constant_h
#define HR_Network_Constant_h

static const NSInteger HR_Net_ReconnectCount = 3;

typedef NS_ENUM(NSUInteger, HR_Net_ENV) {
    HR_Net_ENV_Dev,     // default
    HR_Net_ENV_Test,
    HR_Net_ENV_Local,   // manual input
    HR_Net_ENV_Online
};

typedef NS_ENUM(NSUInteger, HR_Net_Method) {
    HR_Net_Method_GET,
    HR_Net_Method_POST, // default
    HR_Net_Method_FORM,
};

typedef NS_ENUM(NSUInteger, HR_Net_Protocol) {
    HR_Net_Protocol_HTTP = 1, // default
    HR_Net_Protocol_HTTPS,
};

#endif
