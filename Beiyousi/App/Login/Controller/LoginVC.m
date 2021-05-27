//
//  LoginVC.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/9.
//

#import "LoginVC.h"
#import "UserLoginVC.h"
#import "sendCodeVC.h"
#import "LoginAPI.h"
#import "MBProgressHUD+Loading.h"

@interface LoginVC ()
@property(nonatomic ,strong)NSString *phoneNum;
@property (nonatomic, strong) LoginAPI *loginAPI;
@property (nonatomic, assign) BOOL isSelect;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginAPI = [[LoginAPI alloc] init];
    
    userCodeBtn.layer.cornerRadius = 22.0f;
    userCodeBtn.clipsToBounds = NO;

    phoneField.clearButtonMode = UITextFieldViewModeAlways;
    [phoneField addTarget:self action:@selector(pnoneTextFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
    phoneField.keyboardType = UIKeyboardTypeNumberPad;

    [switchBtton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchDown];
    [userCodeBtn addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchDown];
    [protocolLab addTarget:self action:@selector(protocolAction:) forControlEvents:UIControlEventTouchDown];
    [pwLoginBtn addTarget:self action:@selector(pwLoginAction) forControlEvents:UIControlEventTouchDown];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hiddenNavBar];
    [self hiddenTabBar];
}

//单选框
- (void)switchAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [switchBtton setBackgroundImage:[UIImage imageNamed:@"register_icon_check_select"] forState:UIControlStateNormal];
        userCodeBtn.backgroundColor = CLYColor(38, 157, 255, 1);
        self.isSelect = YES;
    }else{
        [switchBtton setBackgroundImage:[UIImage imageNamed:@"register_ icon_check_normal"] forState:UIControlStateNormal];
        userCodeBtn.backgroundColor = CLYColor(189, 224, 255, 1);
        self.isSelect = NO;
    }
}

//获取验证码
- (void)codeAction:(UIButton *)sender{
    
    if (!(self.isSelect)) {
        [MBProgressHUD showTip:@"选择协议"];
        return;;
    }
    if (phoneField.text.length<=0) {
        [MBProgressHUD showTip:@"请输入手机号码"];
        return;
    }
    if (phoneField.text.length<KMaxLength) {
        [MBProgressHUD showTip:@"手机号格式错误"];
        return;
    }

    [self.loginAPI smsLogin:phoneField.text success:^(id model) {
        NSString *codeMessage =model[@"result"];
        if ([codeMessage isEqualToString:@"FAILED"]) {
            [MBProgressHUD showTip:model[@"message"]];
        }else{
            sendCodeVC *codeVC = [[sendCodeVC alloc] init];
            codeVC.phoneNum = self->phoneField.text;
            [self.navigationController pushViewController:codeVC animated:YES];
        }
    } failure:^(NSError *failure) {

    }];
}

//获取手机号码
- (void)pnoneTextFieldEditChanged:(UITextField *)textField
{
    self.phoneNum = textField.text;
    if (textField.text.length>KMaxLength) {
        textField.text = [self.phoneNum substringToIndex:KMaxLength];
        [MBProgressHUD showTip:@"手机号格式错误"];
    }
    if (textField.text.length==KMaxLength) {
        userCodeBtn.backgroundColor = CLYColor(38, 157, 255, 1);
    }else{
        userCodeBtn.backgroundColor = CLYColor(189, 224, 255, 1);
    }
}


//密码登录
- (void)pwLoginAction{
    UserLoginVC *userLoginVC = [[UserLoginVC alloc] init];
    [self.navigationController pushViewController:userLoginVC animated:YES];
}

//隐私协议
- (void)protocolAction:(UIButton *)sender{
       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户隐私协议" message:@"您在使用我们的服务时，我们可能会收集和使用您的相关信息。 我们希望通过本《隐私政策》向您说明，在使用我们的服务时。 伏期黑就，全部金额不去酒吧表情包去任何我回去哦很热情和阿大使，大多数发生大阿斯顿发送到发送到发发发说的阿斯顿发送到发送到。发送到发阿斯顿发送到发的撒放。大发生的发生大发圈儿请问请问请问天气额头青铜器额头企鹅抬起头青铜器企鹅群二。" preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction *conform = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self->switchBtton setBackgroundImage:[UIImage imageNamed:@"register_icon_check_select"] forState:UIControlStateNormal];
           self->userCodeBtn.backgroundColor = CLYColor(38, 157, 255, 1);
           self->userCodeBtn.enabled = YES;
       }];
       UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           [self->switchBtton setBackgroundImage:[UIImage imageNamed:@"register_ icon_check_normal"] forState:UIControlStateNormal];
           self->userCodeBtn.backgroundColor = CLYColor(189, 224, 255, 1);
           self->userCodeBtn.enabled = NO;
       }];
    [alert addAction:conform];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
