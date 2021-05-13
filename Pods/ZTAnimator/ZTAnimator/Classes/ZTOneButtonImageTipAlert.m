//
//  OneButtonImageTipAlert.m
//  FanBookClub
//
//  Created by zhangtong on 2020/9/1.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ZTOneButtonImageTipAlert.h"

#import "NSString+AnimatorSize.h"
#import "Masonry.h"
#import "UIColor+RP.h"

#define IMAGE_TOP_MARGIN 18

#define TEXT_TOP_MAGIN 14
#define TEXT_WIDTH_MAX 240
#define TEXT_BUTTON_SPACE 18

#define BUTTON_HEIGHT 36
#define BUTTON_BOTTMO_MAGIN 30

@interface ZTOneButtonImageTipAlert ()

@property (nonatomic, copy) void(^buttonAction)(void);

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIFont *textFont;

@end

@implementation ZTOneButtonImageTipAlert

+ (void)showTipAlertInController:(UIViewController *)controller image:(UIImage *)image text:(NSString *)text buttonTitle:(NSString *)buttonTitle buttonAction:(void(^_Nullable)(void))buttonAction
{
    ZTOneButtonImageTipAlert *alert = [[ZTOneButtonImageTipAlert alloc] init];
    alert.imageView.image = image;
    alert.textLabel.text = text;
    [alert.button setTitle:buttonTitle forState:UIControlStateNormal];
    alert.buttonAction = buttonAction;
    [controller presentViewController:alert animated:YES completion:NULL];
}


- (void)setViewFrame
{
    CGFloat textHeight = [self.textLabel.text mh_sizeWithFont:self.textFont limitWidth:TEXT_WIDTH_MAX].height;
    CGFloat imageHeight = self.imageView.image.size.height;
    self.view.frame = CGRectMake(0, 0, 303, IMAGE_TOP_MARGIN + imageHeight+ TEXT_TOP_MAGIN + textHeight + TEXT_BUTTON_SPACE + BUTTON_HEIGHT + BUTTON_BOTTMO_MAGIN);
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
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.button];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(IMAGE_TOP_MARGIN);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(TEXT_TOP_MAGIN);
        make.width.mas_equalTo(TEXT_WIDTH_MAX);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-BUTTON_BOTTMO_MAGIN);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(BUTTON_HEIGHT);
        make.centerX.mas_equalTo(self.view);
    }];
}

#pragma mark - getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}
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
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _button.backgroundColor = [UIColor colorWithHexString:@"#FFD400"];
        _button.layer.cornerRadius = 18;
        _button.layer.masksToBounds = YES;
        [_button setTitleColor: [UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
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
        if (self.buttonAction) {
            self.buttonAction();
        }
    }];
    
}

@end
