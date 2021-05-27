//
//  UserInfoModel.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/12.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : JSONModel

@property (nonatomic,strong)NSString *accountId;    //账户id
@property (nonatomic,strong)NSString *createTime;   //创建时间
@property (nonatomic,strong)NSString *gender;       //性别
@property (nonatomic,strong)NSString *id;           //用户id
@property (nonatomic,strong)NSString *lastLoginTime;//上次登录时间
@property (nonatomic,strong)NSString *name;         //姓名
@property (nonatomic,strong)NSString *password;     //密码(身份认证)
@property (nonatomic,strong)NSString *picture;      //头像图片(系统标识或url)
@property (nonatomic,strong)NSString *remark;       //备注(备用字段)
@property (nonatomic,strong)NSString *schoolId;     //学校id(家长可以没有该属性)
@property (nonatomic,strong)NSString *schoolName;   //学校名称
@property (nonatomic,strong)NSString *status;       //用户状态(备用字段)
@property (nonatomic,strong)NSString *token;        //学校id(家长可以没有该属性)
@property (nonatomic,strong)NSString *type;         //0-系统管理员,1-学生,2-教师,3-家长,4-学校管理员
@property (nonatomic,assign)int       vipLevel;     //vip等级

@end

NS_ASSUME_NONNULL_END
