
#import "HR_Network_UI.h"
#import "UIWindow+HR_ShowNetControl.h"

@implementation HR_Network_UI

#pragma mark - Public Methods

+ (void)hr_showNetControl {
    
#if DEBUG
    
    BOOL isExist = NO;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *v in keyWindow.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *bt = (UIButton *)v;
            extern NSInteger HR_Network_Control_Tag;
            if (bt.tag == HR_Network_Control_Tag && bt.selected) {
                bt.hidden = NO;
                isExist = YES;
                return;
            }
        }
    }
    
    if (!isExist) {
        HR_Network_UI *manager = [[HR_Network_UI alloc] init];
        [manager performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    
#endif
    
}

+ (void)hr_hiddenNetControl {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *v in keyWindow.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *bt = (UIButton *)v;
            extern NSInteger HR_Network_Control_Tag;
            if (bt.tag == HR_Network_Control_Tag && bt.selected) {
                bt.hidden = YES;
                return;
            }
        }
    }
}

#pragma mark - Private Methods

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow hr_showNetControl];
}

@end
