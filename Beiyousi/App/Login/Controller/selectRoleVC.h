//
//  selectRoleVC.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/10.
//

#import "BaseViewController.h"
#import "UserRoleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface selectRoleVC : BaseViewController{
    
    __weak IBOutlet UIImageView *studentImg;
    __weak IBOutlet UIImageView *parentsImg;
    __weak IBOutlet UIImageView *teacherImg;
    __weak IBOutlet UIImageView *studentHeadImg;
    __weak IBOutlet UIImageView *parentsHeadImg;
    __weak IBOutlet UIImageView *teacherHeadImg;
    __weak IBOutlet UIButton *selectStudentBtn;
    __weak IBOutlet UIButton *selectParentsBtn;
    __weak IBOutlet UIButton *selectTeacherBtn;
    __weak IBOutlet UIButton *toHomeBtn;
    __weak IBOutlet UILabel *studentLab;
    __weak IBOutlet UILabel *parentsLab;
    __weak IBOutlet UILabel *teacherLab;
}

@property(nonatomic, assign)int enterTypt;//进入选择界面 1：用户 2：其他
@property(nonatomic, strong)UserRoleModel *roleModel;

@end

NS_ASSUME_NONNULL_END
