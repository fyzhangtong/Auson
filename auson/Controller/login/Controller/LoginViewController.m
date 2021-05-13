//
//  LoginViewController.m
//  auson
//
//  Created by zhangtong on 2021/5/12.
//

#import "LoginViewController.h"
#import "BaseNavViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "ZTWebViewController.h"

static NSString *agreementString = @"《auson用户协议》";
static NSString *privacyPolicyString = @"《auson隐私政策》";

@interface LoginViewController ()<YBAttributeTapActionDelegate>

@property (nonatomic, copy)       void(^complete)(BOOL success);
@property (nonatomic, strong)     UILabel *agreementLabel;

@end

@implementation LoginViewController

+ (void)loginWithComplete:(void(^__nullable)(BOOL success))complete
{
    if ([[ZTUtil getCurrentVC] isKindOfClass:[LoginViewController class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *value =[NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        NSNumber *curenValue = @([UIDevice currentDevice].orientation);
        if (![curenValue isEqual:value]) {
            [UIView animateWithDuration:0.25 animations:^{
                NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
                [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
                
            }];
        }
        LoginViewController *landVC = [[LoginViewController alloc] init];
        landVC.complete = complete;
        BaseNavViewController *bnvc = [[BaseNavViewController alloc] initWithRootViewController:landVC];
        [[ZTUtil getCurrentVC] presentViewController:bnvc animated:YES completion:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeView];
    [self.view addSubview:self.agreementLabel];
    [_agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-safeIphoneXFooter-30);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)makeView
{
    [self setRightButtonTitle:@"随便看看" titleColor:GlobalColor];
}
#pragma mark - getter
- (UILabel *)agreementLabel
{
    if (!_agreementLabel) {
        
        NSString *string3 = @"登陆代表同意并愿意遵守";
    
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@和%@",string3,agreementString,privacyPolicyString]];
        [attrString addAttribute:NSForegroundColorAttributeName value:GlobalColor range:NSMakeRange(string3.length+1, agreementString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:GlobalColor range:NSMakeRange(string3.length+1 + agreementString.length + 1, privacyPolicyString.length)];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:12];
        label.textColor = GTColor(@"#333333");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.attributedText =  attrString;
        
        label.enabledTapEffect = NO;
        [label yb_addAttributeTapActionWithStrings:@[agreementString,privacyPolicyString] delegate:self];
        _agreementLabel = label;
    }
    return _agreementLabel;
}
#pragma mark - YBAttributeTapActionDelegate
- (void)yb_tapAttributeInLabel:(UILabel *)label string:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    if ([string isEqualToString:agreementString]) {
        [ZTWebViewController openUrl:@"https://baidu.com" controller:self];
    }else{
        [ZTWebViewController openUrl:@"https://www.toutiao.com/" controller:self];
    }
}

#pragma mark - action
- (void)rightButtonClick:(UIButton *)sender
{
    [self dismissWithLoginSuccess:NO];
}

- (void)dismissWithLoginSuccess:(BOOL)loginSuccess
{
    __weak typeof(self) weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        !weakSelf.complete ? : weakSelf.complete(loginSuccess);
    }];
    
}

@end
