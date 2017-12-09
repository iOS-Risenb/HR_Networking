

#import "HR_Network_TaskQueue.h"

@interface HR_Network_TaskQueue ()

@property (nonatomic, strong) NSMutableArray <NSURLSessionDataTask *>*taskMArr;

@end

@implementation HR_Network_TaskQueue

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

#pragma mark - Public

+ (void)HR_AddTask:(NSURLSessionDataTask *)task {
    HR_Network_TaskQueue *queue = [[HR_Network_TaskQueue alloc] init];
    for (NSURLSessionDataTask *t in queue.taskMArr) {
        if ([task isEqual:t]) {
            return;
        }
    }
    [queue.taskMArr addObject:task];
}

+ (void)HR_CancelAll {
    HR_Network_TaskQueue *queue = [[HR_Network_TaskQueue alloc] init];
    for (NSURLSessionDataTask *t in queue.taskMArr) {
        [t cancel];
    }
}

#pragma mark - Lazy

- (NSMutableArray *)taskMArr {
    if (!_taskMArr) {
        _taskMArr = [NSMutableArray array];
    }
    return _taskMArr;
}

@end
