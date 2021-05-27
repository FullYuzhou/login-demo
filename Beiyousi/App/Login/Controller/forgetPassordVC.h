//
//  forgetPassordVC.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/9.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface forgetPassordVC : BaseViewController{
    
    __weak IBOutlet UIButton *backBtn;
    __weak IBOutlet UITextField *phoneText;
    __weak IBOutlet UITextField *codeText;
    __weak IBOutlet UITextField *psdText;
    __weak IBOutlet UITextField *psdRepeatTest;
    __weak IBOutlet UIButton *surePsdBtn;
    __weak IBOutlet UIButton *pwdBtn;
    __weak IBOutlet UIButton *pwdRepeatBtn;
}

@end

NS_ASSUME_NONNULL_END
