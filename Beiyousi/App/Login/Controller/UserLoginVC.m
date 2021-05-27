//
//  UserLoginVC.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/9.
//

#import "UserLoginVC.h"
#import "forgetPassordVC.h"
#import "UserRoleModel.h"
#import "LoginAPI.h"
#import <AFNetworking/AFNetworking.h>
#import "selectRoleVC.h"
#import "MainViewController.h"
#import "UserInfoModel.h"
#import "CSTabBarVC.h"

@interface UserLoginVC ()

@property(nonatomic, strong)LoginAPI *loginApi;
@property(nonatomic, strong)UserRoleModel *userRoleModel;
@property (nonatomic, assign) BOOL isSelect;

@end

@implementation UserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginApi = [[LoginAPI alloc] init];
    
    LoginBtn.layer.cornerRadius = 22.0f;
    LoginBtn.clipsToBounds = NO;
    
    phoneText.clearButtonMode = UITextFieldViewModeAlways;
    pwdText.clearButtonMode   = UITextFieldViewModeAlways;
    [phoneText addTarget:self action:@selector(pnoneTextFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    
    pwdText.secureTextEntry = YES;
    [pwdText addTarget:self action:@selector(pwdTextFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
    
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchDown];
    [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchDown];
    [LoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchDown];
    [forgetBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchDown];
    [codeLoginBtn addTarget:self action:@selector(codeLoginBtnAction) forControlEvents:UIControlEventTouchDown];
    [protocolBtn addTarget:self action:@selector(protocolAction:) forControlEvents:UIControlEventTouchDown];
}

//登录
- (void)loginAction:(UIButton *)sender{
    if (!(self.isSelect)) {
        [MBProgressHUD showTip:@"选择协议"];
        return;;
    }
    if (phoneText.text.length<=0) {
        [MBProgressHUD showTip:@"请输入手机号码"];
        return;
    }
    if (phoneText.text.length<KMaxLength) {
        [MBProgressHUD showTip:@"手机号格式错误"];
        return;
    }
    if (pwdText.text.length<=0) {
        [MBProgressHUD showTip:@"请输入密码"];
        return;
    }
    if (pwdText.text.length<6) {
        [MBProgressHUD showTip:@"密码格式错误"];
        return;
    }
    [MBProgressHUD showLoading];
    [self.loginApi userLoginJsonApp:pwdText.text phone:phoneText.text success:^(id model) {
        NSString *codeMessage =model[@"result"];
        if ([codeMessage isEqualToString:@"FAILED"]) {
            [MBProgressHUD showTip:model[@"message"]];
        }else{
            NSDictionary *info = [model objectForKey:@"data"];
            UserRoleModel *userRoleModel = [[UserRoleModel alloc]initWithDictionary:info error:nil];
            self.userRoleModel = [[UserRoleModel alloc] init];
            self.userRoleModel = userRoleModel;
        
            if ([CommonMethod isEmpty:self.userRoleModel.lastType]) {
                [MBProgressHUD showTip:@"登录成功,选择角色"];
                selectRoleVC *roleVC = [[selectRoleVC alloc] init];
                roleVC.enterTypt = 1;
                roleVC.roleModel = userRoleModel;
                [self.navigationController pushViewController:roleVC animated:YES];
                [MBProgressHUD hide];
            }else{
                [self loadCheckTypeData];
            }
        }
    } failure:^(NSError *failure) {
        [MBProgressHUD hide];
    }];
}

//加载保持用户信息
- (void)loadCheckTypeData{
    [self.loginApi userCheckType:self.userRoleModel.id type:self.userRoleModel.lastType success:^(id model) {
        NSString *codeMessage =model[@"result"];
        if ([codeMessage isEqualToString:@"FAILED"]) {
            [MBProgressHUD showTip:model[@"message"]];
            [MBProgressHUD showTip:@"登录失败"];
            [MBProgressHUD hide];
        }else{
            [MBProgressHUD showTip:@"登录成功"];
            NSError *error;
            NSDictionary *infoDic = model[@"data"];
            UserInfoModel *userInfoMod = [[UserInfoModel alloc] initWithDictionary:infoDic error:&error];
            if (userInfoMod) {
                [[BYSUserHandle sharedInstance] saveLocalUser:userInfoMod];//保存用户信息
            }
            AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController = [[CSTabBarVC alloc] init];;
//            MainViewController *mainVC = [[MainViewController alloc] init];
//            [self.navigationController pushViewController:mainVC animated:YES];
            [MBProgressHUD hide];
        }
    } failure:^(NSError *failure) {
        [MBProgressHUD hide];
    }];
}

//获取手机号码
- (void)pnoneTextFieldEditChanged:(UITextField *)textField
{
    NSString *textString = textField.text;
    if (textField.text.length>KMaxLength) {
        textField.text = [textString substringToIndex:KMaxLength];
        [MBProgressHUD showTip:@"手机号格式错误"];
    }
    if (textField.text.length==KMaxLength && pwdText.text.length >= 6) {
        LoginBtn.backgroundColor = CLYColor(38, 157, 255, 1);
    }else{
        LoginBtn.backgroundColor = CLYColor(189, 224, 255, 1);
    }
}

//获取密码
- (void)pwdTextFieldEditChanged:(UITextField *)textField
{
    NSString *textString = textField.text;
    if (textField.text.length>KPwdMaxLength) {
        textField.text = [textString substringToIndex:KPwdMaxLength];
        [MBProgressHUD showTip:@"密码格式错误"];
    }
    if (textField.text.length>=6 && phoneText.text.length == KMaxLength) {
        LoginBtn.backgroundColor = CLYColor(38, 157, 255, 1);
    }else{
        LoginBtn.backgroundColor = CLYColor(189, 224, 255, 1);
    }
}

//单选框
- (void)switchAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [switchBtn setBackgroundImage:[UIImage imageNamed:@"register_icon_check_select"] forState:UIControlStateNormal];
        LoginBtn.backgroundColor = CLYColor(38, 157, 255, 1);
        self.isSelect = YES;
    }else{
        [switchBtn setBackgroundImage:[UIImage imageNamed:@"register_ icon_check_normal"] forState:UIControlStateNormal];
        LoginBtn.backgroundColor = CLYColor(189, 224, 255, 1);
        self.isSelect = NO;
    }
}

//隐私协议
- (void)protocolAction:(UIButton *)sender{
       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户隐私协议" message:@"您在使用我们的服务时，我们可能会收集和使用您的相关信息。 我们希望通过本《隐私政策》向您说明，在使用我们的服务时。 伏期黑就，全部金额不去酒吧表情包去任何我回去哦很热情和阿大使，大多数发生大阿斯顿发送到发送到发发发说的阿斯顿发送到发送到。发送到发阿斯顿发送到发的撒放。大发生的发生大发圈儿请问请问请问天气额头青铜器额头企鹅抬起头青铜器企鹅群二。" preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction *conform = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self->switchBtn setBackgroundImage:[UIImage imageNamed:@"register_icon_check_select"] forState:UIControlStateNormal];
           self->LoginBtn.backgroundColor = CLYColor(38, 157, 255, 1);
           self->LoginBtn.enabled = YES;
       }];
       UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           [self->switchBtn setBackgroundImage:[UIImage imageNamed:@"register_ icon_check_normal"] forState:UIControlStateNormal];
           self->LoginBtn.backgroundColor = CLYColor(189, 224, 255, 1);
           self->LoginBtn.enabled = NO;
       }];
    [alert addAction:conform];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

//忘记密码
- (void)forgetBtnAction{
    forgetPassordVC *forgetVC = [[forgetPassordVC alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

//用验证码登录
- (void)codeLoginBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
