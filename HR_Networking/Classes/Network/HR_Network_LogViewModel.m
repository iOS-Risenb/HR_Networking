

#import "HR_Network_LogViewModel.h"

@implementation HR_Network_LogViewModel

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] shareInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone{
    return [[self class] shareInstance];
}

- (NSMutableArray<HR_Network_LogModel *> *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
