//
//  forgetPassordVC.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/9.
//

#import "forgetPassordVC.h"
#import "QiCountdownButton.h"
#import "LoginAPI.h"

@interface forgetPassordVC ()
{
    QiCountdownButton *countdownButton;
}

@property(nonatomic, strong)LoginAPI *loginApi;

@end

@implementation forgetPassordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginApi = [[LoginAPI alloc] init];
    
    surePsdBtn.layer.cornerRadius = 22.0f;
    surePsdBtn.clipsToBounds      = NO;
    
    countdownButton = [QiCountdownButton buttonWithType:UIButtonTypeCustom];
    countdownButton.timeInterval = 1.0;
    countdownButton.maxInteger = 60;
    countdownButton.minInteger = 0;
    countdownButton.layer.cornerRadius = 16;  // 将图层的边框设置为圆脚
    countdownButton.layer.masksToBounds = YES; // 隐藏边界
    [countdownButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [countdownButton setBackgroundColor:mainColor];
    [countdownButton setTitleColor:BackColor forState:UIControlStateNormal];
    [countdownButton setTitleColor:BackColor forState:UIControlStateDisabled];
    [countdownButton addTarget:self action:@selector(countdownButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    countdownButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    countdownButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [countdownButton sizeToFit];
    [self.view addSubview:countdownButton];
    
    [countdownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(codeText.mas_top).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.offset(32);
        make.width.offset(92);
    }];

    phoneText.clearButtonMode       = UITextFieldViewModeAlways;
    phoneText.keyboardType          = UIKeyboardTypeNumberPad;
    codeText.clearButtonMode        = UITextFieldViewModeAlways;
    codeText.keyboardType           = UIKeyboardTypeNumberPad;

    [phoneText addTarget:self action:@selector(pnoneTextFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
    [codeText addTarget:self action:@selector(pnoneTextFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
    [psdText addTarget:self action:@selector(psdTextFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
    [psdRepeatTest addTarget:self action:@selector(psdRepeatTestFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchDown];
    [surePsdBtn addTarget:self action:@selector(surePsdBtnAction) forControlEvents:UIControlEventTouchDown];
    [pwdBtn addTarget:self action:@selector(pwdBtnAction:) forControlEvents:UIControlEventTouchDown];
    [pwdRepeatBtn addTarget:self action:@selector(pwdRepeatBtnAction:) forControlEvents:UIControlEventTouchDown];
}

//确定
- (void)surePsdBtnAction{
    if (phoneText.text.length<=0) {
        [MBProgressHUD showTip:@"请输入手机号"];
        return;
    }
    if (phoneText.text.length<KMaxLength) {
        [MBProgressHUD showTip:@"手机号格式错误"];
        return;
    }
    if (codeText.text<=0) {
        [MBProgressHUD showTip:@"请输入验证码"];
        return;
    }
    if (psdText.text<=0) {
        [MBProgressHUD showTip:@"请输入密码"];
        return;
    }
    if (psdRepeatTest.text<=0) {
        [MBProgressHUD showTip:@"请重复输入密码"];
        return;
    }
    if (![psdText.text isEqualToString:psdRepeatTest.text]){
        [MBProgressHUD showTip:@"两次密码不一致"];
        return;;
    }
    [self.loginApi resetPasswd:phoneText.text code:codeText.text password:psdRepeatTest.text success:^(id model) {
        NSString *codeMessage =model[@"result"];
        if ([codeMessage isEqualToString:@"FAILED"]) {
            [MBProgressHUD showTip:model[@"message"]];
        }else{
            [MBProgressHUD showTip:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *failure) {
        [MBProgressHUD showTip:@"修改失败"];
    }];
}

//发送验证码
- (void)countdownButtonClicked:(QiCountdownButton *)sender{
    if (phoneText.text.length<=0) {
        [MBProgressHUD showTip:@"请输入手机号"];
        return;
    }
    if (phoneText.text.length<KMaxLength) {
        [MBProgressHUD showTip:@"手机号格式错误"];
        return;
    }
    
    [self.loginApi forgetPwdCode:phoneText.text success:^(id model) {
        NSString *codeMessage =model[@"result"];
        if ([codeMessage isEqualToString:@"FAILED"]) {
            [MBProgressHUD showTip:@"验证码发送失败"];
        }else{
            [MBProgressHUD showTip:@"发送成功"];
            [sender setEnabled:NO];
            [sender setBackgroundColor:CLYColor(189, 225, 255, 1)];
            [sender startCountdown];
        }
    } failure:^(NSError *failure) {
        [MBProgressHUD showTip:@"发送失败"];
    }];
}

//获取手机号码
- (void)pnoneTextFieldEditChanged:(UITextField *)textField
{
    NSString *textString = textField.text;
    if (textField.text.length>KMaxLength) {
        textField.text = [textString substringToIndex:KMaxLength];
        [MBProgressHUD showTip:@"手机格式错误"];
    }
}

//隐藏显示密码
- (void)pwdBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [pwdBtn setBackgroundImage:[UIImage imageNamed:@"register_icon_eyeopen"] forState:UIControlStateNormal];
        psdText.secureTextEntry = NO;
    }else{
        [pwdBtn setBackgroundImage:[UIImage imageNamed:@"register_icon_eyeclose"] forState:UIControlStateNormal];
        psdText.secureTextEntry = YES;
    }
}

//隐藏显示二次密码
- (void)pwdRepeatBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [pwdRepeatBtn setBackgroundImage:[UIImage imageNamed:@"register_icon_eyeopen"] forState:UIControlStateNormal];
        psdRepeatTest.secureTextEntry = NO;
    }else{
        [pwdRepeatBtn setBackgroundImage:[UIImage imageNamed:@"register_icon_eyeclose"] forState:UIControlStateNormal];
        psdRepeatTest.secureTextEntry = YES;
    }
}

//密码
- (void)psdTextFieldEditChanged:(UITextField *)textField
{
    NSString *textString = textField.text;
    if (textField.text.length>0) {
        [pwdBtn setBackgroundImage:[UIImage imageNamed:@"register_icon_eyeclose"] forState:UIControlStateNormal];
        pwdBtn.hidden       = NO;
    }else{
        pwdBtn.hidden       = YES;
    }
    if (textField.text.length>KPwdMaxLength) {
        textField.text = [textString substringToIndex:KPwdMaxLength];
        [MBProgressHUD showTip:@"密码格式错误"];
    }
}

//二次密码
- (void)psdRepeatTestFieldEditChanged:(UITextField *)textField
{
    NSString *textString = textField.text;
    if (textField.text.length>0) {
        [pwdRepeatBtn setBackgroundImage:[UIImage imageNamed:@"register_icon_eyeclose"] forState:UIControlStateNormal];
        pwdRepeatBtn.hidden = NO;
    }else{
        pwdRepeatBtn.hidden = YES;
    }
    if (textField.text.length>KPwdMaxLength) {
        textField.text = [textString substringToIndex:KPwdMaxLength];
        [MBProgressHUD showTip:@"手机号格式错误"];

    }
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
