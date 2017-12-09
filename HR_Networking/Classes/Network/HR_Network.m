
#import "HR_Network.h"
#import "AFNetworking.h"
#import "HR_Network_ENVViewModel.h"
#import "HR_Network_Constant.h"
#import "HR_Network_LogViewModel.h"
#import "HR_Network+StringUtil.h"
#import "HR_Network_TaskQueue.h"

@interface HR_Network ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, assign) NSInteger requestErrorCount;

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation HR_Network

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _method = HR_Net_Method_POST;
    }
    return self;
}

#pragma mark - Public Methods
/** develop environment */
+ (void)hr_DevProtocol:(HR_Net_Protocol)protocol
                  host:(NSString *)host
                  port:(NSString *)port
                prefix:(NSString *)prefix {
    
    [self configENV:HR_Net_ENV_Dev
           protocol:protocol
               host:host
               port:port
             prefix:prefix];
}

/** test environment */
+ (void)hr_TestProtocol:(HR_Net_Protocol)protocol
                   host:(NSString *)host
                   port:(NSString *)port
                 prefix:(NSString *)prefix {
    
    [self configENV:HR_Net_ENV_Test
           protocol:protocol
               host:host
               port:port
             prefix:prefix];
}

/** online environment */
+ (void)hr_OnlineProtocol:(HR_Net_Protocol)protocol
                     host:(NSString *)host
                     port:(NSString *)port
                   prefix:(NSString *)prefix {
    
    [self configENV:HR_Net_ENV_Online
           protocol:protocol
               host:host
               port:port
             prefix:prefix];
}

+ (void)configENV:(HR_Net_ENV)env
         protocol:(HR_Net_Protocol)protocol
             host:(NSString *)host
             port:(NSString *)port
           prefix:(NSString *)prefix {
    // key
    NSString *identifier = NSStringFromClass(self);
    NSString *envString = [NSString stringWithFormat:@"%lu", (unsigned long)env];
    NSString *key = [NSString stringWithFormat:@"%@_%@", identifier, envString];
    // value
    HR_Network_ENVModel *value = [HR_Network_ENVModel new];
    value.protocol = [HR_Network HR_ProtocolString:protocol];
    value.host = host;
    value.port = port;
    value.prefix = prefix;
    // save
    [[HR_Network_ENVViewModel HR_Init].envInfos setObject:value forKey:key];
}

+ (instancetype)HR_Request:(void(^)(HR_Network *))request progress:(void(^)(CGFloat))progress success:(void(^)(id))success failure:(void(^)(NSString *))failure {
    //
    HR_Network *network = [self new];
    // config
    request(network);
    //
    HR_Network_LogModel *model = [[HR_Network_LogModel alloc] init];
    model.requestMethod = network.method;
    model.requestUrl = network.url;
    model.requestPara = network.para.description;
    [[[HR_Network_LogViewModel alloc] init].modelArray addObject:model];
    //
    network.progress = [progress copy];
    network.success = [success copy];
    network.failure = [failure copy];
    //
    NSLog(@"\nThe request info is\n[UrlP]:%@\n[Meth]:%@\n[Para]:%@", network.url, [self HR_MethodString:network.method], network.para);
    // start request
    [network request];
    return network;
}

+ (instancetype)HR_Request:(void(^)(HR_Network *hr))request success:(void(^)(id result))success failure:(void(^)(NSString *errMsg))failure {
    return [self HR_Request:request progress:nil success:success failure:failure];
}

#pragma mark timeout

- (void)setTimeout:(NSTimeInterval)timeout {
    self.sessionManager.requestSerializer.timeoutInterval = timeout;
}

#pragma mark cancel

- (void)HR_CancelTask {
    [self.task cancel];
}

+ (void)HR_CancelAllTasks {
    [HR_Network_TaskQueue HR_CancelAll];
}

#pragma mark - Private Methods

#pragma mark request method

- (void)request {
//    // header
//    [self.header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
//        [self.para setObject:obj forKey:@"signature"];
//    }];
    
    // request
    switch (self.method) {
        case HR_Net_Method_GET: {
            [self GET];
        }
            break;
        case HR_Net_Method_POST: {
            [self POST];
        }
            break;
        case HR_Net_Method_FORM: {
            [self FORM];
        }
            break;
    }
    // handle task
    [self handleTask];
}

- (void)GET {
    self.task = [self.sessionManager GET:self.url parameters:self.para progress:^(NSProgress * _Nonnull downloadProgress) {
        [self handleProgress:downloadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:error];
    }];
}

- (void)POST {
    self.task = [self.sessionManager POST:self.url parameters:self.para progress:^(NSProgress * _Nonnull uploadProgress) {
        [self handleProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:error];
    }];
}

- (void)FORM {
    self.task = [self.sessionManager POST:self.url parameters:self.para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *allNames = [self.formData allKeys];
        for (NSString *name in allNames) {
            [formData appendPartWithFormData:self.formData[name] name:name];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [self handleProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:error];
    }];
}

#pragma mark handle task

- (void)handleTask {
    if (self.requestErrorCount == 0) {
        [HR_Network_TaskQueue HR_AddTask:self.task];
    }
}

#pragma mark handle callback

- (void)handleProgress:(NSProgress * _Nonnull)progress {
    if (self.progress) {
        CGFloat p = progress.completedUnitCount * 1.0 / progress.totalUnitCount;
        NSLog(@"The current progress is:%lf", p);
        self.progress(p);
    }
}

- (void)handleSuccess:(id _Nullable)responseObject {
    NSLog(@"\n✅✅✅ The request is successful.");
    id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
//    id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"request result:\n%@", result);
    if (self.success && result) {
        self.success(result);
    }
    // request record
    [[[HR_Network_LogViewModel alloc] init].modelArray enumerateObjectsUsingBlock:^(HR_Network_LogModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.requestUrl isEqualToString:self.url]) {
            obj.requestStatus = YES;
            obj.requestData = [result description];
        };
    }];
}

- (void)handleFailure:(NSError * _Nonnull)error {
    _requestErrorCount++;
    if ((error.code == -1009 || error.code == -1005) && _requestErrorCount <= HR_Net_ReconnectCount) {
        NSLog(@"\n♻️♻️♻️ Try reconnecting...");
        [self request];
    } else {
        NSLog(@"\n❌❌❌ The request is failed.\n[Code]:%ld\n[Desc]:%@", error.code, error.localizedDescription);
        if (self.failure) {
            self.failure(error.localizedDescription);
        }
        // request record
        [[[HR_Network_LogViewModel alloc] init].modelArray enumerateObjectsUsingBlock:^(HR_Network_LogModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.requestUrl isEqualToString:self.url]) {
                obj.requestStatus = NO;
                obj.requestErrMsg = [error description];
            };
        }];
    }
}

#pragma mark - Setter/Getter

- (NSString *)url {
    if (!_url) {
        // URL
        NSString *protocol;
        NSString *host;
        NSString *port;
        NSString *prefix;
        NSString *path;
        
        // model
        NSString *identifier = NSStringFromClass([self class]);
        HR_Net_ENV env = [HR_Network_ENVViewModel HR_Init].env;
        NSString *envString = [NSString stringWithFormat:@"%lu", (unsigned long)env];
        NSString *key = [NSString stringWithFormat:@"%@_%@", identifier, envString];
        NSDictionary *envDic = [HR_Network_ENVViewModel HR_Init].envInfos;
        HR_Network_ENVModel *model = envDic[key];
        if (env == HR_Net_ENV_Local) {  // 1. manual
            HR_Network_ENVModel *local = [HR_Network_ENVViewModel HR_Init].localEnv;
            protocol = local.protocol;
            protocol = [protocol stringByAppendingString:@"://"];
            host = local.host;
            port = local.port;
            prefix = local.prefix;
            
        } else {                        // 2. in time > config > default
            
            // protocol
            if (self.protocol) {                    // 2.1.1 in time
                protocol = [HR_Network HR_ProtocolString:self.protocol];
            } else if (model.protocol.length) {     // 2.1.2 config
                protocol = model.protocol;
            } else {                                // 2.1.3
                protocol = @"http";
            }
            protocol = [protocol stringByAppendingString:@"://"]; // 2.1.0
            
            // host
            if (self.host.length) {         // 2.2.1
                host = self.host;
            } else if (model.host.length) { // 2.2.2
                host = model.host;
            } else {                        // 2.2.3
                host = @"";
            }
            
            // port
            if (self.port.length) {         // 2.3.1
                port = self.port;
            } else if (model.port.length) { // 2.3.2
                port = model.port;
            } else {                        // 2.3.3
                port = @"";
            }
            if (port.length) {
                port = [port stringByAppendingString:@":"]; // 2.3.0
            }
            
            // prefix
            if (self.prefix.length) {           // 2.4.1
                prefix = self.prefix;
            } else if (model.prefix.length) {   // 2.4.2
                prefix = model.prefix;
            } else {                            // 2.4.3
                prefix = @"";
            }
        }
        
        // path
        path = self.path ? : @"";               // 2.5
        
        // URL
        NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",
                         protocol,
                         host,
                         port,
                         prefix,
                         path
                         ];
        return url;
    }
    return _url;
}


#pragma mark - Lazy Loading

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];

        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = 8;
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                     @"application/json",
                                                                     @"text/json",
                                                                     @"text/javascript",
                                                                     @"text/html",
                                                                     @"text/plain",
                                                                     nil];
    }
    return _sessionManager;
}

- (NSMutableDictionary *)para {
    if (!_para) {
        _para = [NSMutableDictionary dictionary];
    }
    return _para;
}

- (NSMutableDictionary <NSString *, NSData *>*)formDatas {
    if (!_formData) {
        _formData = [NSMutableDictionary dictionary];
    }
    return _formData;
}

- (NSMutableDictionary *)header {
    if (!_header) {
        _header = [NSMutableDictionary dictionary];
    }
    return _header;
}

@end

