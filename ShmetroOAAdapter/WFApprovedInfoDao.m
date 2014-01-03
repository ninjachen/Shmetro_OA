//
//  WFApprovedInfoDao.m
//  ShmetroOA
//
//  Created by gisteam on 8/26/13.
//
//

#import "WFApprovedInfoDao.h"
#import "SystemContext.h"
#include "JSON.h"
#import "NSString+SBJSON.h"

#define TABLE_NAME @"wfapprovedinfo"
@interface WFApprovedInfoDao(PrivateMethods)
-(Boolean)containsKey:(NSString *)todoId GUID:(NSString *)guid;
-(void)setWFApprovedInfoProp:(FMResultSet *)rs WFApprovedInfo:(WFApprovedInfo *)wfApprovedInfo;
@end

@implementation WFApprovedInfoDao
-(void)insert:(WFApprovedInfo *)approvedInfo{
    if (![self containsKey:approvedInfo.guid]) {
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (guid,process,incidentno,dept,deptId,remark,upddate,stepname,userName,userFullName,agree,disagree,returned,status,fllowFlag,readFlag,rounds,upddateStr,optionCode) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" inTable:TABLE_NAME],approvedInfo.guid,approvedInfo.process,approvedInfo.incidentno,approvedInfo.dept,approvedInfo.deptId,approvedInfo.remark,approvedInfo.upddate,approvedInfo.stepname,approvedInfo.userName,approvedInfo.userFullName,approvedInfo.agree,approvedInfo.disagree,approvedInfo.returned,approvedInfo.status,approvedInfo.fllowFlag,approvedInfo.readFlag,approvedInfo.rounds,approvedInfo.upddateStr,approvedInfo.optionCode];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        
    } else {
        [self update:approvedInfo];
    }
}
-(void)update:(WFApprovedInfo *)approvedInfo{
    NSMutableDictionary *updateDic = [[[NSMutableDictionary alloc]init] autorelease];
    if (approvedInfo.guid&&![approvedInfo.guid isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.guid forKey:@"guid"];
    }
    if (approvedInfo.process&&![approvedInfo.process isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.process forKey:@"process"];
    }
    if (approvedInfo.dept&&![approvedInfo.dept isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.dept forKey:@"dept"];
        }
    if (approvedInfo.deptId&&![approvedInfo.deptId isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.deptId forKey:@"deptId"];
    }
    if (approvedInfo.remark&&![approvedInfo.remark isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.remark forKey:@"remark"];
    }
       if (approvedInfo.stepname&&![approvedInfo.stepname isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.stepname forKey:@"stepname"];
    }
    if (approvedInfo.userName&&![approvedInfo.userName isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.userName forKey:@"userName"];
    }
  
    if (approvedInfo.optionCode&&![approvedInfo.optionCode isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.optionCode forKey:@"optionCode"];
    }
    if (approvedInfo.userFullName&&![approvedInfo.userFullName isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.userFullName forKey:@"userFullName"];
    }
    if (approvedInfo.upddate&&![approvedInfo.upddate isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.upddate forKey:@"upddate"];
    }
    if (approvedInfo.agree&&![approvedInfo.agree isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.agree forKey:@"agree"];
    }
    if (approvedInfo.disagree&&![approvedInfo.disagree isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.disagree forKey:@"disagree"];
    }
    if (approvedInfo.returned&&![approvedInfo.returned isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.returned forKey:@"returned"];
    }
    if (approvedInfo.status&&![approvedInfo.status isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.status forKey:@"status"];
    }
    if (approvedInfo.fllowFlag&&![approvedInfo.fllowFlag isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.fllowFlag forKey:@"fllowFlag"];
    }
    if (approvedInfo.readFlag&&![approvedInfo.readFlag isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.readFlag forKey:@"readFlag"];
    }
    if (approvedInfo.rounds&&![approvedInfo.rounds isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.rounds forKey:@"rounds"];
    }
    if (approvedInfo.upddateStr&&![approvedInfo.upddateStr isEqualToString:@""]) {
        [updateDic setValue:approvedInfo.upddateStr forKey:@"upddateStr"];
    }
    //[updateDic setValue:[NSString stringWithFormat:@"%d",1] forKey:@"syncFlag"];
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
    [fieldValues addObject:approvedInfo.guid];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE guid=?",TABLE_NAME,fieldsStr];
    [db executeUpdate:sql withArgumentsInArray:fieldValues];
}

-(NSDictionary *)searchWFApprovedInfoList:(NSString *)pid{
    NSDictionary *result = [[[NSMutableDictionary alloc]init]autorelease];
    
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where incidentno =? and stepname in (?,?,?,?,?,?,?,?)" inTable:TABLE_NAME],pid,@"签发领导",@"领导",@"起草",@"拟稿人修改",@"核稿",@"校稿",@"套头",@"办结"];
	while ([rs next]) {
        WFApprovedInfo *approvedInfo = [[WFApprovedInfo alloc]init];
        [self setWFApprovedInfoProp:rs WFApprovedInfo:approvedInfo];
        if ([approvedInfo.stepname isEqualToString:@"签发领导"]) {
            [result setValue:approvedInfo forKey:@"签发"];
        }else if([approvedInfo.stepname isEqualToString:@"领导"]){
            [result setValue:approvedInfo forKey:@"会签"];
        }else if([approvedInfo.stepname isEqualToString:@"起草"] || [approvedInfo.stepname isEqualToString:@"拟稿人"]){
            [result setValue:approvedInfo forKey:@"拟稿"];
        }else if([approvedInfo.stepname isEqualToString:@"核搞"]){
            [result setValue:approvedInfo forKey:@"核搞"];
        }else if([approvedInfo.stepname isEqualToString:@"校稿"]){
             [result setValue:approvedInfo forKey:@"校对"];
        }else if([approvedInfo.stepname isEqualToString:@"套头"]){
            [result setValue:approvedInfo forKey:@"套头意见"];
        }else if([approvedInfo.stepname isEqualToString:@"办结"]){
            [result setValue:approvedInfo forKey:@"办结人意见"];
        }
		[approvedInfo release];
	}
	[rs close];
	
	return result;
    
}
-(NSMutableArray *)searchApprovedInfoList:(NSString *)pid{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	
	FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where pid=? and stepname in (?,?,?,?,?,?,?,?)" inTable:TABLE_NAME],pid,@"签发领导",@"领导",@"起草",@"拟稿人修改",@"核稿",@"校稿",@"套头",@"办结"];
	while ([rs next]) {
        WFApprovedInfo *approvedInfo = [[WFApprovedInfo alloc]init];
        [self setWFApprovedInfoProp:rs WFApprovedInfo:approvedInfo];
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

-(void)saveWFApprovedInfoListFromJsonValue:(id)jsonObj{
    if (jsonObj!=nil && [jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        
        if ([[SystemContext singletonInstance]processHttpResponseCode:code]) {
            if ([jsonObj valueForKey:@"result"]) {
                id paramArray = [jsonObj valueForKey:@"result"];
                if ([[paramArray class]isSubclassOfClass:[NSArray class]]) {
                    if (paramArray!=nil && [paramArray count]>0) {
                        [self deleteAll];
                        
                        for (int i=0; i<[paramArray count]; i++) {
                            SBJsonWriter *paramObj = [paramArray objectAtIndex:i];
                            WFApprovedInfo *wfApprovedInfo = [[WFApprovedInfo alloc]init];
                            if ([paramObj valueForKey:@"guid"]) {
                               wfApprovedInfo.guid = [paramObj valueForKey:@"guid"];
                            }
                            if ([paramObj valueForKey:@"process"]) {
                                wfApprovedInfo.process = [paramObj valueForKey:@"process"];
                            }
                            if ([paramObj valueForKey:@"incidentno"]) {
                                wfApprovedInfo.incidentno = [paramObj valueForKey:@"incidentno"];
                            }
                            if ([paramObj valueForKey:@"dept"]) {
                                wfApprovedInfo.dept = [paramObj valueForKey:@"dept"];
                            }
                            if ([paramObj valueForKey:@"stepname"]) {
                                wfApprovedInfo.stepname = [paramObj valueForKey:@"stepname"];
                            }
                            if ([paramObj valueForKey:@"username"]) {
                                wfApprovedInfo.userName = [paramObj valueForKey:@"username"];
                            }
                            if ([paramObj valueForKey:@"userfullname"]) {
                                wfApprovedInfo.userFullName = [paramObj valueForKey:@"userfullname"];
                            }
                            if ([paramObj valueForKey:@"remark"]) {
                                wfApprovedInfo.remark = [paramObj valueForKey:@"remark"];
                            }
                            if ([paramObj valueForKey:@"agree"]) {
                                wfApprovedInfo.agree = [paramObj valueForKey:@"agree"];
                            }
                            if ([paramObj valueForKey:@"disagree"]) {
                                wfApprovedInfo.disagree = [paramObj valueForKey:@"disagree"];
                            }
                            if ([paramObj valueForKey:@"returned"]) {
                                wfApprovedInfo.returned = [paramObj valueForKey:@"returned"];
                            }
                            if ([paramObj valueForKey:@"upddate"]) {
                                wfApprovedInfo.upddate = [paramObj valueForKey:@"upddate"];
                            }
                            if ([paramObj valueForKey:@"status"]) {
                                wfApprovedInfo.status = [paramObj valueForKey:@"status"];
                            }
                            if ([paramObj valueForKey:@"fllowFlag"]) {
                                wfApprovedInfo.fllowFlag = [paramObj valueForKey:@"fllowFlag"];
                            }
                            if ([paramObj valueForKey:@"readFlag"]) {
                                wfApprovedInfo.readFlag = [paramObj valueForKey:@"readFlag"];
                            }
                            if ([paramObj valueForKey:@"deptId"]) {
                                wfApprovedInfo.deptId = [paramObj valueForKey:@"deptId"];
                            }
                            if ([paramObj valueForKey:@"rounds"]) {
                                wfApprovedInfo.rounds = [paramObj valueForKey:@"rounds"];
                            }
                            if ([paramObj valueForKey:@"upddateStr"]) {
                                wfApprovedInfo.upddateStr = [paramObj valueForKey:@"upddateStr"];
                            }
                            if ([paramObj valueForKey:@"optionCode"]) {
                                wfApprovedInfo.optionCode = [paramObj valueForKey:@"optionCode"];
                            }
                            
                            [self insert:wfApprovedInfo];
                            [wfApprovedInfo release];
                        }
                    }
                }
            }
        }
    }

}

#pragma mark - Private method implements
-(Boolean)containsKey:(NSString *)guid{
    if (guid==nil) {
        return NO;
    }
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@	WHERE  guid=?" inTable:TABLE_NAME],guid];
    while ([rs next]) {
        [rs close];
        return YES;
    }
    [rs close];
    return NO;
}

-(void)setWFApprovedInfoProp:(FMResultSet *)rs WFApprovedInfo:(WFApprovedInfo *)wfApprovedInfo{
    wfApprovedInfo.guid = [rs stringForColumn:@"guid"];
    wfApprovedInfo.process = [rs stringForColumn:@"process"];
    wfApprovedInfo.incidentno = [rs stringForColumn:@"incidentno"];
    wfApprovedInfo.dept = [rs stringForColumn:@"dept"];
    wfApprovedInfo.stepname = [rs stringForColumn:@"stepname"];
    wfApprovedInfo.deptId = [rs stringForColumn:@"deptId"];
    wfApprovedInfo.agree = [rs stringForColumn:@"agree"];
    wfApprovedInfo.disagree = [rs stringForColumn:@"disagree"];
    wfApprovedInfo.deptId = [rs stringForColumn:@"deptId"];
    wfApprovedInfo.remark = [rs stringForColumn:@"remark"];
    wfApprovedInfo.upddate = [rs stringForColumn:@"upddate"];
    wfApprovedInfo.stepname = [rs stringForColumn:@"stepname"];
    wfApprovedInfo.userName = [rs stringForColumn:@"userName"];
    wfApprovedInfo.userFullName = [rs stringForColumn:@"userFullName"];
    wfApprovedInfo.returned = [rs stringForColumn:@"returned"];
    wfApprovedInfo.status = [rs stringForColumn:@"status"];
    wfApprovedInfo.fllowFlag = [rs stringForColumn:@"fllowFlag"];
    wfApprovedInfo.readFlag = [rs stringForColumn:@"readFlag"];
    wfApprovedInfo.rounds = [rs stringForColumn:@"rounds"];
    wfApprovedInfo.upddateStr = [rs stringForColumn:@"upddateStr"];
}

@end
