//
//  UserInfoDao.h
//  ShmetroOA
//
//  Created by gisteam on 6/17/13.
//
//

#import "BaseDao.h"
#import "UserInfo.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface UserInfoDao : BaseDao

-(BOOL)insert:(UserInfo*)userInfo;
-(BOOL)update:(UserInfo*)userInfo;
-(BOOL)deleteAllUserInfo;
-(UserInfo*)getUserInfoByLoginName:(NSString *)loginName;

-(void)saveUserInfoFromJsonValue:(id)jsonObj;

@end
