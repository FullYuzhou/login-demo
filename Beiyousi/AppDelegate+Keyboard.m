//
//  AppDelegate+Keyboard.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/11/30.
//

#import "AppDelegate+Keyboard.h"
#import "IQKeyboardManager.h"

@implementation AppDelegate (Keyboard)

-(void)configKeyboard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
}

@end
