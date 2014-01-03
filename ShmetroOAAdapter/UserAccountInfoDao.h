//
//  UserAccountInfoDao.h
//  ShmetroOA
//
//  Created by gisteam on 5/30/13.
//
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "UserAccountInfo.h"

@interface UserAccountInfoDao  : BaseDao

-(void)insert:(UserAccountInfo *)userAccountInfo;
-(void)update:(UserAccountInfo *)userAccountInfo;
-(NSMutableArray *)getDeptArray:(NSString *)userId;
-(UserAccountInfo *)getUserAccountInfo:(NSString *)userId DeptId:(NSString *)deptId;
-(BOOL)delete:(NSString *)userId;

@end
