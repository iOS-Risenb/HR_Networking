

#import "HR_Network_LogDetailViewController.h"

@interface HR_Network_LogDetailViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UITextView *tv;

@end

@implementation HR_Network_LogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UI];
}

- (void)UI {
    self.navigationItem.title = @"Request Detail";
    
    UIColor *selectedColor = [UIColor colorWithRed:32 / 255.0 green:136 / 255.0 blue:22 / 255.0 alpha:1];
    self.tv.textColor = self.model.requestStatus ? selectedColor : [UIColor redColor];
    if (self.model.requestStatus) {
        self.tv.text = self.model.requestData;
    } else {
        self.tv.text = self.model.requestErrMsg;
    }
}

- (void)setModel:(HR_Network_LogModel *)model {
    _model = model;
}

@end
