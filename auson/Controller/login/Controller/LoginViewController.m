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

static NSString *agreementString = @" 用户协议 ";
static NSString *privacyPolicyString = @" 隐私政策 ";

@interface LoginViewController ()<YBAttributeTapActionDelegate,UITextFieldDelegate>

@property (nonatomic, copy)       void(^complete)(BOOL success);
@property (nonatomic, strong)     UILabel *agreementLabel;

@property (nonatomic, strong)     UITextField *phoneTextField;
@property (nonatomic, strong)     UITextField *smsCodeTextField;
@property (nonatomic, strong)     UIButton *confromBtn;

@property (nonatomic, strong)     UIStackView *stackView;

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
    [self.view addSubview:self.stackView];
    [_agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-safeIphoneXFooter-30);
        make.centerX.mas_equalTo(0);
    }];
    [_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RH(120));
        make.width.mas_equalTo(RV(300));
        make.centerX.mas_equalTo(0);
    }];
    
    [_confromBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
    }];
    
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
    }];
    
    [_smsCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
    }];
    
}

- (void)makeView
{
    [self setRightButtonTitle:@"随便看看" titleColor:AccentColor];
}
#pragma mark - getter
- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.phoneTextField,self.smsCodeTextField,self.confromBtn]];
        _smsCodeTextField.hidden = YES;
        _stackView.spacing = 30;
        _stackView.axis = UILayoutConstraintAxisVertical;
    }
    return _stackView;
}
- (UITextField *)phoneTextField
{
    if (!_phoneTextField) {
        
        UITextField *textfield = [UITextField new];
        textfield.placeholder = @"请输入手机号";
        textfield.font = [UIFont fontWithName:FDFONT_PINGFANGSC_SEMIBOLD size:15];
        textfield.textColor = GTColor(@"#333333");
        textfield.delegate = self;
        textfield.keyboardType = UIKeyboardTypePhonePad;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *line = [UIView new];
        line.backgroundColor = GTColor(@"#f6f6f6");
        [textfield addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
//        textfield.backgroundColor = GTColor(@"#f6f6f6");
        
        _phoneTextField = textfield;
    }
    return _phoneTextField;
}

- (UITextField *)smsCodeTextField
{
    if (!_smsCodeTextField) {
        
        UITextField *textfield = [UITextField new];
        textfield.placeholder = @"请输入验证码";
        textfield.font = [UIFont fontWithName:FDFONT_PINGFANGSC_SEMIBOLD size:15];
        textfield.textColor = GTColor(@"#333333");
        textfield.delegate = self;
        textfield.keyboardType = UIKeyboardTypePhonePad;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *line = [UIView new];
        line.backgroundColor = GTColor(@"#f6f6f6");
        [textfield addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
//        textfield.backgroundColor = GTColor(@"#f6f6f6");
        
        _smsCodeTextField = textfield;
    }
    return _smsCodeTextField;
}
- (UIButton *)confromBtn
{
    if (!_confromBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = AccentColor;
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:15];
        btn.layer.cornerRadius = 6;
        [btn addTarget:self action:@selector(confromBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _confromBtn = btn;
    }
    return _confromBtn;
}

- (UILabel *)agreementLabel
{
    if (!_agreementLabel) {
        
        NSString *string3 = @"登录既表明同意";
    
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@和%@",string3,agreementString,privacyPolicyString]];
        [attrString addAttribute:NSForegroundColorAttributeName value:GTColor(@"#0e4b87") range:NSMakeRange(string3.length, agreementString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:GTColor(@"#0e4b87") range:NSMakeRange(string3.length + agreementString.length + 1, privacyPolicyString.length)];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:9];
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
- (void)confromBtnClick:(UIButton *)sender
{
    NSLog(@"下一步");
}

- (void)dismissWithLoginSuccess:(BOOL)loginSuccess
{
    __weak typeof(self) weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        !weakSelf.complete ? : weakSelf.complete(loginSuccess);
    }];
    
}

@end
