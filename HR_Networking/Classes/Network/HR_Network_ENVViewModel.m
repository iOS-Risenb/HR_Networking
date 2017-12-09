
#import "HR_Network_ENVViewModel.h"

static NSString *kHR_NET_ENV = @"kHR_NET_ENV";
static NSString *kHR_NET_ENVLocalProtocol = @"kHR_NET_ENVLocalProtocol";
static NSString *kHR_NET_ENVLocalHost = @"kHR_NET_ENVLocalHost";
static NSString *kHR_NET_ENVLocalPort = @"kHR_NET_ENVLocalPort";
static NSString *kHR_NET_ENVLocalPrefix = @"kHR_NET_ENVLocalPrefix";

@implementation HR_Network_ENVViewModel

+ (instancetype)HR_Init {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] HR_Init];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone{
    return [[self class] HR_Init];
}

#pragma mark - Setter/Getter

- (HR_Net_ENV)env {
    HR_Net_ENV env = [[NSUserDefaults standardUserDefaults] integerForKey:kHR_NET_ENV];
    return env;
}

- (void)setEnv:(HR_Net_ENV)env {
    [[NSUserDefaults standardUserDefaults] setInteger:env forKey:kHR_NET_ENV];
}

- (void)setLocalEnv:(HR_Network_ENVModel *)localEnv {
    
    [[NSUserDefaults standardUserDefaults] setObject:localEnv.protocol forKey:kHR_NET_ENVLocalProtocol];
    [[NSUserDefaults standardUserDefaults] setObject:localEnv.host forKey:kHR_NET_ENVLocalHost];
    [[NSUserDefaults standardUserDefaults] setObject:localEnv.port forKey:kHR_NET_ENVLocalPort];
    [[NSUserDefaults standardUserDefaults] setObject:localEnv.prefix forKey:kHR_NET_ENVLocalPrefix];
}

- (HR_Network_ENVModel *)localEnv {
    HR_Network_ENVModel *model = [HR_Network_ENVModel new];
    model.protocol = [[NSUserDefaults standardUserDefaults] objectForKey:kHR_NET_ENVLocalProtocol];
    model.protocol = model.protocol ? : @"";
    model.host = [[NSUserDefaults standardUserDefaults] objectForKey:kHR_NET_ENVLocalHost];
    model.host = model.host ? : @"";
    model.port = [[NSUserDefaults standardUserDefaults] objectForKey:kHR_NET_ENVLocalPort];
    model.port = model.port ? : @"";
    model.prefix = [[NSUserDefaults standardUserDefaults] objectForKey:kHR_NET_ENVLocalPrefix];
    model.prefix = model.prefix ? : @"";
    return model;   
}

#pragma mark - Lazy Loading

- (NSMutableDictionary<NSString *, HR_Network_ENVModel *> *)envInfos {
    if (!_envInfos) {
        _envInfos = [NSMutableDictionary dictionary];
    }
    return _envInfos;
}

@end
