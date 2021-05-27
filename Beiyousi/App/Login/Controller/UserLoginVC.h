//
//  UserLoginVC.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/9.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserLoginVC : BaseViewController{
    
    __weak IBOutlet UIButton *cancelBtn;
    __weak IBOutlet UITextField *phoneText;
    __weak IBOutlet UITextField *pwdText;
    __weak IBOutlet UIButton *switchBtn;
    __weak IBOutlet UIButton *protocolBtn;
    __weak IBOutlet UIButton *LoginBtn;
    __weak IBOutlet UIButton *forgetBtn;
    __weak IBOutlet UIButton *codeLoginBtn;
}

@end

NS_ASSUME_NONNULL_END
