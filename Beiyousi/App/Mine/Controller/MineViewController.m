//
//  MineViewController.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/11/30.
//

#import "MineViewController.h"
#import "SettingVC.h"
#import "AddUserClassView.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)AddUserClassView *addUserClassView;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hiddenNavBar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackColor;
        
    UIButton *noticeButton = [[UIButton alloc]init];
    [noticeButton setImage:[UIImage imageNamed:@"searchbar_icon_notice"] forState:0];
    [noticeButton addTarget:self action:@selector(noticeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noticeButton];
    [noticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(StatusBarHeight+10);
        make.right.equalTo(self.view.mas_right).offset(-13);
        make.width.offset(24);
        make.height.offset(24);
    }];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 188)];
    [self.view addSubview:bgView];
    self.tableView.tableHeaderView = bgView;
    
    UIView *userView = [[UIView alloc] init];
    [bgView addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(0);
        make.right.equalTo(bgView.mas_right).offset(0);
        make.width.offset(DEVICE_WIDTH);
        make.height.offset(88);
    }];
    
    UIImageView *userImg = [[UIImageView alloc] init];
    userImg.image = [UIImage imageNamed:@"headportrait_img_chriden"];
    [userView addSubview:userImg];
    [userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userView);
        make.left.equalTo(userView.mas_left).offset(16);
        make.width.offset(56);
        make.height.offset(56);
    }];
    
    UILabel *userName = [[UILabel alloc] init];
    userName.text = [[BYSUserHandle sharedInstance].userInfo.name stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    userName.font = [UIFont boldSystemFontOfSize:18.0f];
    userName.textColor = CLYColor(39, 39, 39, 1);
    userName.textAlignment = NSTextAlignmentLeft;
    [userView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView).offset(20);
        make.left.equalTo(userImg.mas_right).offset(16);
        make.width.offset(200);
        make.height.offset(22);
    }];
    
    UILabel *schoolLab = [[UILabel alloc] init];
    schoolLab.text = [BYSUserHandle sharedInstance].userInfo.schoolName;
    schoolLab.font = [UIFont systemFontOfSize:12.0f];
    schoolLab.textAlignment = NSTextAlignmentLeft;
    schoolLab.textColor = CLYColor(166, 166, 166, 1);
    [userView addSubview:schoolLab];
    [schoolLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(userName).offset(20);
        make.left.equalTo(userImg.mas_right).offset(16);
        make.height.offset(17);
    }];
    
    UILabel *roleLab = [[UILabel alloc] init];
    if ([[BYSUserHandle sharedInstance].userInfo.type isEqualToString:@"0"]) {
        roleLab.text = @"  系统管理员  ";
    }else if ([[BYSUserHandle sharedInstance].userInfo.type isEqualToString:@"1"]){
        roleLab.text = @"  学生  ";
    }else if ([[BYSUserHandle sharedInstance].userInfo.type isEqualToString:@"2"]){
        roleLab.text = @"  教师  ";
    }else if ([[BYSUserHandle sharedInstance].userInfo.type isEqualToString:@"3"]){
        roleLab.text = @"  家长  ";
    }else{
        roleLab.text = @"  学校管理员  ";
    }
    roleLab.layer.borderColor = [CLYColor(64, 169, 255, 1) CGColor];
    roleLab.layer.borderWidth = 1.0f;
    roleLab.layer.masksToBounds = YES;
    roleLab.layer.cornerRadius = 4;
    roleLab.textColor = CLYColor(64, 169, 255, 1);
    roleLab.font = [UIFont systemFontOfSize:10.0f];
    roleLab.textAlignment = NSTextAlignmentLeft;
    [userView addSubview:roleLab];
    [roleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(userName).offset(22);
        make.left.equalTo(schoolLab.mas_right).offset(2);
        make.height.offset(22);
    }];
    
    UIImageView *arrImg = [[UIImageView alloc] init];
    arrImg.image = [UIImage imageNamed:@"mepage_icon_more"];
    [userView addSubview:arrImg];
    [arrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userView);
        make.right.equalTo(userView.mas_right).offset(-25);
        make.width.offset(16);
        make.height.offset(16);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgViewAction:)];
    [bgView addGestureRecognizer:tap];

    [bgView addSubview:self.addUserClassView];
    [self.addUserClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(96);
        make.right.equalTo(bgView.mas_right).offset(-16);
        make.width.offset(DEVICE_WIDTH-(16*2));
        make.height.offset(76);
    }];
    
//    if ([[BYSUserHandle sharedInstance].userInfo.type isEqualToString:@"0"]) {
//        roleLab.text = @"  系统管理员  ";
//    }else if ([[BYSUserHandle sharedInstance].userInfo.type isEqualToString:@"1"]){
//        roleLab.text = @"  学生  ";
//    }else if ([[BYSUserHandle sharedInstance].userInfo.type isEqualToString:@"2"]){
//        roleLab.text = @"  教师  ";
//    }else if ([[BYSUserHandle sharedInstance].userInfo.type isEqualToString:@"3"]){
//        roleLab.text = @"  家长  ";
//    }else{
//        roleLab.text = @"  学校管理员  ";
//    }

}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *cellID = @"cellID";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   if (!cell) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
   }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = CLYColor(115, 115, 115, 1);
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mepage_icon_mycollection"];
        cell.textLabel.text = @"我的收藏";
    }else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"mepage_icon_contactus"];
        cell.textLabel.text = @"联系我们";
    }else{
        cell.imageView.image = [UIImage imageNamed:@"mepage_icon_set"];
        cell.textLabel.text = @"设置";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 5, 0, 5)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        SettingVC *setVC = [[SettingVC alloc] init];
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
    }
}

- (void)tapBgViewAction:(UITapGestureRecognizer *)tap
{
    
}

- (AddUserClassView *)addUserClassView{
    if (!_addUserClassView) {
        _addUserClassView = [[NSBundle mainBundle] loadNibNamed:@"AddUserClassView" owner:self options:nil].lastObject;
        _addUserClassView.frame = CGRectZero;
        _addUserClassView.layer.cornerRadius = 8;
        _addUserClassView.layer.masksToBounds = YES;
    }
    return _addUserClassView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight+46, DEVICE_WIDTH, DEVICE_HEIGHT-StatusBarHeight-kTabBarHeight)];
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.alwaysBounceVertical = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView alloc];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)noticeButton{
    
}

@end
