//
//  UserAccountInfoDao.m
//  ShmetroOA
//
//  Created by gisteam on 5/30/13.
//
//

#import "UserAccountInfoDao.h"
#define TABLE_NAME @"useraccountinfo"

@interface UserAccountInfoDao(PrivateMethod)
-(Boolean)containsKey:(UserAccountInfo *)userAccountInfo;
-(void)setUserAccountInfoProp:(FMResultSet *)rs UserAccountInfo:(UserAccountInfo *)userAccountInfo;
@end

@implementation UserAccountInfoDao

-(void)insert:(UserAccountInfo *)userAccountInfo{
    if (![self containsKey:userAccountInfo]) {
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (token,userId,userName,md5Pass,md5Sign,deptName,deptId,desPass,loginName) VALUES (?,?,?,?,?,?,?,?,?) " inTable:TABLE_NAME],userAccountInfo.token,userAccountInfo.userId,userAccountInfo.userName,userAccountInfo.md5Pass,userAccountInfo.md5Sign,userAccountInfo.deptName,userAccountInfo.deptId,userAccountInfo.desPass,userAccountInfo.loginName];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
    }else{
        [self update:userAccountInfo];
    }
}

-(void)update:(UserAccountInfo *)userAccountInfo{
    NSMutableDictionary *updateDic = [[[NSMutableDictionary alloc]init]autorelease];
    if (userAccountInfo.token !=nil) {
        [updateDic setValue:userAccountInfo.token forKey:@"token"];
    }
    if (userAccountInfo.userId !=nil) {
        [updateDic setValue:userAccountInfo.userId forKey:@"userId"];
    }
    if (userAccountInfo.userName!=nil) {
        [updateDic setValue:userAccountInfo.userName forKey:@"userName"];
    }
    if (userAccountInfo.md5Sign!= nil) {
        [updateDic setValue:userAccountInfo.md5Sign forKey:@"md5Sign"];
    }
    if (userAccountInfo.md5Pass != nil) {
        [updateDic setValue:userAccountInfo.md5Pass forKey:@"md5Pass"];
    }
    if (userAccountInfo.loginName != nil) {
        [updateDic setValue:userAccountInfo.loginName forKey:@"loginName"];
    }
    if (userAccountInfo.desPass != nil) {
        [updateDic setValue:userAccountInfo.desPass forKey:@"desPass"];
    }
    if (userAccountInfo.deptId != nil) {
        [updateDic setValue:userAccountInfo.deptId forKey:@"deptId"];
    }
    if (userAccountInfo.deptName != nil) {
        [updateDic setValue:userAccountInfo.deptName forKey:@"deptName"];
    }

    NSString *fieldsStr=@"";
    NSString *key;
    if ([updateDic.allKeys count]>0) {
        for (int i=0; i<[updateDic.allKeys count]; i++) {
            key = [updateDic.allKeys objectAtIndex:i];
            if (i==0) {
                fieldsStr = [NSString stringWithFormat:@"%@=?",key];
            }else {
                fieldsStr = [NSString stringWithFormat:@"%@, %@=?",fieldsStr,key];
            }
        }
    }
    NSMutableArray *fieldValues = [[NSMutableArray alloc]initWithArray:[updateDic allValues]];
    [fieldValues addObject:userAccountInfo.loginName];

    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE loginName=?",TABLE_NAME,fieldsStr];
    [db executeUpdate:sql withArgumentsInArray:fieldValues];
    [fieldValues release];
}

-(BOOL)delete:(NSString *)userId{
    
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE userId = ?" inTable:TABLE_NAME],userId];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}

-(NSMutableArray*)getDeptArray:(NSString *)userId{
    NSMutableArray *deptArray = [[[NSMutableArray alloc]init]autorelease];
    FMResultSet *rs =[db executeQuery:[self SQL:@"SELECT * FROM %@ " inTable:TABLE_NAME]];
    while ([rs next]) {
        NSMutableDictionary * deptDic = [[NSMutableDictionary alloc]init];
        UserAccountInfo *userAccountInfo =[[UserAccountInfo alloc]init];
        [self setUserAccountInfoProp:rs UserAccountInfo:userAccountInfo];
        if ([userAccountInfo.loginName isEqualToString:[userId stringByAppendingString:userAccountInfo.deptId]]) {
            [deptDic setValue:userAccountInfo.deptId forKey:@"deptId"];
            [deptDic setValue:userAccountInfo.deptName forKey:@"deptName"];
            [deptArray addObject:deptDic];
            
        }
        [deptDic release];
        [userAccountInfo release];
      
       // [deptArray addObject:[rs stringForColumn:@"deptName"]];
    }
    [rs close];
    
    return deptArray;
}

-(UserAccountInfo *)getUserAccountInfo:(NSString *)userId DeptId:(NSString *)deptId
{
    UserAccountInfo *accountInfo = [[[UserAccountInfo alloc]init]autorelease];
    NSString * loginName = [userId stringByAppendingString:deptId];
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ WHERE loginName =? " inTable:TABLE_NAME],loginName];
    
    while ([rs next]) {
        [self setUserAccountInfoProp:rs UserAccountInfo:accountInfo];
    }
    [rs close];
    
    return accountInfo;
}
-(Boolean)containsKey:(UserAccountInfo *)userAccountInfo{
    Boolean result = NO;
    if (userAccountInfo !=nil && userAccountInfo.userId !=nil) {
        FMResultSet *rs=[db executeQuery:[self SQL:@"SELECT * FROM %@ WHERE userId=?" inTable:TABLE_NAME],userAccountInfo.userId];
        while ([rs next]) {
            result = YES;
        }
        
        [rs close];
    }
   
    return result;
}

-(void)setUserAccountInfoProp:(FMResultSet *)rs UserAccountInfo:(UserAccountInfo *)userAccountInfo{
    userAccountInfo.userId = [rs stringForColumn:@"userId"];
    userAccountInfo.token = [rs stringForColumn:@"token"];
    userAccountInfo.userName = [rs stringForColumn:@"userName"];
    userAccountInfo.loginName = [rs stringForColumn:@"loginName"];
    userAccountInfo.md5Pass=[rs stringForColumn:@"md5Pass"];
    userAccountInfo.md5Sign = [rs stringForColumn:@"md5Sign"];
    userAccountInfo.deptId = [rs stringForColumn:@"deptId"];
    userAccountInfo.deptName = [rs stringForColumn:@"deptName"];
    userAccountInfo.desPass = [rs stringForColumn:@"desPass"];
}

@end
