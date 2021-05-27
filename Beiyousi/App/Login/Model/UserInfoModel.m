//
//  UserInfoModel.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/12.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_accountId forKey:@"accountId"];
    [aCoder encodeObject:_createTime forKey:@"createTime"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeObject:_id forKey:@"id"];
    [aCoder encodeObject:_lastLoginTime forKey:@"lastLoginTime"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_picture forKey:@"picture"];
    [aCoder encodeObject:_remark forKey:@"remark"];
    [aCoder encodeObject:_schoolId forKey:@"schoolId"];
    [aCoder encodeObject:_schoolName forKey:@"schoolName"];
    [aCoder encodeObject:_status forKey:@"status"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeInt:_vipLevel forKey:@"vipLevel"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _accountId = [aDecoder decodeObjectForKey:@"accountId"];
        _createTime = [aDecoder decodeObjectForKey:@"createTime"];
        _id = [aDecoder decodeObjectForKey:@"id"];
        _gender = [aDecoder decodeObjectForKey:@"gender"];
        _lastLoginTime = [aDecoder decodeObjectForKey:@"lastLoginTime"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _picture = [aDecoder decodeObjectForKey:@"picture"];
        _remark = [aDecoder decodeObjectForKey:@"remark"];
        _schoolId = [aDecoder decodeObjectForKey:@"schoolId"];
        _schoolName  = [aDecoder decodeObjectForKey:@"schoolName"];
        _name     = [aDecoder decodeObjectForKey:@"name"];
        _status   = [aDecoder decodeObjectForKey:@"status"];
        _token    = [aDecoder decodeObjectForKey:@"token"];
        _type     = [aDecoder decodeObjectForKey:@"type"];
        _vipLevel = [aDecoder decodeIntForKey:@"vipLevel"];
    }
    return self;
}

@end
