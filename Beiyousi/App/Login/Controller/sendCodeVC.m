//
//  sendCodeVC.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/9.
//

#import "sendCodeVC.h"
#import "selectRoleVC.h"
#import "CRBoxInputView.h"
#import "LoginAPI.h"
#import "UserRoleModel.h"
#import "QiCountdownButton.h"
#import "MainViewController.h"
#import "CSTabBarVC.h"

#define HEIGHT5 568.0
#define HEIGHT6 667.0
#define WIDTH6 375.0
#define LayOutHeight  ((DEVICE_HEIGHT < HEIGHT5) ? HEIGHT5 : DEVICE_HEIGHT)
#define YY_6(value)     (1.0 * (value) * LayOutHeight / HEIGHT6)
#define XX_6(value)     (1.0 * (value) * DEVICE_WIDTH / WIDTH6)
#define offXStart XX_6(25)

@interface sendCodeVC ()
{
    QiCountdownButton *countdownButton;
}
@property(nonatomic, strong) CRBoxInputView *boxInputView;
@property(nonatomic, strong) NSString       *codeStrig;
@property(nonatomic, strong) LoginAPI *loginApi;
@property(nonatomic, strong)UserRoleModel *userRoleModel;

@end

@implementation sendCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    phoneLab.text = self.phoneNum;
    
    self.loginApi = [[LoginAPI alloc] init];
    
    _boxInputView = [self generateBoxInputView_line];
    [self.view addSubview:_boxInputView];
    [_boxInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offXStart);
        make.right.mas_equalTo(-offXStart);
        make.height.mas_equalTo(YY_6(52));
        make.top.equalTo(self->phoneLab.mas_bottom).offset(YY_6(18));
    }];
    
    [backBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchDown];

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
        make.top.mas_equalTo(_boxInputView.mas_bottom).offset(30);
        make.right.equalTo(self.view.mas_left).offset(16+109);
        make.height.offset(32);
        make.width.offset(109);
    }];
}

#pragma mark - Line
- (CRBoxInputView *)generateBoxInputView_line
{
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    cellProperty.cellCursorColor = mainColor;
    cellProperty.cellCursorWidth = 2;
    cellProperty.cellCursorHeight = YY_6(24);
    cellProperty.cornerRadius = 0;
    cellProperty.borderWidth = 0;
    cellProperty.cellFont = [UIFont boldSystemFontOfSize:24];
    cellProperty.cellTextColor = CLYColor(39, 39, 39, 1);
    cellProperty.showLine = YES;
    cellProperty.customLineViewBlock = ^CRLineView * _Nonnull{
        CRLineView *lineView = [CRLineView new];
        lineView.underlineColorNormal = CLYColor(238, 238, 238, 1);
        lineView.underlineColorSelected = CLYColor(64, 169, 255, 1);
        lineView.underlineColorFilled = CLYColor(238, 238, 238, 1);
        [lineView.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(4);
            make.left.right.bottom.offset(0);
        }];
        
        lineView.selectChangeBlock = ^(CRLineView * _Nonnull lineView, BOOL selected) {
            if (selected) {
                [lineView.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0.5);
                }];
            } else {
                [lineView.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0.5);
                }];
            }
        };

        return lineView;
    };

    CRBoxInputView *_boxInputView = [[CRBoxInputView alloc] initWithCodeLength:6];
    _boxInputView.mainCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _boxInputView.boxFlowLayout.itemSize = CGSizeMake(XX_6(32), XX_6(52));
    _boxInputView.customCellProperty = cellProperty;
    [_boxInputView loadAndPrepareViewWithBeginEdit:YES];
    
    CY_WeakSelf;
    _boxInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.codeStrig = text;
        if (text.length==6) {
            [self loadCodeLogin];
        }
    };
    
    return _boxInputView;
}

- (void)loadCodeLogin{
    [MBProgressHUD showLoading];
    [self.loginApi codeLogin:self.phoneNum code:self.codeStrig success:^(id model) {
        NSString *codeMessage =model[@"result"];
        if ([codeMessage isEqualToString:@"FAILED"]) {
            [MBProgressHUD showTip:model[@"message"]];
            [self clearBtnEvent];
            [MBProgressHUD hide];
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

- (void)clearBtnEvent
{
    [_boxInputView clearAll];
}

- (void)countdownButtonClicked:(QiCountdownButton *)sender{
    [self.loginApi smsLogin:self.phoneNum success:^(id model) {
        NSString *codeMessage =model[@"result"];
        if ([codeMessage isEqualToString:@"FAILED"]) {
            [MBProgressHUD showTip:model[@"message"]];
        }else{
            [MBProgressHUD showTip:@"发送成功"];
            [sender setEnabled:NO];
            [sender setBackgroundColor:CLYColor(189, 225, 255, 1)];
            [sender startCountdown];
        }
    } failure:^(NSError *failure) {

    }];
}

- (void)cancelBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
