//
//  selectRoleVC.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/10.
//

#import "selectRoleVC.h"
#import "MainViewController.h"
#import "LoginAPI.h"
#import "MainViewController.h"
#import "CSTabBarVC.h"

@interface selectRoleVC ()

@property(nonatomic, strong)NSString *roleNum;//0-系统管理员,1-学生,2-教师,3-家长,4-学校管理员
@property(nonatomic, strong)LoginAPI *loginApi;

@end

@implementation selectRoleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginApi = [[LoginAPI alloc] init];
    
    toHomeBtn.layer.cornerRadius        = 16.0f;
    toHomeBtn.clipsToBounds             = NO;
    selectStudentBtn.layer.cornerRadius = 12.0f;
    selectStudentBtn.clipsToBounds      = NO;
    selectParentsBtn.layer.cornerRadius = 12.0f;
    selectParentsBtn.clipsToBounds      = NO;
    selectTeacherBtn.layer.cornerRadius = 12.0f;
    selectTeacherBtn.clipsToBounds      = NO;
    
    [selectStudentBtn addTarget:self action:@selector(selectStudentBtnAction:) forControlEvents:UIControlEventTouchDown];
    [selectParentsBtn addTarget:self action:@selector(selectParentsBtnAction:) forControlEvents:UIControlEventTouchDown];
    [selectTeacherBtn addTarget:self action:@selector(selectTeacherBtnAction:) forControlEvents:UIControlEventTouchDown];
    [toHomeBtn addTarget:self action:@selector(toHomeAction) forControlEvents:UIControlEventTouchDown];
}

//进入首页
- (void)toHomeAction{
    if (self.roleNum<0) {
        [MBProgressHUD showTip:@"请选择角色"];
        return;;
    }
    [self.loginApi userCheckType:self.roleModel.id type:self.roleNum success:^(id model) {
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

//选择学生
- (void)selectStudentBtnAction:(UIButton *)sender{
    studentImg.image = [UIImage imageNamed:@"register_icon_bigselect_sel"];
    teacherImg.image = [UIImage imageNamed:@"register_icon_bigselect_nor"];
    parentsImg.image = [UIImage imageNamed:@"register_icon_bigselect_nor"];
    selectStudentBtn.backgroundColor  = CLYColor(223, 241, 255, 1);
    selectParentsBtn.backgroundColor  = BackColor;
    selectTeacherBtn.backgroundColor  = BackColor;
    parentsHeadImg.alpha    = 0.4;
    teacherHeadImg.alpha    = 0.4;
    teacherLab.alpha        = 0.4;
    parentsLab.alpha        = 0.4;
    studentLab.alpha        = 1;
    self.roleNum = @"1";
}

//选择家长
- (void)selectParentsBtnAction:(UIButton *)sender{
    studentImg.image = [UIImage imageNamed:@"register_icon_bigselect_nor"];
    parentsImg.image = [UIImage imageNamed:@"register_icon_bigselect_sel"];
    teacherImg.image = [UIImage imageNamed:@"register_icon_bigselect_nor"];
    selectStudentBtn.backgroundColor  = BackColor;
    selectParentsBtn.backgroundColor  = CLYColor(223, 241, 255, 1);
    selectTeacherBtn.backgroundColor  = BackColor;
    studentHeadImg.alpha    = 0.4;
    parentsHeadImg.alpha    = 1;
    teacherHeadImg.alpha    = 0.4;
    teacherLab.alpha        = 0.4;
    studentLab.alpha        = 0.4;
    parentsLab.alpha        = 1;
    self.roleNum = @"3";
}

//选择老师
- (void)selectTeacherBtnAction:(UIButton *)sender{
    studentImg.image = [UIImage imageNamed:@"register_icon_bigselect_nor"];
    parentsImg.image = [UIImage imageNamed:@"register_icon_bigselect_nor"];
    teacherImg.image = [UIImage imageNamed:@"register_icon_bigselect_sel"];
    selectStudentBtn.backgroundColor  = BackColor;
    selectParentsBtn.backgroundColor  = BackColor;
    selectTeacherBtn.backgroundColor  = CLYColor(223, 241, 255, 1);
    studentHeadImg.alpha    = 0.4;
    parentsHeadImg.alpha    = 0.4;
    teacherHeadImg.alpha    = 1;
    teacherLab.alpha        = 1;
    studentLab.alpha        = 0.4;
    parentsLab.alpha        = 0.4;
    self.roleNum = @"2";
}

- (void)cancelBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
