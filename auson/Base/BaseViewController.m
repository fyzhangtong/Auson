//
//  BaseViewController.m
//
//  Created by zhangtong on 16/10/17.
//

#import "BaseViewController.h"
#import "UIButton+EdgeInsets.h"

@interface BaseViewController ()
{
    UIView *_ZTPlayerControlBelowView;
}
@property (nonatomic, strong) UIButton *centerButton;       //中间按钮


@property (nonatomic, copy) void(^networkErrorOrNoDataViewButtonActionBlock)(void);

@end
@implementation BaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![self allowRotation]) {
        [self interfaceOrientationPortrait];
    }
}
/// 回到顶部
- (void)scrollToTop
{
    
}
#pragma mark - 右滑返回手势
- (BOOL)gestureRecognizerShouldBegin
{
    return YES;
}

- (BOOL)nextControllergestureRecognizerShouldBegin
{
    return YES;
}
#pragma mark - 设置状态栏颜色
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
        
    }
}

#pragma mark - getter
- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] init];
        _navigationView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_navigationView];
        [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.mas_equalTo(self.view);
            make.height.mas_equalTo(GTNAVIGATIONBARHEIGHT);
        }];
    }
    return _navigationView;
}
- (UIView *)ownNavigationBar
{
    if (!_ownNavigationBar) {
        _ownNavigationBar = [[UIView alloc] init];
        _ownNavigationBar.backgroundColor = [UIColor clearColor];
        [self.navigationView addSubview:_ownNavigationBar];
        [_ownNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(self.navigationView);
            make.height.mas_equalTo(44);
        }];
    }
    return _ownNavigationBar;
}

- (UIButton *)centerButton
{
    if (!_centerButton) {
        _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([self.navigationView.backgroundColor isEqual:[UIColor whiteColor]]) {
            [_centerButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        }else{
            [_centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        _centerButton.titleLabel.font = [UIFont fontWithName:FDFONT_PINGFANGSC_MEDIUM size:18.f];
        [_centerButton addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _centerButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.ownNavigationBar addSubview:_centerButton];
        [_centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_ownNavigationBar.mas_centerX);
            make.centerY.mas_equalTo(_ownNavigationBar.mas_centerY);
            make.width.mas_lessThanOrEqualTo(_ownNavigationBar.mas_width).multipliedBy(0.66);
        }];
    }
    return _centerButton;
}
- (UIButton *)leftBarButton
{
    if (!_leftBarButton) {
        _leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBarButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_leftBarButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.navigationView.backgroundColor isEqual:[UIColor whiteColor]]) {
            [_leftBarButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        }else{
            [_leftBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self.ownNavigationBar addSubview:_leftBarButton];
        [_leftBarButton expandSize:30];
        [_leftBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.ownNavigationBar);
            make.left.mas_equalTo(self.ownNavigationBar.mas_left).offset(15);
        }];
    }
    return _leftBarButton;
}

- (UIButton *)rightBarButton
{
    if (!_rightBarButton) {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_rightBarButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.navigationView.backgroundColor isEqual:[UIColor whiteColor]]) {
            [_rightBarButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        }else{
            [_rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self.ownNavigationBar addSubview:_rightBarButton];
        [_rightBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.ownNavigationBar);
            make.right.mas_equalTo(self.ownNavigationBar.mas_right).mas_offset(-15);
        }];
    }
    return _rightBarButton;
}


#pragma mark -  view
/**
 * @param alpha - 导航栏内容透明度
 */
- (void)setNavigationAlpha:(CGFloat)alpha
{
    if (alpha < 0) {
        alpha = 0;
    }else if (alpha > 1.0){
        alpha = 1;
    }
    //Navigation
    [self.navigationView setBackgroundColor:[_navigationView.backgroundColor colorWithAlphaComponent:alpha]];
    
}
/**
 设置导航栏中间view透明度
 
 @param alpha 透明度
 */
- (void)setNavigationCenterViewAlpha:(CGFloat)alpha
{
    if (alpha < 0) {
        alpha = 0;
    }else if (alpha > 1.0){
        alpha = 1;
    }
    //Navigation
    [self.centerButton setAlpha:alpha];
}
- (void)setCenterImage:(UIImage *)image;
{
    [self setCenterImage:image title:nil titleColor:nil];
}
- (void)setCenterTitle:(NSString *)title{
    [self setCenterImage:nil title:title titleColor:nil];
}
- (void)setCenterTitle:(NSString *)title titleColor:(UIColor *)color
{
    [self setCenterImage:nil title:title titleColor:color];
}
- (void)setCenterImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)color
{
    if (image) {
        [self.centerButton setImage:image forState:UIControlStateNormal];
        [self.centerButton setImage:image forState:UIControlStateHighlighted];
    }
    if (title) {
        [self.centerButton setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [self.centerButton setTitleColor:color forState:UIControlStateNormal];
    }
}

/*
 *创建黑色返回按钮
 */
- (void)addLeftBackButton
{
    if ([self.navigationView.backgroundColor isEqual:[UIColor whiteColor]]) {
        [self setLeftButtonImage:[UIImage imageNamed:@"back_black"]];
    }else{
        [self setLeftButtonImage:[UIImage imageNamed:@"back_wite"]];
    }
    
}
/// 添加右侧分享按钮
- (void)addRightShareButton
{
    if ([self.navigationView.backgroundColor isEqual:[UIColor whiteColor]]) {
        [self setRightButtonImage:[UIImage imageNamed:@"share_3.1"]];
    }else{
        [self setRightButtonImage:[UIImage imageNamed:@"navigation_bar_white_share"]];
    }
}

- (void)setLeftButtonImage:(UIImage *)image
{
    [self setLeftButtonImage:image hightlightImage:nil title:nil titleColor:nil];
}
- (void)setLeftButtonImage:(UIImage *)image hightlightImage:(UIImage *)hightlightImage
{
    [self setLeftButtonImage:image hightlightImage:hightlightImage title:nil titleColor:nil];
}
- (void)setLeftButtonTitle:(NSString *)title
{
    [self setLeftButtonImage:nil hightlightImage:nil title:title titleColor:nil];
}
- (void)setLeftButtonTitle:(NSString *)title titleColor:(UIColor *)color
{
    [self setLeftButtonImage:nil hightlightImage:nil title:title titleColor:color];
}

- (void)setLeftButtonNormalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage
{
    if (normalImage) {
        [self.leftBarButton setImage:normalImage forState:UIControlStateNormal];
    }
    if (selectImage) {
        [self.leftBarButton setImage:selectImage forState:UIControlStateSelected];
    }
}
- (void)setLeftButtonImage:(UIImage *)image title:(NSString *)title titleColor: (UIColor *)color
{
    [self setLeftButtonImage:image hightlightImage:nil title:title titleColor:color];
}
- (void)setLeftButtonImage:(UIImage *)image hightlightImage:(UIImage *)hightlightImage title:(NSString *)title titleColor: (UIColor *)color
{
    if (image) {
        [self.leftBarButton setImage:image forState:UIControlStateNormal];
        if (hightlightImage) {
            [self.leftBarButton setImage:hightlightImage forState:UIControlStateHighlighted];
        }
        
    }
    if (title) {
        [self.leftBarButton setTitle:title forState:UIControlStateNormal];
        if (color) {
            [self.leftBarButton setTitleColor:color forState:UIControlStateNormal];
        }
    }
}

- (void)rightButtonHide:(BOOL)hide
{
    self.rightBarButton.hidden = hide;
}

- (void)setRightButtonImage:(UIImage *)image
{
    [self setRightButtonImage:image hightlightImage:nil title:nil titleColor:nil];
}
- (void)setRightButtonImage:(UIImage *)image hightlightImage:(UIImage *)hightlightImage
{
    [self setRightButtonImage:image hightlightImage:hightlightImage title:nil titleColor:nil];
}
- (void)setRightButtonTitle:(NSString *)title
{
    [self setRightButtonImage:nil hightlightImage:nil title:title titleColor:nil];
}
- (void)setRightButtonTitle:(NSString *)title titleColor:(UIColor *)color
{
    [self setRightButtonImage:nil hightlightImage:nil title:title titleColor:color];
}
- (void)setRightButtonImage:(UIImage *)image hightlightImage:(UIImage *)hightlightImage title:(NSString *)title titleColor:(UIColor *)color
{
    if (image) {
        [self.rightBarButton setImage:image forState:UIControlStateNormal];
        if (hightlightImage) {
            [self.rightBarButton setImage:hightlightImage forState:UIControlStateHighlighted];
        }
    }
    if (title) {
        [self.rightBarButton setTitle:title forState:UIControlStateNormal];
        if (color) {
            [self.rightBarButton setTitleColor:color forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Action
- (void)centerButtonClick:(UIButton *)sender
{
    NSLog(@"中间按钮");
}
/**
 *左侧按钮点击事件
 */
- (void)leftButtonClick:(UIButton *)sender
{
    NSLog(@"左侧按钮");
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *右侧按钮点击事件
 */
- (void)rightButtonClick:(UIButton *)sender
{
    NSLog(@"右侧按钮");
    
}
- (void)playOrPause:(NSNotification *)noti
{
    
}
- (void)rightGifViewTapAction:(UITapGestureRecognizer *)sender
{
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)dealloc
{
    NSLog(@"dealloc:%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end



@implementation BaseViewController (InterfaceOrientation)

/// 横屏
- (void)interfaceOrientationLandscapeRight
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIDevice *device = [UIDevice currentDevice];
        [device setValue:@(UIDeviceOrientationLandscapeRight) forKey:@"orientation"];
    });
}
/// 竖屏
- (void)interfaceOrientationPortrait
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIDevice *device = [UIDevice currentDevice];
        if (device.orientation == UIDeviceOrientationPortrait) {
            [device setValue:@(UIDeviceOrientationPortraitUpsideDown) forKey:@"orientation"];
        }
        [device setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        
    });
}

/// 是否可以旋转屏幕，子类需要重写
- (BOOL)allowRotation
{
    return NO;
}
/// 是否锁屏，子类需要重写
- (BOOL)lockScreenStaue
{
    return NO;
}
@end
