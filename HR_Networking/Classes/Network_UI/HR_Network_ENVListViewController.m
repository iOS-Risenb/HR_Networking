

#import "HR_Network_ENVListViewController.h"
#import "HR_Network_UI.h"
#import "HR_Network_ENVViewModel.h"

@interface HR_Network_ENVListViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *tfs;

@end

@implementation HR_Network_ENVListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [HR_Network_UI hr_showNetControl];
}

#pragma mark - UI

- (void)setupViews {
    self.title = @"Environment";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
    //
    [HR_Network_UI hr_hiddenNetControl];
    //
    self.seg.selectedSegmentIndex = [HR_Network_ENVViewModel HR_Init].env;
    if (self.seg.selectedSegmentIndex == 2) {
        self.backView.hidden = NO;
    }
    //
    HR_Network_ENVModel *model = [HR_Network_ENVViewModel HR_Init].localEnv;
    model.protocol = model.protocol.length ? model.protocol : @"http";
    NSArray *contents = @[model.protocol, model.host, model.port, model.prefix];
    [self.tfs enumerateObjectsUsingBlock:^(UITextField * _Nonnull tf, NSUInteger idx, BOOL * _Nonnull stop) {
        tf.text = contents[idx];
    }];
}

#pragma mark Action

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segAction:(UISegmentedControl *)sender {
    [HR_Network_ENVViewModel HR_Init].env = sender.selectedSegmentIndex;
    self.backView.hidden = (sender.selectedSegmentIndex != 2);
}

- (IBAction)completeAction:(id)sender {
    
    HR_Network_ENVModel *model = [HR_Network_ENVModel new];
    UITextField *tf0 = (UITextField *)self.tfs[0];
    model.protocol = tf0.text;
    
    UITextField *tf1 = (UITextField *)self.tfs[1];
    model.host = tf1.text;
    
    UITextField *tf2 = (UITextField *)self.tfs[2];
    model.port = tf2.text;
    
    UITextField *tf3 = (UITextField *)self.tfs[3];
    model.prefix = tf3.text;
    
    [HR_Network_ENVViewModel HR_Init].localEnv = model;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
