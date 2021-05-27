//
//  SettingVC.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/8.
//

#import "SettingVC.h"
#import "forgetPassordVC.h"
#import "LoginAPI.h"

@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *phoneLab;
@property(nonatomic,strong)LoginAPI*loginAPI;
@property(nonatomic,strong)NSString *phoneStr;

@end

@implementation SettingVC

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showNavBar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hiddenNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    self.loginAPI = [[LoginAPI alloc] init];
    
    [self loadUserPhoe];
    
    UIButton *loginOutBtn = [[UIButton alloc] init];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    loginOutBtn.backgroundColor =CLYColor(245, 245, 245, 1);
    [loginOutBtn setTitleColor:TitletColor forState:UIControlStateNormal];
    loginOutBtn.layer.cornerRadius = 22.0f;
    loginOutBtn.layer.masksToBounds= YES;
    [loginOutBtn addTarget:self action:@selector(loginOutBtnAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:loginOutBtn];
    [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.width.offset(DEVICE_WIDTH-(16*2));
        make.height.offset(44);
    }];
}

//获取用户手机号
- (void)loadUserPhoe{
    [self.loginAPI userGetPhone:[BYSUserHandle sharedInstance].userInfo.accountId success:^(id model) {
        self.phoneStr = model[@"data"];
        [self.tableView reloadData];
    } failure:^(NSError *failure) {
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *cellID = @"cellID";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   if (!cell) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
   }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = CLYColor(34, 34, 34, 1);
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"手机号";
        [cell.contentView addSubview:self.phoneLab];
        [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-16);
        }];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"重置密码";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 5, 0, 5)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        forgetPassordVC *forgetVC = [[forgetPassordVC alloc] init];
        [self.navigationController pushViewController:forgetVC animated:YES];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT/2)];
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

- (UILabel *)phoneLab{
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] init];
        _phoneLab.textAlignment = NSTextAlignmentRight;
        _phoneLab.text = self.phoneStr;
        _phoneLab.textColor = CLYColor(115, 115, 115, 1);
        _phoneLab.font = [UIFont systemFontOfSize:16.0f];
    }
    return _phoneLab;
}

- (void)loginOutBtnAction{
    [[BYSUserHandle sharedInstance] exitAccount];
}

@end
