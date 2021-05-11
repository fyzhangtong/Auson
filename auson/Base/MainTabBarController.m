//
//  MainTabBarController.m
//  FanBookClub
//
//  Created by FDXDZ on 2019/3/12.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavViewController.h"
#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "MyViewController.h"

#import "UIImage+ImageWithColor.h"
#import "UIView+ZTCAAnimation.h"

#define TITLE_STRING_HOME @"首页"
#define TITLE_STRING_DISCORVER @"发现"
#define TITLE_STRING_MY @"我的"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) BaseNavViewController *parentNavtgationController;
@property (nonatomic, strong) BaseNavViewController *myNavtgationController;
@property (nonatomic, strong) BaseNavViewController *readNavtgationController;


@end

@implementation MainTabBarController

+ (instancetype)mainTabBarController
{
    static MainTabBarController *tabBarController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarController = [[MainTabBarController alloc] init];
    });
    
    return tabBarController;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.viewControllers = @[self.readNavtgationController,self.parentNavtgationController,self.myNavtgationController];
        [self customizeTabBarAppearance];
    }
    return self;
}
#pragma mark - getter
- (BaseNavViewController *)readNavtgationController
{
    if (!_readNavtgationController) {
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        homeVC.hidesBottomBarWhenPushed = NO;
        _readNavtgationController = [[BaseNavViewController alloc]
                                                            initWithRootViewController:homeVC];
        _readNavtgationController.tabBarItem.image = [[UIImage imageNamed:@"dushu_icon_index"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _readNavtgationController.tabBarItem.title = TITLE_STRING_HOME;
        _readNavtgationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"dushu_icon_index_visit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _readNavtgationController;
}
- (BaseNavViewController *)parentNavtgationController
{
    if (!_parentNavtgationController) {
        DiscoverViewController *plvc = [[DiscoverViewController alloc] init];
//        ParentViewController *plvc = [[ParentViewController alloc] init];
        plvc.hidesBottomBarWhenPushed = NO;
        _parentNavtgationController = [[BaseNavViewController alloc]
                                                             initWithRootViewController:plvc];
        _parentNavtgationController.tabBarItem.image = [[UIImage imageNamed:@"jiazhang_icon_index"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _parentNavtgationController.tabBarItem.title = TITLE_STRING_DISCORVER;
        _parentNavtgationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"jiazhang_icon_index_visit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _parentNavtgationController;
}
- (BaseNavViewController *)myNavtgationController
{
    if (!_myNavtgationController) {
        MyViewController *mVC = [[MyViewController alloc] init];
        mVC.hidesBottomBarWhenPushed = NO;
        _myNavtgationController = [[BaseNavViewController alloc]
                                                            initWithRootViewController:mVC];
        _myNavtgationController.tabBarItem.image = [[UIImage imageNamed:@"wode_icon_index"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _myNavtgationController.tabBarItem.title = TITLE_STRING_MY;
        _myNavtgationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"wode_icon_index_visit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _myNavtgationController;
}
/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance {
        
    
     if (@available(iOS 13.0, *)) {
         UITabBarAppearance *standardAppearance = [[UITabBarAppearance alloc] init];
         UITabBarItemAppearance *inlineLayoutAppearance = [[UITabBarItemAppearance  alloc] init];
         [inlineLayoutAppearance.normal setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#CCCCCC"],NSFontAttributeName:[UIFont fontWithName:FDFONT_PINGFANGSC_MEDIUM size:10]}];
         [inlineLayoutAppearance.selected setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],NSFontAttributeName:[UIFont fontWithName:FDFONT_PINGFANGSC_MEDIUM size:10]}];
         standardAppearance.stackedLayoutAppearance = inlineLayoutAppearance;
         standardAppearance.backgroundColor = [UIColor whiteColor];
         standardAppearance.shadowImage = [UIImage createImageWithColor:[UIColor colorWithHexString:@"#F8F8F8"]];
         self.tabBar.standardAppearance = standardAppearance;
     }else{
         [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#CCCCCC"],NSFontAttributeName:[UIFont fontWithName:FDFONT_PINGFANGSC_MEDIUM size:10]} forState:UIControlStateNormal];
         [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],NSFontAttributeName:[UIFont fontWithName:FDFONT_PINGFANGSC_MEDIUM size:10]} forState:UIControlStateSelected];
         [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
         [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
         [[UITabBar appearance] setShadowImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#F8F8F8"]]];
     }
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if ([self.selectedViewController.tabBarItem.title isEqualToString:viewController.tabBarItem.title]) {
        BaseNavViewController *bnvc = (BaseNavViewController *)viewController;
        BaseViewController *bvc = (BaseViewController *)bnvc.topViewController;
        [bvc scrollToTop];
    }else{
        //执行动画
        [MainTabBarController playAnimation:tabBarController controller:viewController];
        
    }
    return YES;
}
+ (void)playAnimation:(UITabBarController *)tabBarController controller:(UIViewController *)viewController
{
    for (UIView *tabBarButton in tabBarController.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
             for (UIView *tabBarButtonSubView in tabBarButton.subviews) {
                 if ([tabBarButtonSubView isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) {
                      UILabel *label = (UILabel *)tabBarButtonSubView;
                     if ([label.text isEqualToString:viewController.tabBarItem.title] ) {
                         for (UIView *imageView in tabBarButton.subviews) {
                             if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                                 [imageView addLikeAnimatrion];
                             }
                         }
                     }
                 }
             }
        }
    }
}

@end
