//
//  LoginViewController.m
//  auson
//
//  Created by zhangtong on 2021/5/12.
//

#import "LoginViewController.h"
#import "BaseNavViewController.h"

@interface LoginViewController ()

@property (nonatomic, copy) void(^complete)(BOOL success);

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
}

- (void)makeView
{
    [self setRightButtonTitle:@"随便看看" titleColor:GlobalColor];
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
