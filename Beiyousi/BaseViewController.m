//
//  BaseViewController.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/8.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation BaseViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController) {
        if (self.navigationController.viewControllers[0] == self) {
            [self.tabBarController.tabBar setHidden:NO];
        } else {
             [self.tabBarController.tabBar setHidden:YES];
        }
    }
    
//    if (@available(iOS 11, *)) {
//        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
//    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

//隐藏导航栏
-(void)hiddenNavBar
{
    self.navigationController.navigationBarHidden = YES;
}

//显示导航栏
-(void)showNavBar{
    self.navigationController.navigationBarHidden = NO;
}

//tab隐藏、显示
-(void)hiddenTabBar{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)showTabBar{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BackColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]};
    [[UINavigationBar appearance]setTintColor:[UIColor blackColor]];
    
    if(@available(iOS 11, *)) {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-DEVICE_WIDTH*2, 0) forBarMetrics:UIBarMetricsDefault];
    } else {
        //去掉导航栏按钮的文字
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -DEVICE_WIDTH*2)forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.leftButton]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTap];
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 50, 44);
        [_leftButton setImage:[UIImage imageNamed:@"nav_back_Image"] forState:UIControlStateNormal];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
        [_leftButton addTarget:self action:@selector(defaultLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
//获取父类控制器
- (UIViewController *)superViewController {
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma mark 子类可以重写来实现不同的功能
- (void)defaultLeftBtnClick {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:  (UIGestureRecognizer *)otherGestureRecognizer
{
    [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
    return NO;
}

// 点击空白处收键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

@end
