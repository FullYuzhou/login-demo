//
//  sendCodeVC.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/9.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface sendCodeVC : BaseViewController{
    
    __weak IBOutlet UIButton *backBtn;
    __weak IBOutlet UILabel *phoneLab;
}

@property (nonatomic, strong)NSString *phoneNum;

@end

NS_ASSUME_NONNULL_END
