//
//  BaseViewController.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/8.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIButton *leftButton;

- (UIViewController *)superViewController;

- (void)defaultLeftBtnClick;//返回方法

//tab隐藏、显示
-(void)hiddenTabBar;
-(void)showTabBar;

//隐藏导航栏
-(void)hiddenNavBar;

//显示导航栏
-(void)showNavBar;

@end

NS_ASSUME_NONNULL_END
