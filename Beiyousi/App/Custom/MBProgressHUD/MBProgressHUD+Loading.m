//
//  MBProgressHUD+Loading.m
//  anrigo
//
//  Created by Liu Zhen on 11/23/14.
//  Copyright (c) 2014 ft. All rights reserved.
//

#import "MBProgressHUD+Loading.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@implementation MBProgressHUD (Loading)

static MBProgressHUD *hud = nil;

+ (void)hide
{
    [hud hideAnimated:YES];
}

+ (MBProgressHUD *)createHUD{
    MBProgressHUD * progressHud = nil;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;
    
    if(window.rootViewController)
    {
        if([window.rootViewController isKindOfClass:[UITabBarController class]]){
            UITabBarController *tabBarVC = (UITabBarController *)window.rootViewController;
            if(tabBarVC.presentedViewController){
                progressHud = [MBProgressHUD showHUDAddedTo:tabBarVC.presentedViewController.view animated:YES];
                return progressHud;
            }
        }
        progressHud = [MBProgressHUD showHUDAddedTo:window.rootViewController.view animated:YES];
    }
    return progressHud;
}

+ (void)showWithImage:(NSString *)imageName title:(NSString *)title
{
    if (hud) {
        [hud hideAnimated:YES];
    }
    
    hud = [MBProgressHUD createHUD];
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    hud.customView = imageView;
    hud.label.text = title;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (void)showCompleted{
    
    UIImageView *imageView;
    UIImage *image = [UIImage imageNamed:@"37x-Checkmark"];
    imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = @"完成";
    
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (void)showLoading
{
    if (hud) {
        [hud hideAnimated:YES];
    }
    hud = [MBProgressHUD createHUD];
    
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UIWindow *window = delegate.window;
//    
//    if(window.rootViewController){
//         hud = [MBProgressHUD showHUDAddedTo:window.rootViewController.view animated:YES];
//    }
//    else{
//        hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
//    }
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation( - M_PI, 0, 0, 1)];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.duration = 0.5f;
    transformAnimation.autoreverses = NO;
    transformAnimation.repeatCount = HUGE_VALF;
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [imageView.layer addAnimation:transformAnimation forKey:@"LogindAnimation"];

    hud.customView = imageView;
    
    hud.removeFromSuperViewOnHide = YES;
}



+ (void)showTip:(NSString *)tip {
    
    if (hud) {
        [hud hideAnimated:YES];
    }

    hud = [MBProgressHUD createHUD];
    hud.detailsLabel.font = [UIFont systemFontOfSize:13];
    hud.detailsLabel.text = tip;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = CLYColor(72, 72, 73, 1);
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    NSInteger length = tip.length;
    if(length > 30)
    {
        length = 30;
    }
    [hud hideAnimated:YES afterDelay:2];
}

+ (void)showLoadingWithTip:(NSString *)tip
{
    [self showLoading];
    hud.label.text = tip;
}

+ (void)resetAnimation
{
    if(hud.customView && hud.mode == MBProgressHUDModeCustomView)
    {
        if([hud.customView isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView *)hud.customView;
            
            CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation( - M_PI, 0, 0, 1)];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
            transformAnimation.duration = 0.5f;
            transformAnimation.autoreverses = NO;
            transformAnimation.repeatCount = HUGE_VALF;
            transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            
            [imageView.layer removeAnimationForKey:@"LogindAnimation"];
            [imageView.layer addAnimation:transformAnimation forKey:@"LogindAnimation"];
        }
    }
}
+(void)showLoadingWithView:(UIView *)view{
    if (hud) {
        [hud hideAnimated:YES];
    }
    
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
}
@end
