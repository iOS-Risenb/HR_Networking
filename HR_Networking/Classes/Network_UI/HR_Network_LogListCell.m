

#import "HR_Network_LogListCell.h"
#import "HR_Network_LogModel.h"

@interface HR_Network_LogListCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;

@end

@implementation HR_Network_LogListCell

- (void)setModel:(HR_Network_LogModel *)model {
    _model = model;
    UIColor *selectedColor = [UIColor colorWithRed:32 / 255.0 green:136 / 255.0 blue:22 / 255.0 alpha:1];
    self.mainLabel.textColor = model.requestStatus ? selectedColor : [UIColor redColor];
    NSString *method;
    switch (model.requestMethod) {
        case HR_Net_Method_GET:
            method = @"GET";
            break;
        case HR_Net_Method_POST:
            method = @"POST";
            break;
        case HR_Net_Method_FORM:
            method = @"FORM";
            break;
    }
    self.mainLabel.text = [NSString stringWithFormat:@"[M]:\t%@\n[U]:\t%@\n[P]:\t%@", method, model.requestUrl, model.requestPara];
}

@end
