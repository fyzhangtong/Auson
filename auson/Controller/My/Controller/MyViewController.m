//
//  MyViewController.m
//  auson
//
//  Created by zhangtong on 2021/5/11.
//

#import "MyViewController.h"
#import "LoginViewController.h"

@interface MyViewController ()

@property (nonatomic, strong)     UIButton *loginBtn;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeView];
}

- (void)makeView
{
    [self setCenterTitle:@"我的"];
    
    [self.view addSubview:self.loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(180, 40));
    }];
    
}
#pragma mark - getter
- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = GlobalColor;
        [btn setTitle:@"登陆\\注册" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:FDFONT_PINGFANGSC_MEDIUM size:15];
        btn.layer.cornerRadius = 6;
        [btn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn = btn;
    }
    return _loginBtn;
}
#pragma mark - action
- (void)loginBtnClick:(UIButton *)sender
{
    [LoginViewController loginWithComplete:NULL];
}

@end
