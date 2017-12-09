//
//  HR_Network+ShowNetControl.m
//  AFNetworking
//
//  Created by Obgniyum on 2017/10/15.
//

#import "HR_Network+ShowNetControl.h"
#import "HR_Network_UI.h"
#import <objc/runtime.h>

@implementation HR_Network (ShowNetControl)

+ (void)load {
    swizzleMethodForShowNetControl();
}

void swizzleMethodForShowNetControl()  {
    Method originalMethod = class_getClassMethod(NSClassFromString(@"HR_Network"), @selector(HR_Request:progress:success:failure:));
    Method swizzledMethod = class_getClassMethod(NSClassFromString(@"HR_Network"), @selector(swizzle_handleRequest:progress:success:failure:));
    if (originalMethod && swizzledMethod) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (HR_Network *)swizzle_handleRequest:(void(^)(HR_Network *hr))request progress:(void (^)(CGFloat))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    // ?
    dispatch_async(dispatch_get_main_queue(), ^{
        Class C = NSClassFromString(@"HR_Network_UI");
        if ([C respondsToSelector:@selector(hr_showNetControl)]) {
            [C hr_showNetControl];
        }
    });
    return [self swizzle_handleRequest:request progress:progress success:success failure:failure];
}


@end
