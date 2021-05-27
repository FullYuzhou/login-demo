//
//  UserRoleModel.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/11.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserRoleModel : JSONModel

@property(nonatomic, strong)NSString *id;

//最后一次登录角色 0-系统管理员,1-学生,2-教师,3-家长,4-学校管理员
@property(nonatomic, strong)NSString *lastType;
@property(nonatomic, strong)NSString *password;
@property(nonatomic, strong)NSString *phone;

@end

NS_ASSUME_NONNULL_END
