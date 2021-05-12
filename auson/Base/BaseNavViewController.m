//
//  BaseNavViewController.m
//
//  Created by zhangtong on 16/10/17.
//

#import "BaseNavViewController.h"
#import "BaseViewController.h"

@interface BaseNavViewController ()<UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer *popRecognizer;
    UIView *gestureView;
}
@end

@implementation BaseNavViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.viewControllers.count>=2) {
        BaseViewController *vc = (BaseViewController *)self.topViewController;
        BaseViewController *lastVC = self.viewControllers[self.viewControllers.count-2];
        if ([vc gestureRecognizerShouldBegin] && [lastVC nextControllergestureRecognizerShouldBegin]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
} 

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
