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
#import "UIImage+ImageWithColor.h"
#import "MKCoutDownTimer.h"

static NSString *agreementString = @" 用户协议 ";
static NSString *privacyPolicyString = @" 隐私政策 ";

typedef NS_ENUM(NSInteger) {
    LoginTypeSMSCode = 0,
    LoginTypePassword = 1
}LoginType;

@interface LoginViewController ()<YBAttributeTapActionDelegate,UITextFieldDelegate>

@property (nonatomic, copy)       void(^complete)(BOOL success);
@property (nonatomic, strong)     UILabel *agreementLabel;
@property (nonatomic, strong)     UILabel *headerTitleLabel;
@property (nonatomic, strong)     UITextField *phoneTextField;
@property (nonatomic, strong)     UITextField *smsCodeTextField;
@property (nonatomic, strong)     UITextField *passwordTextField;
@property (nonatomic, strong)     UIButton *modelChangeBtn;
@property (nonatomic, strong)     UIButton *confromBtn;
@property (nonatomic, strong)     UIButton *sendSMSCodeBtn;
@property (nonatomic, strong)     UIStackView *stackView;

@property (nonatomic, assign)     LoginType loginType;

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
    
    self.loginType = LoginTypeSMSCode;
}

- (void)makeView
{
    [self setRightButtonTitle:@"随便看看" titleColor:GlobalColor];
    [self.view addSubview:self.headerTitleLabel];
    [self.view addSubview:self.stackView];
    [self.view addSubview:self.modelChangeBtn];
    [self.view addSubview:self.confromBtn];
    [self.view addSubview:self.agreementLabel];
    
    [_headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RH(120));
        make.left.mas_equalTo(self.stackView);
    }];
    
    [_agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-safeIphoneXFooter-30);
        make.centerX.mas_equalTo(0);
    }];
    [_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerTitleLabel.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(RV(335));
        make.centerX.mas_equalTo(0);
    }];
    
    [_modelChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stackView.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.stackView);
    }];
    
    [_confromBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.modelChangeBtn.mas_bottom).mas_offset(40);
        make.left.right.mas_equalTo(self.stackView);
        make.height.mas_equalTo(50);
    }];
    
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
    }];
    
    [_smsCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.phoneTextField);
    }];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.phoneTextField);
    }];
}
#pragma mark - getter
- (UILabel *)headerTitleLabel
{
    if (!_headerTitleLabel) {
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:30];
        label.textColor = TextColor333;
        label.text = @"手机号登录";
        _headerTitleLabel = label;
    }
    return _headerTitleLabel;
}
- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.phoneTextField,self.smsCodeTextField,self.passwordTextField]];
        
        _stackView.spacing = 5;
        _stackView.axis = UILayoutConstraintAxisVertical;
    }
    return _stackView;
}
- (UITextField *)phoneTextField
{
    if (!_phoneTextField) {
        
        UITextField *textfield = [UITextField new];
        textfield.placeholder = @"请输入手机号";
        textfield.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:17];
        textfield.textColor = TextColor333;
        textfield.delegate = self;
        textfield.keyboardType = UIKeyboardTypePhonePad;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:17];
        label.textColor = TextColor333;
        label.text = @"手机号";
        
        textfield.leftView = label;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = GTColor(@"#f6f6f6");
        [textfield addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        _phoneTextField = textfield;
    }
    return _phoneTextField;
}
- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        
        UITextField *textfield = [UITextField new];
        textfield.placeholder = @"请输入密码";
        textfield.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:17];
        textfield.textColor = TextColor333;
        textfield.delegate = self;
        textfield.keyboardType = UIKeyboardTypePhonePad;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:17];
        label.textColor = TextColor333;
        label.text = @"密码";
        
        textfield.leftView = label;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = GTColor(@"#f6f6f6");
        [textfield addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        _passwordTextField = textfield;
    }
    return _passwordTextField;
}

- (UITextField *)smsCodeTextField
{
    if (!_smsCodeTextField) {
        
        UITextField *textfield = [UITextField new];
        textfield.placeholder = @"请输入验证码";
        textfield.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:17];
        textfield.textColor = TextColor333;
        textfield.delegate = self;
        textfield.keyboardType = UIKeyboardTypePhonePad;
        [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:17];
        label.textColor = TextColor333;
        label.text = @"验证码";
        
        
        textfield.leftView = label;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
        }];
        
        textfield.rightView = self.sendSMSCodeBtn;
        textfield.rightViewMode = UITextFieldViewModeAlways;
        [_sendSMSCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(24);
        }];
        
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
- (UIButton *)sendSMSCodeBtn
{
    if (!_sendSMSCodeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:@"  获取验证码  " forState:UIControlStateNormal];
        [btn setTitleColor:TextColor333 forState:UIControlStateNormal];
        [btn setTitleColor:TextColor999 forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:12];
        [btn addTarget:self action:@selector(sendSMSCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 4;
        btn.layer.borderColor = TextColor333.CGColor;
        btn.layer.borderWidth = 1;
        _sendSMSCodeBtn = btn;
    }
    return _sendSMSCodeBtn;
}
- (UIButton *)modelChangeBtn
{
    if (!_modelChangeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"用验证码登录" forState:UIControlStateNormal];
        [btn setTitleColor:GTColor(@"#0e4b87") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:FDFONT_HYT_REGULAR size:14];
        [btn addTarget:self action:@selector(modelChangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _modelChangeBtn = btn;
    }
    return _modelChangeBtn;
}
- (UIButton *)confromBtn
{
    if (!_confromBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage createImageWithColor:GlobalColor] forState:UIControlStateNormal];
        [btn setTitleColor:TextColor999 forState:UIControlStateDisabled];
        [btn setBackgroundImage:[UIImage createImageWithColor:DisableColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:20];
        btn.layer.cornerRadius = 6;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
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
        label.font = [UIFont fontWithName:FDFONT_PINGFANGSC_REGULAR size:12];
        label.textColor = TextColor333;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.attributedText =  attrString;
        
        label.enabledTapEffect = NO;
        [label yb_addAttributeTapActionWithStrings:@[agreementString,privacyPolicyString] delegate:self];
        _agreementLabel = label;
    }
    return _agreementLabel;
}
#pragma mark - setter
- (void)setLoginType:(LoginType)loginType
{
    _loginType = loginType;
    if (loginType == LoginTypeSMSCode) {
        /// 验证码登录
        self.passwordTextField.text = @"";
        self.passwordTextField.hidden = YES;
        self.smsCodeTextField.hidden = NO;
        [self.modelChangeBtn setTitle:@"用密码登录" forState:UIControlStateNormal];
    }else{
        /// 密码登录
        self.smsCodeTextField.text = @"";
        self.smsCodeTextField.hidden = YES;
        self.passwordTextField.hidden = NO;
        [self.modelChangeBtn setTitle:@"用验证码登录" forState:UIControlStateNormal];
    }
}
#pragma mark - UITextFieldDelegate
/// 限制只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    /// 手机号和验证码输入框只能输入数字
    if (textField == self.phoneTextField || textField == self.smsCodeTextField) {
        
        NSInteger maxLength = textField == self.phoneTextField ? 11 : 6;
        if (textField.text.length >= maxLength) {
            return NO;
        }
        NSString *validRegEx =@"^[0-9]$";
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        if(myStringMatchesRegEx) {
            return YES;
        }
        return NO;
    }
    return YES;
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
#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - action
- (void)rightButtonClick:(UIButton *)sender
{
    [self dismissWithLoginSuccess:NO];
}
- (void)sendSMSCodeBtnClick:(UIButton *)sender
{
    if (self.phoneTextField.text.length != 11) {
        [MBProgressHUD showWindowBlackHudWithTitle:@"请先输入正确手机号" hideAfterDelay:1];
        return;
    }
    self.sendSMSCodeBtn.layer.borderColor = TextColor999.CGColor;
    self.sendSMSCodeBtn.enabled = NO;
    
    __weak typeof(self) weakSelf = self;

    [MKCoutDownTimer timerWithCountdownTime:10 rate:1 executeBlock:^(int second) {
        [weakSelf.sendSMSCodeBtn setTitle:[NSString stringWithFormat:@"  %ds后重新获取  ",second] forState:UIControlStateDisabled];
    } endBlock:^{
        weakSelf.sendSMSCodeBtn.enabled = YES;
        weakSelf.sendSMSCodeBtn.layer.borderColor = TextColor333.CGColor;
    }];
}
- (void)confromBtnClick:(UIButton *)sender
{
    NSLog(@"下一步");
}
- (void)modelChangeBtnClick:(UIButton *)sender
{
    self.loginType = self.loginType == LoginTypeSMSCode ? LoginTypePassword : LoginTypeSMSCode;
}
- (void)textFieldDidChange:(UITextField *)sender
{
    if (sender != self.phoneTextField) {
        self.confromBtn.enabled = sender.text.length >= 1 && self.phoneTextField.text.length == 11;
    }
}

- (void)dismissWithLoginSuccess:(BOOL)loginSuccess
{
    __weak typeof(self) weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        !weakSelf.complete ? : weakSelf.complete(loginSuccess);
    }];
    
}

@end
