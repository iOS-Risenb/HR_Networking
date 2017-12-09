

#import "HR_Network_LogListViewController.h"
#import "HR_Network_LogViewModel.h"
#import "HR_Network_LogListCell.h"
#import "HR_Network_LogDetailViewController.h"
#import "HR_Network_UI.h"

@interface HR_Network_LogListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) HR_Network_LogViewModel *viewModel;

@end

@implementation HR_Network_LogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [HR_Network_UI hr_showNetControl];
}

#pragma mark - Privte Methods 

- (void)setupViews {
    self.title = @"Request List";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HR_Network_LogListCell" bundle:[NSBundle bundleForClass:NSClassFromString(@"HR_Network_LogListCell")]] forCellReuseIdentifier:@"HR_Network_LogListCell"];
    self.mainTableView.estimatedRowHeight = 30;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    
    [HR_Network_UI hr_hiddenNetControl];
}

#pragma mark Action

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Protocol Methods

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HR_Network_LogListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HR_Network_LogListCell" forIndexPath:indexPath];
    cell.model = self.viewModel.modelArray[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HR_Network_LogDetailViewController *vc = [[HR_Network_LogDetailViewController alloc] initWithNibName:@"HR_Network_LogDetailViewController" bundle:[NSBundle bundleForClass:NSClassFromString(@"HR_Network_LogDetailViewController")]];
    vc.model = self.viewModel.modelArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy Loading

- (HR_Network_LogViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HR_Network_LogViewModel alloc] init];
    }
    return _viewModel;
}

@end
