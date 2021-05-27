//
//  LoginVC.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/9.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginVC : BaseViewController{
    
    __weak IBOutlet UITextField *phoneField;
    __weak IBOutlet UIButton *switchBtton;
    __weak IBOutlet UIButton *protocolLab;
    __weak IBOutlet UIButton *userCodeBtn;
    __weak IBOutlet UIButton *pwLoginBtn;
}

@end

NS_ASSUME_NONNULL_END
