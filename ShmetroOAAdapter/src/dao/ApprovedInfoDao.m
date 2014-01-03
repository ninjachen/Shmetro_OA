//
//  ApprovedInfoDao.m
//  ShmetroOA
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ApprovedInfoDao.h"
#define TABLE_NAME @"approvedinfo"
static NSString *APPROVE_TYPE_APPLY=@"APPLY";
static NSString *APPROVE_TYPE_SUB=@"SUB";
static NSString *APPROVE_TYPE_BACK=@"BACK";
@interface ApprovedInfoDao(PrivateMethods)
-(Boolean)containsKey:(NSString *)todoId GUID:(NSString *)guid;
-(void)setApprovedInfoProp:(FMResultSet *)rs ApprovedInfo:(ApprovedInfo *)approvedInfo;
@end
@implementation ApprovedInfoDao
-(void)insert:(ApprovedInfo *)approvedInfo{
    if (![self containsKey:approvedInfo.todoId GUID:approvedInfo.guid]) {
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (day,dept,guid,time,type,cname,deptId,remark,todoId,updDate,stepname,userName,cincident,optionCode,userFullName,fileGroupId,approveType,cId,pId,syncFlag) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" inTable:TABLE_NAME],approvedInfo.day,approvedInfo.dept,approvedInfo.guid,approvedInfo.time,approvedInfo.type,approvedInfo.cname,approvedInfo.deptId,approvedInfo.remark,approvedInfo.todoId,approvedInfo.updDate,approvedInfo.stepname,approvedInfo.userName,approvedInfo.cincident,approvedInfo.optionCode,approvedInfo.userFullName,approvedInfo.fileGroupId,approvedInfo.approveType,approvedInfo.cId,approvedInfo.pId,@"1"];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        
    } else {
        [self update:approvedInfo];
    } 
}
-(void)update:(ApprovedInfo *)approvedInfo{
    NSMutableDictionary *updateDic = [[[NSMutableDictionary alloc]init] autorelease];
    if (approvedInfo.day&&![approvedInfo.day isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.day forKey:@"day"];
    }
    if (approvedInfo.dept&&![approvedInfo.dept isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.dept forKey:@"dept"];
    }
    if (approvedInfo.time&&![approvedInfo.time isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.time forKey:@"time"];
    }
    if (approvedInfo.type&&![approvedInfo.type isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.type forKey:@"type"];
    }
    if (approvedInfo.cname&&![approvedInfo.cname isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.cname forKey:@"cname"];
    }
    if (approvedInfo.deptId&&![approvedInfo.deptId isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.deptId forKey:@"deptId"];
    }
    if (approvedInfo.remark&&![approvedInfo.remark isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.remark forKey:@"remark"];
    }
    if (approvedInfo.updDate&&![approvedInfo.updDate isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.updDate forKey:@"updDate"];
    }
    if (approvedInfo.stepname&&![approvedInfo.stepname isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.stepname forKey:@"stepname"];
    }
    if (approvedInfo.userName&&![approvedInfo.userName isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.userName forKey:@"userName"];
    }
    if (approvedInfo.cincident&&![approvedInfo.cincident isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.cincident forKey:@"cincident"];
    }
    if (approvedInfo.optionCode&&![approvedInfo.optionCode isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.optionCode forKey:@"optionCode"];
    }
    if (approvedInfo.userFullName&&![approvedInfo.userFullName isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.userFullName forKey:@"userFullName"];
    }
    if (approvedInfo.fileGroupId&&![approvedInfo.fileGroupId isEqualToString:@""])
    {
        [updateDic setValue:approvedInfo.fileGroupId forKey:@"fileGroupId"];
    }
    if (approvedInfo.approveType&&![approvedInfo.approveType isEqualToString:@""])
    {
        [updateDic setValue:approvedInfo.approveType forKey:@"approveType"];
    }
    if (approvedInfo.cId&&![approvedInfo.cId isEqualToString:@""])
    {
        [updateDic setValue:approvedInfo.cId forKey:@"cId"];
    }
    if (approvedInfo.pId&&![approvedInfo.pId isEqualToString:@""])
    {
        [updateDic setValue:approvedInfo.pId forKey:@"pId"];
    }
    [updateDic setValue:[NSString stringWithFormat:@"%d",1] forKey:@"syncFlag"];
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
    NSMutableArray *fieldValues = [[[NSMutableArray alloc]initWithArray:[updateDic allValues]] autorelease];
    [fieldValues addObject:approvedInfo.todoId];
    [fieldValues addObject:approvedInfo.guid];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE todoId=? and guid=?",TABLE_NAME,fieldsStr];
    [db executeUpdate:sql withArgumentsInArray:fieldValues];
}
-(BOOL)delete:(NSString *)todoId GUID:(NSString *)guid{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE todoId = ? and guid=?" inTable:TABLE_NAME],todoId,guid];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}
-(NSMutableArray *)searchApprovedInfoList:(NSString *)todoId Type:(NSString *)type{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	
	FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where todoId=? and approveType=?" inTable:TABLE_NAME],todoId,type];
	while ([rs next]) {
        ApprovedInfo *approvedInfo = [[ApprovedInfo alloc]init];
        [self setApprovedInfoProp:rs ApprovedInfo:approvedInfo];
		[result addObject:approvedInfo];
		[approvedInfo release];
	}
	[rs close];
	
	return result;
}
-(BOOL)deleteAll{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@" inTable:TABLE_NAME]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}

-(void)startReflashApprovedInfo:(NSString *)todoId{
    [db executeUpdate:[self SQL:@"UPDATE %@ SET syncFlag=? where todoId=?" inTable:TABLE_NAME],@"0",todoId];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}
}

-(void)endReflashApprovedInfo:(NSString *)todoId{
    [db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE syncFlag=? and todoId=?" inTable:TABLE_NAME],@"0",todoId];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}

}


#pragma mark - Private method implements
-(Boolean)containsKey:(NSString *)todoId GUID:(NSString *)guid{
    if (todoId==nil||guid==nil) {
        return NO;
    }
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@	WHERE todoId=? and guid=?" inTable:TABLE_NAME],todoId,guid];
    while ([rs next]) {
        [rs close];
        return YES;
    }
    [rs close];
    return NO;
}
-(void)setApprovedInfoProp:(FMResultSet *)rs ApprovedInfo:(ApprovedInfo *)approvedInfo{
    approvedInfo.todoId = [rs stringForColumn:@"todoId"];
    approvedInfo.day = [rs stringForColumn:@"day"];
    approvedInfo.dept = [rs stringForColumn:@"dept"];
    approvedInfo.guid = [rs stringForColumn:@"guid"];
    approvedInfo.time = [rs stringForColumn:@"time"];
    approvedInfo.type = [rs stringForColumn:@"type"];
    approvedInfo.cname = [rs stringForColumn:@"cname"];
    approvedInfo.deptId = [rs stringForColumn:@"deptId"];
    approvedInfo.remark = [rs stringForColumn:@"remark"];
    approvedInfo.todoId = [rs stringForColumn:@"todoId"];
    approvedInfo.updDate = [rs stringForColumn:@"updDate"];
    approvedInfo.stepname = [rs stringForColumn:@"stepname"];
    approvedInfo.userName = [rs stringForColumn:@"userName"];
    approvedInfo.cincident = [rs stringForColumn:@"cincident"];
    approvedInfo.optionCode = [rs stringForColumn:@"optionCode"];
    approvedInfo.userFullName = [rs stringForColumn:@"userFullName"];
    approvedInfo.fileGroupId = [rs stringForColumn:@"fileGroupId"];
    approvedInfo.approveType = [rs stringForColumn:@"approveType"];
    approvedInfo.cId = [rs stringForColumn:@"cId"];
    approvedInfo.pId = [rs stringForColumn:@"pId"];
}
@end
