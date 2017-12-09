
#import "UIWindow+HR_ShowNetControl.h"
#import "HR_Network_LogListViewController.h"
#import "HR_Network_ENVListViewController.h"

const int HR_Network_Control_Tag = 20170829;

@implementation UIWindow (HR_ShowNetControl)

- (void)hr_showNetControl {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 50, size.height - 50, 30, 30)];
    UIColor *c = [UIColor colorWithRed:71 / 255.0 green:156 / 255.0 blue:228 / 255.0 alpha:1];
    [btn setTitle:@"NET" forState:UIControlStateNormal];
    [btn setTitleColor:c forState:UIControlStateNormal];
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = c.CGColor;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    btn.tag = HR_Network_Control_Tag;
    btn.selected = YES;
    [self addSubview:btn];
    
    [btn addTarget:self action:@selector(showLogList) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panLogAction:)];
    [btn addGestureRecognizer:pan];
    UILongPressGestureRecognizer *lpGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [btn addGestureRecognizer:lpGes];
}

- (void)showLogList {
    HR_Network_LogListViewController *vc = [[HR_Network_LogListViewController alloc] initWithNibName:@"HR_Network_LogListViewController" bundle:[NSBundle bundleForClass:[HR_Network_LogListViewController class]]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)panLogAction:(UIPanGestureRecognizer *)panGes {
    CGPoint point = [panGes translationInView:self];
    panGes.view.center = CGPointMake(panGes.view.center.x + point.x, panGes.view.center.y + point.y);
    [panGes setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)ges {
    if (ges.state != UIGestureRecognizerStateBegan) {
        return;
    }
    HR_Network_ENVListViewController *vc = [[HR_Network_ENVListViewController alloc] initWithNibName:@"HR_Network_ENVListViewController" bundle:[NSBundle bundleForClass:[HR_Network_ENVListViewController class]]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

@end
