//
//  CSTabBarVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/2.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSTabBarVC.h"
#import "CustomNavigationVC.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface CSTabBarVC ()

@end

@implementation CSTabBarVC

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[BYSUserHandle sharedInstance].userInfo);
    
    if ([BYSUserHandle sharedInstance].userInfo.accountId.length<=0) {
        NSArray *childItemsArray = @[
                                     @{kClassKey  : @"LoginVC",},
        ];

        [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
            CustomNavigationVC *nav = [[CustomNavigationVC alloc] initWithRootViewController:vc];
            [self addChildViewController:nav];
        }];
    }else{
        NSArray *childItemsArray = @[
                                     @{kClassKey  : @"MainViewController",
                                       kTitleKey  : @"首页",
                                       kImgKey    : @"tabbar_icon_homepage_nor",
                                       kSelImgKey : @"tabbar_icon_homepage_sel"},
    
                                     @{kClassKey  : @"CategoryViewController",
                                       kTitleKey  : @"分类",
                                       kImgKey    : @"tabbar_icon_sort_nor",
                                       kSelImgKey : @"tabbar_icon_sort_sel"},
    
                                     @{kClassKey  : @"WorksViewController",
                                     kTitleKey  : @"作业",
                                     kImgKey    : @"tabbar_icon_homework_nor",
                                     kSelImgKey : @"tabbar_icon_homework_sel"},
    
                                     @{kClassKey  : @"MineViewController",
                                     kTitleKey  : @"我的",
                                     kImgKey    : @"tabbar_icon_me_nor",
                                     kSelImgKey : @"tabbar_icon_me_sel"}
        ];
    
        [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
    //        vc.title = dict[kTitleKey];
            CustomNavigationVC *nav = [[CustomNavigationVC alloc] initWithRootViewController:vc];
            UITabBarItem *item = nav.tabBarItem;
            [[UITabBar appearance] setBarTintColor:BackColor];
            [UITabBar appearance].translucent = NO;
            item.title = dict[kTitleKey];
            item.image = [UIImage imageNamed:dict[kImgKey]];
            item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
            [self addChildViewController:nav];
        }];
    }
    if (@available(iOS 11.0, *)) {// 如果iOS 11走else的代码，系统自己的文字和箭头会出来
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 1) forBarMetrics:UIBarMetricsDefault];
        UIImage *backButtonImage = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [UINavigationBar appearance].backIndicatorImage = backButtonImage;
        [UINavigationBar appearance].backIndicatorTransitionMaskImage =backButtonImage;

    }else{
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 1) forBarMetrics:UIBarMetricsDefault];
        UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName :mainColor} forState:UIControlStateSelected];
    self.tabBar.tintColor = CLYColor(90, 194, 116, 1);
}

@end
