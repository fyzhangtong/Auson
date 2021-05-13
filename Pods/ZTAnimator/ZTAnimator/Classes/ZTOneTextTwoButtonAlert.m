//
//  OneTextTwoButtonAlert.m
//  FanBookClub
//
//  Created by zhangtong on 2019/11/30.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "ZTOneTextTwoButtonAlert.h"
#import "NSString+AnimatorSize.h"
#import "Masonry.h"
#import "UIColor+RP.h"

#define TEXT_TOP_MAGIN 30
#define TEXT_WIDTH_MAX 240
#define TEXT_BUTTON_SPACE 30
#define BUTTON_HEIGHT 35
#define BUTTON_BOTTMO_MAGIN 24

@interface ZTOneTextTwoButtonAlert ()

@property (nonatomic, copy) void(^leftButtonAction)(void);
@property (nonatomic, copy) void(^rightButtonAction)(void);

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIFont *textFont;

@end

@implementation ZTOneTextTwoButtonAlert

+ (void)showOneTextTwoButtonAlertInController:(UIViewController *)controller text:(NSString *)text leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftButtonAction:(void(^_Nullable)(void))leftButtonAction rightButtonAction:(void(^)(void))rightButtonAction
{
    ZTOneTextTwoButtonAlert *alert = [[ZTOneTextTwoButtonAlert alloc] init];
    alert.textLabel.text = text;
    [alert.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
    [alert.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    alert.leftButtonAction = leftButtonAction;
    alert.rightButtonAction = rightButtonAction;
    [controller presentViewController:alert animated:YES completion:NULL];
}


- (void)setViewFrame
{
    CGFloat textHeight = [self.textLabel.text mh_sizeWithFont:self.textFont limitWidth:TEXT_WIDTH_MAX].height;
    self.view.frame = CGRectMake(0, 0, 303, TEXT_TOP_MAGIN + textHeight + TEXT_BUTTON_SPACE + BUTTON_HEIGHT + BUTTON_BOTTMO_MAGIN);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeView];
}
- (void)makeView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 15;
    
    [self.view addSubview:self.textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(TEXT_TOP_MAGIN);
        make.width.mas_equalTo(TEXT_WIDTH_MAX);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.leftButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-BUTTON_BOTTMO_MAGIN);
        make.width.mas_equalTo(105);
        make.height.mas_equalTo(BUTTON_HEIGHT);
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(-60);
    }];
    [self.view addSubview:self.rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.leftButton.mas_bottom);
        make.width.mas_equalTo(self.leftButton.mas_width);
        make.height.mas_equalTo(self.leftButton.mas_height);
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(60);
    }];
}

#pragma mark - getter
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = self.textFont;
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _textLabel;
}
- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _leftButton.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        _leftButton.layer.cornerRadius = BUTTON_HEIGHT/2.0;
        _leftButton.layer.masksToBounds = YES;
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _leftButton;
}
- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _rightButton.backgroundColor = [UIColor colorWithHexString:@"#FFD400"];
        _rightButton.layer.cornerRadius = BUTTON_HEIGHT/2.0;
        _rightButton.layer.masksToBounds = YES;
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _rightButton;
}
- (UIFont *)textFont
{
    if (!_textFont) {
        _textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _textFont;
}
#pragma mark - action
- (void)leftButtonClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.leftButtonAction) {
            self.leftButtonAction();
        }
    }];
    
}
- (void)rightButtonClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.rightButtonAction) {
            self.rightButtonAction();
        }
    }];
    
}

@end
