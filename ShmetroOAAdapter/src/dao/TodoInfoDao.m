//
//  TodoInfoDao.m
//  ShmetroOA
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TodoInfoDao.h"
#import "UserAccountContext.h"
#import "ApprovedInfoDao.h"
#include "JSON.h"
#import "NSString+SBJSON.h"
#import "SystemContext.h"

#define TABLE_NAME @"todoinfo"
static NSString *APPROVE_TYPE_APPLY=@"APPLY";
static NSString *APPROVE_TYPE_SUB=@"SUB";
static NSString *APPROVE_TYPE_BACK=@"BACK";
@interface TodoInfoDao(PrivateMethods)
-(Boolean)containsKey:(NSString *)todoId;
-(void)setTodoInfoProp:(FMResultSet *)rs TodoInfo:(TodoInfo *)todoInfo;
@end

@implementation TodoInfoDao
-(void)insert:(TodoInfo *)todoInfo{
    if (![self containsKey:todoInfo.todoId]) {
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (todoId,app,key,data,title,status,userId,removed,todoType,loginName,occurTime,deptId,syncFlag,steplabel) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)" inTable:TABLE_NAME],todoInfo.todoId,todoInfo.app,todoInfo.key,todoInfo.data,todoInfo.title,todoInfo.status,todoInfo.userId,todoInfo.removed,todoInfo.todoType,todoInfo.loginName,todoInfo.occurTime,[[[UserAccountContext singletonInstance] userAccountInfo] deptId],@"1",todoInfo.steplabel];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        ApprovedInfoDao *approvedDao = [[ApprovedInfoDao alloc]init];
        if (todoInfo.applyApprovedArr!=nil&&[todoInfo.applyApprovedArr count]>0) {
            for (int j=0; j<[todoInfo.applyApprovedArr count]; j++) {
                [approvedDao insert:[todoInfo.applyApprovedArr objectAtIndex:j]];
            }
        }
        if (todoInfo.subApprovedArr!=nil&&[todoInfo.subApprovedArr count]>0) {
            for (int m=0; m<[todoInfo.subApprovedArr count]; m++) {
                [approvedDao insert:[todoInfo.subApprovedArr objectAtIndex:m]];
            }
        }
        if (todoInfo.backApplyApprovedArr!=nil&&[todoInfo.backApplyApprovedArr count]>0) {
            for (int n=0; n<[todoInfo.backApplyApprovedArr count]; n++) {
                [approvedDao insert:[todoInfo.backApplyApprovedArr objectAtIndex:n]];
            }
        }
        
        [approvedDao release];
    } else {
        [self update:todoInfo];
    } 
}
-(void)update:(TodoInfo *)todoInfo{
    NSMutableDictionary *updateDic = [[[NSMutableDictionary alloc]init] autorelease];
    if ((NSNull*)todoInfo.app!=[NSNull null] &&![todoInfo.app isEqualToString:@""]) {
        [updateDic setValue:todoInfo.app forKey:@"app"];
    }
    if ((NSNull*)todoInfo.key!=[NSNull null] &&![todoInfo.key isEqualToString:@""]) {
        [updateDic setValue:todoInfo.key forKey:@"key"];
    }
    if ((NSNull*)todoInfo.data!=[NSNull null] &&![todoInfo.data isEqualToString:@""]) {
        [updateDic setValue:todoInfo.data forKey:@"data"];
    }
    if ((NSNull*)todoInfo.title!=[NSNull null] &&![todoInfo.title isEqualToString:@""]) {
        [updateDic setValue:todoInfo.title forKey:@"title"];
    }
    if ((NSNull*)todoInfo.status!=[NSNull null] &&![todoInfo.status isEqualToString:@""]) {
        [updateDic setValue:todoInfo.status forKey:@"status"];
    }
    if ((NSNull*)todoInfo.userId!=[NSNull null] &&![todoInfo.userId isEqualToString:@""]) {
        [updateDic setValue:todoInfo.userId forKey:@"userId"];
    }
    if ((NSNull*)todoInfo.removed!=[NSNull null] &&![todoInfo.removed isEqualToString:@""]) {
        [updateDic setValue:todoInfo.removed forKey:@"removed"];
    }
    if ((NSNull*)todoInfo.todoType!=[NSNull null] &&![todoInfo.todoType isEqualToString:@""]) {
        [updateDic setValue:todoInfo.todoType forKey:@"todoType"];
    }
    if ((NSNull*)todoInfo.loginName!=[NSNull null] &&![todoInfo.loginName isEqualToString:@""]) {
        [updateDic setValue:todoInfo.loginName forKey:@"loginName"];
    }
    if ((NSNull*)todoInfo.occurTime!=[NSNull null] &&![todoInfo.occurTime isEqualToString:@""]) {
        [updateDic setValue:todoInfo.occurTime forKey:@"occurTime"];
    }
    if ((NSNull*)todoInfo.deptId!=[NSNull null] &&![todoInfo.deptId isEqualToString:@""]) {
        [updateDic setValue:todoInfo.deptId forKey:@"deptId"];
    }
    if ((NSNull*)todoInfo.instanceId!=[NSNull null] &&![todoInfo.instanceId isEqualToString:@""]) {
        [updateDic setValue:todoInfo.instanceId forKey:@"instanceId"];
    }
    
    if ((NSNull*)todoInfo.mainUnitId!=[NSNull null] &&![todoInfo.mainUnitId isEqualToString:@""]) {
        [updateDic setValue:todoInfo.mainUnitId forKey:@"mainUnitId"];
    }
    if ((NSNull*)todoInfo.mainUnit!=[NSNull null] &&![todoInfo.mainUnit isEqualToString:@""]) {
        [updateDic setValue:todoInfo.mainUnit forKey:@"mainUnit"];
    }
    if ((NSNull*)todoInfo.copyUnitId!=[NSNull null] &&![todoInfo.copyUnitId isEqualToString:@""]) {
        [updateDic setValue:todoInfo.copyUnitId forKey:@"copyUnitId"];
    }
    if ((NSNull*)todoInfo.copyUnit!=[NSNull null] &&![todoInfo.copyUnit isEqualToString:@""]) {
        [updateDic setValue:todoInfo.copyUnit forKey:@"copyUnit"];
    }
    if ((NSNull*)todoInfo.contactDate!=[NSNull null] &&![todoInfo.contactDate isEqualToString:@""]) {
        [updateDic setValue:todoInfo.contactDate forKey:@"contactDate"];
    }
    if ((NSNull*)todoInfo.replyDate!=[NSNull null] &&![todoInfo.replyDate isEqualToString:@""]) {
        [updateDic setValue:todoInfo.replyDate forKey:@"replyDate"];
    }
    if ((NSNull*)todoInfo.timeDiff!=[NSNull null] &&![todoInfo.timeDiff isEqualToString:@""]) {
        [updateDic setValue:todoInfo.timeDiff forKey:@"timeDiff"];
    }
    if ((NSNull*)todoInfo.theme!=[NSNull null] &&![todoInfo.theme isEqualToString:@""]) {
        [updateDic setValue:todoInfo.theme forKey:@"theme"];
    }
    if ((NSNull*)todoInfo.content!=[NSNull null] &&![todoInfo.content isEqualToString:@""]) {
        [updateDic setValue:todoInfo.content forKey:@"content"];
    }
    if ((NSNull*)todoInfo.contentAttachmentId!=[NSNull null] &&![todoInfo.contentAttachmentId isEqualToString:@""]) {
        [updateDic setValue:todoInfo.contentAttachmentId forKey:@"contentAttachmentId"];
    }
    if ((NSNull*)todoInfo.processname!=[NSNull null] &&![todoInfo.processname isEqualToString:@""]) {
        [updateDic setValue:todoInfo.processname forKey:@"processname"];
    }
    if ((NSNull*)todoInfo.incidentno!=[NSNull null] &&![todoInfo.incidentno isEqualToString:@""]) {
        [updateDic setValue:todoInfo.incidentno forKey:@"incidentno"];
    }
    if ((NSNull*)todoInfo.serial!=[NSNull null] &&![todoInfo.serial isEqualToString:@""]) {
        [updateDic setValue:todoInfo.serial forKey:@"serial"];
    }
    if ((NSNull*)todoInfo.createDeptid!=[NSNull null] &&![todoInfo.createDeptid isEqualToString:@""]) {
        [updateDic setValue:todoInfo.createDeptid forKey:@"createDeptid"];
    }
    if ((NSNull*)todoInfo.createDeptName!=[NSNull null] &&![todoInfo.createDeptName isEqualToString:@""]) {
        [updateDic setValue:todoInfo.createDeptName forKey:@"createDeptName"];
    }
    if ((NSNull*)todoInfo.initiator!=[NSNull null] &&![todoInfo.initiator isEqualToString:@""]) {
        [updateDic setValue:todoInfo.initiator forKey:@"initiator"];
    }
    if ((NSNull*)todoInfo.initiatorName!=[NSNull null] &&![todoInfo.initiatorName isEqualToString:@""]) {
        [updateDic setValue:todoInfo.initiatorName forKey:@"initiatorName"];
    }
    if ((NSNull*)todoInfo.startTime!=[NSNull null] &&![todoInfo.startTime isEqualToString:@""]) {
        [updateDic setValue:todoInfo.startTime forKey:@"startTime"];
    }
    if ((NSNull*)todoInfo.updateTime!=[NSNull null] &&![todoInfo.updateTime isEqualToString:@""]) {
        [updateDic setValue:todoInfo.updateTime forKey:@"updateTime"];
    }
    if ((NSNull*)todoInfo.operateUser!=[NSNull null] &&![todoInfo.operateUser isEqualToString:@""]) {
        [updateDic setValue:todoInfo.operateUser forKey:@"operateUser"];
    }
    if ((NSNull*)todoInfo.operateName!=[NSNull null] &&![todoInfo.operateName isEqualToString:@""]) {
        [updateDic setValue:todoInfo.operateName forKey:@"operateName"];
    }
    if ((NSNull*)todoInfo.operateName!=[NSNull null] &&![todoInfo.operateName isEqualToString:@""]) {
        [updateDic setValue:todoInfo.operateName forKey:@"operateName"];
    }
    if ((NSNull*)todoInfo.operateDate!=[NSNull null] &&![todoInfo.operateDate isEqualToString:@""]) {
        [updateDic setValue:todoInfo.operateDate forKey:@"operateDate"];
    }
    if ((NSNull*)todoInfo.recordPath!=[NSNull null] &&![todoInfo.recordPath isEqualToString:@""]) {
        [updateDic setValue:todoInfo.recordPath forKey:@"recordPath"];
    }
    if ((NSNull*)todoInfo.processFlag!=[NSNull null] &&![todoInfo.processFlag isEqualToString:@""]) {
        [updateDic setValue:todoInfo.processFlag forKey:@"processFlag"];
    }
    if((NSNull*)todoInfo.processText!=[NSNull null] &&![todoInfo.processText isEqualToString:@""]){
        [updateDic setValue:todoInfo.processText forKey:@"processText"];
    }
    if((NSNull*)todoInfo.steplabel!=[NSNull null] &&![todoInfo.steplabel isEqualToString:@""]){
        [updateDic setValue:todoInfo.steplabel forKey:@"steplabel"];
    }
    if((NSNull*)todoInfo.uploadfilegroupid!=[NSNull null] &&![todoInfo.uploadfilegroupid isEqualToString:@""]){
        [updateDic setValue:todoInfo.uploadfilegroupid forKey:@"uploadfilegroupid"];
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
    NSMutableArray *fieldValues = [[NSMutableArray alloc]initWithArray:[updateDic allValues]];
    [fieldValues addObject:todoInfo.todoId];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE todoId=?",TABLE_NAME,fieldsStr];
    [db executeUpdate:sql withArgumentsInArray:fieldValues];
    [fieldValues release];
    ApprovedInfoDao *approvedDao = [[ApprovedInfoDao alloc]init];
    if (todoInfo.applyApprovedArr!=nil&&[todoInfo.applyApprovedArr count]>0) {
        for (int j=0; j<[todoInfo.applyApprovedArr count]; j++) {
            [approvedDao insert:[todoInfo.applyApprovedArr objectAtIndex:j]];
        }
    }
    if (todoInfo.subApprovedArr!=nil&&[todoInfo.subApprovedArr count]>0) {
        for (int m=0; m<[todoInfo.subApprovedArr count]; m++) {
            [approvedDao insert:[todoInfo.subApprovedArr objectAtIndex:m]];
        }
    }
    if (todoInfo.backApplyApprovedArr!=nil&&[todoInfo.backApplyApprovedArr count]>0) {
        for (int n=0; n<[todoInfo.backApplyApprovedArr count]; n++) {
            [approvedDao insert:[todoInfo.backApplyApprovedArr objectAtIndex:n]];
        }
    }
    
    [approvedDao release];
}

/*
 -(void)update:(TodoInfo *)todoInfo{
 NSMutableDictionary *updateDic = [[[NSMutableDictionary alloc]init] autorelease];
 if (todoInfo.app&&![todoInfo.app isEqualToString:@""]) {
 [updateDic setValue:todoInfo.app forKey:@"app"];
 }
 if (todoInfo.key&&![todoInfo.key isEqualToString:@""]) {
 [updateDic setValue:todoInfo.key forKey:@"key"];
 }
 if (todoInfo.data&&![todoInfo.data isEqualToString:@""]) {
 [updateDic setValue:todoInfo.data forKey:@"data"];
 }
 if (todoInfo.title&&![todoInfo.title isEqualToString:@""]) {
 [updateDic setValue:todoInfo.title forKey:@"title"];
 }
 if (todoInfo.status&&![todoInfo.status isEqualToString:@""]) {
 [updateDic setValue:todoInfo.status forKey:@"status"];
 }
 if (todoInfo.userId&&![todoInfo.userId isEqualToString:@""]) {
 [updateDic setValue:todoInfo.userId forKey:@"userId"];
 }
 if (todoInfo.removed&&![todoInfo.removed isEqualToString:@""]) {
 [updateDic setValue:todoInfo.removed forKey:@"removed"];
 }
 if (todoInfo.todoType&&![todoInfo.todoType isEqualToString:@""]) {
 [updateDic setValue:todoInfo.todoType forKey:@"todoType"];
 }
 if (todoInfo.loginName&&![todoInfo.loginName isEqualToString:@""]) {
 [updateDic setValue:todoInfo.loginName forKey:@"loginName"];
 }
 if (todoInfo.occurTime&&![todoInfo.occurTime isEqualToString:@""]) {
 [updateDic setValue:todoInfo.occurTime forKey:@"occurTime"];
 }
 if (todoInfo.deptId&&![todoInfo.deptId isEqualToString:@""]) {
 [updateDic setValue:todoInfo.deptId forKey:@"deptId"];
 }
 if (todoInfo.instanceId&&![todoInfo.instanceId isEqualToString:@""]) {
 [updateDic setValue:todoInfo.instanceId forKey:@"instanceId"];
 }
 
 if (todoInfo.mainUnitId&&![todoInfo.mainUnitId isEqualToString:@""]) {
 [updateDic setValue:todoInfo.mainUnitId forKey:@"mainUnitId"];
 }
 if (todoInfo.mainUnit&&![todoInfo.mainUnit isEqualToString:@""]) {
 [updateDic setValue:todoInfo.mainUnit forKey:@"mainUnit"];
 }
 if (todoInfo.copyUnitId&&![todoInfo.copyUnitId isEqualToString:@""]) {
 [updateDic setValue:todoInfo.copyUnitId forKey:@"copyUnitId"];
 }
 if (todoInfo.copyUnit&&![todoInfo.copyUnit isEqualToString:@""]) {
 [updateDic setValue:todoInfo.copyUnit forKey:@"copyUnit"];
 }
 if (todoInfo.contactDate&&![todoInfo.contactDate isEqualToString:@""]) {
 [updateDic setValue:todoInfo.contactDate forKey:@"contactDate"];
 }
 if (todoInfo.replyDate&&![todoInfo.replyDate isEqualToString:@""]) {
 [updateDic setValue:todoInfo.replyDate forKey:@"replyDate"];
 }
 if (todoInfo.timeDiff&&![todoInfo.timeDiff isEqualToString:@""]) {
 [updateDic setValue:todoInfo.timeDiff forKey:@"timeDiff"];
 }
 if (todoInfo.theme&&![todoInfo.theme isEqualToString:@""]) {
 [updateDic setValue:todoInfo.theme forKey:@"theme"];
 }
 if (todoInfo.content&&![todoInfo.content isEqualToString:@""]) {
 [updateDic setValue:todoInfo.content forKey:@"content"];
 }
 if (todoInfo.contentAttachmentId&&![todoInfo.contentAttachmentId isEqualToString:@""]) {
 [updateDic setValue:todoInfo.contentAttachmentId forKey:@"contentAttachmentId"];
 }
 if (todoInfo.processname&&![todoInfo.processname isEqualToString:@""]) {
 [updateDic setValue:todoInfo.processname forKey:@"processname"];
 }
 if (todoInfo.incidentno&&![todoInfo.incidentno isEqualToString:@""]) {
 [updateDic setValue:todoInfo.incidentno forKey:@"incidentno"];
 }
 if (todoInfo.serial&&![todoInfo.serial isEqualToString:@""]) {
 [updateDic setValue:todoInfo.serial forKey:@"serial"];
 }
 if (todoInfo.createDeptid&&![todoInfo.createDeptid isEqualToString:@""]) {
 [updateDic setValue:todoInfo.createDeptid forKey:@"createDeptid"];
 }
 if (todoInfo.createDeptName&&![todoInfo.createDeptName isEqualToString:@""]) {
 [updateDic setValue:todoInfo.createDeptName forKey:@"createDeptName"];
 }
 if (todoInfo.initiator&&![todoInfo.initiator isEqualToString:@""]) {
 [updateDic setValue:todoInfo.initiator forKey:@"initiator"];
 }
 if (todoInfo.initiatorName&&![todoInfo.initiatorName isEqualToString:@""]) {
 [updateDic setValue:todoInfo.initiatorName forKey:@"initiatorName"];
 }
 if (todoInfo.startTime&&![todoInfo.startTime isEqualToString:@""]) {
 [updateDic setValue:todoInfo.startTime forKey:@"startTime"];
 }
 if (todoInfo.updateTime&&![todoInfo.updateTime isEqualToString:@""]) {
 [updateDic setValue:todoInfo.updateTime forKey:@"updateTime"];
 }
 if (todoInfo.operateUser&&![todoInfo.operateUser isEqualToString:@""]) {
 [updateDic setValue:todoInfo.operateUser forKey:@"operateUser"];
 }
 if (todoInfo.operateName&&![todoInfo.operateName isEqualToString:@""]) {
 [updateDic setValue:todoInfo.operateName forKey:@"operateName"];
 }
 if (todoInfo.operateName&&![todoInfo.operateName isEqualToString:@""]) {
 [updateDic setValue:todoInfo.operateName forKey:@"operateName"];
 }
 if (todoInfo.operateDate&&![todoInfo.operateDate isEqualToString:@""]) {
 [updateDic setValue:todoInfo.operateDate forKey:@"operateDate"];
 }
 if (todoInfo.recordPath&&![todoInfo.recordPath isEqualToString:@""]) {
 [updateDic setValue:todoInfo.recordPath forKey:@"recordPath"];
 }
 if (todoInfo.processFlag&&![todoInfo.processFlag isEqualToString:@""]) {
 [updateDic setValue:todoInfo.processFlag forKey:@"processFlag"];
 }
 if(todoInfo.processText&&![todoInfo.processText isEqualToString:@""]){
 [updateDic setValue:todoInfo.processText forKey:@"processText"];
 }
 if(todoInfo.steplabel&&![todoInfo.steplabel isEqualToString:@""]){
 [updateDic setValue:todoInfo.steplabel forKey:@"steplabel"];
 }
 if(todoInfo.uploadfilegroupid&&![todoInfo.uploadfilegroupid isEqualToString:@""]){
 [updateDic setValue:todoInfo.uploadfilegroupid forKey:@"uploadfilegroupid"];
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
 NSMutableArray *fieldValues = [[NSMutableArray alloc]initWithArray:[updateDic allValues]];
 [fieldValues addObject:todoInfo.todoId];
 NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE todoId=?",TABLE_NAME,fieldsStr];
 [db executeUpdate:sql withArgumentsInArray:fieldValues];
 [fieldValues release];
 ApprovedInfoDao *approvedDao = [[ApprovedInfoDao alloc]init];
 if (todoInfo.applyApprovedArr!=nil&&[todoInfo.applyApprovedArr count]>0) {
 for (int j=0; j<[todoInfo.applyApprovedArr count]; j++) {
 [approvedDao insert:[todoInfo.applyApprovedArr objectAtIndex:j]];
 }
 }
 if (todoInfo.subApprovedArr!=nil&&[todoInfo.subApprovedArr count]>0) {
 for (int m=0; m<[todoInfo.subApprovedArr count]; m++) {
 [approvedDao insert:[todoInfo.subApprovedArr objectAtIndex:m]];
 }
 }
 if (todoInfo.backApplyApprovedArr!=nil&&[todoInfo.backApplyApprovedArr count]>0) {
 for (int n=0; n<[todoInfo.backApplyApprovedArr count]; n++) {
 [approvedDao insert:[todoInfo.backApplyApprovedArr objectAtIndex:n]];
 }
 }
 
 [approvedDao release];
 }

 */
-(BOOL)delete:(NSString *)todoId{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE todoId = ?" inTable:TABLE_NAME],todoId];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}
-(NSMutableArray *)searchAllTodoInfoList{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
//	FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where deptId=? and (processFlag is null or processFlag='0')" inTable:TABLE_NAME],[[[UserAccountContext singletonInstance] userAccountInfo] deptId]];
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where loginName=? and (processFlag is null or processFlag='0')" inTable:TABLE_NAME],[[[UserAccountContext singletonInstance] userAccountInfo] loginName]];
	while ([rs next]) {
        TodoInfo *todoInfo = [[TodoInfo alloc]init];
        [self setTodoInfoProp:rs TodoInfo:todoInfo];
        
        
		[result addObject:todoInfo];
		[todoInfo release];
	}
	[rs close];
	if ([result count]>0) {
        ApprovedInfoDao *approvedDao = [[ApprovedInfoDao alloc]init];
        for (int i=0; i<[result count]; i++) {
            TodoInfo *todoInfo2 = [result objectAtIndex:i];
            todoInfo2.applyApprovedArr = [approvedDao searchApprovedInfoList:todoInfo2.todoId Type:APPROVE_TYPE_APPLY];
            todoInfo2.subApprovedArr = [approvedDao searchApprovedInfoList:todoInfo2.todoId Type:APPROVE_TYPE_SUB];
            todoInfo2.backApplyApprovedArr = [approvedDao searchApprovedInfoList:todoInfo2.todoId Type:APPROVE_TYPE_BACK];
        }
        [approvedDao release];
    }
	return result;
}
-(TodoInfo *)getTodoInfo:(NSString *)todoId{
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where todoId=?" inTable:TABLE_NAME],todoId];
    TodoInfo *todoInfo = nil;
	while ([rs next]) {
        todoInfo = [[[TodoInfo alloc]init] autorelease];
        [self setTodoInfoProp:rs TodoInfo:todoInfo];
	}
	
	[rs close];
    ApprovedInfoDao *approvedDao = [[ApprovedInfoDao alloc]init];
    todoInfo.applyApprovedArr = [approvedDao searchApprovedInfoList:todoId Type:APPROVE_TYPE_APPLY];
    todoInfo.subApprovedArr = [approvedDao searchApprovedInfoList:todoId Type:APPROVE_TYPE_SUB];
    todoInfo.backApplyApprovedArr = [approvedDao searchApprovedInfoList:todoId Type:APPROVE_TYPE_BACK];
    [approvedDao release];
    return todoInfo;
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
-(void)startReflashTodoInfo{
    [db executeUpdate:[self SQL:@"UPDATE %@ SET syncFlag=? where deptId=?" inTable:TABLE_NAME],@"0",[[[UserAccountContext singletonInstance] userAccountInfo] deptId]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}
}
-(void)endReflashTodoInfo{
    [db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE syncFlag=? and deptId=?" inTable:TABLE_NAME],@"0",[[[UserAccountContext singletonInstance] userAccountInfo] deptId]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}
}

#pragma mark - private method implements
-(Boolean)containsKey:(NSString *)todoId{
    if (todoId==nil) {
        return NO;
    }
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@	WHERE todoId=?" inTable:TABLE_NAME],todoId];
    while ([rs next]) {
        [rs close];
        return YES;
    }
    [rs close];
    return NO;
}
//todoId,app,key,data,title,status,userId,removed,todoType,loginName,occurtime,deptId,syncFlag
-(void)setTodoInfoProp:(FMResultSet *)rs TodoInfo:(TodoInfo *)todoInfo{
    todoInfo.todoId = [rs stringForColumn:@"todoId"];
    todoInfo.app = [rs stringForColumn:@"app"];
    todoInfo.key = [rs stringForColumn:@"key"];
    todoInfo.data = [rs stringForColumn:@"data"];
    todoInfo.title = [rs stringForColumn:@"title"];
    todoInfo.status = [rs stringForColumn:@"status"];
    todoInfo.userId = [rs stringForColumn:@"userId"];
    todoInfo.removed = [rs stringForColumn:@"removed"];
    todoInfo.todoType = [rs stringForColumn:@"todoType"];
    todoInfo.loginName = [rs stringForColumn:@"loginName"];
    todoInfo.occurTime = [rs stringForColumn:@"occurTime"];
    todoInfo.deptId = [rs stringForColumn:@"deptId"];
    todoInfo.mainUnitId = [rs stringForColumn:@"mainUnitId"];
    todoInfo.mainUnit = [rs stringForColumn:@"mainUnit"];
    todoInfo.copyUnitId = [rs stringForColumn:@"copyUnitId"];
    todoInfo.copyUnit = [rs stringForColumn:@"copyUnit"];
    todoInfo.contactDate = [rs stringForColumn:@"contactDate"];
    todoInfo.replyDate = [rs stringForColumn:@"replyDate"];
    todoInfo.timeDiff = [rs stringForColumn:@"timeDiff"];
    todoInfo.theme = [rs stringForColumn:@"theme"];
    todoInfo.content = [rs stringForColumn:@"content"];
    todoInfo.contentAttachmentId = [rs stringForColumn:@"contentAttachmentId"];
    todoInfo.processname = [rs stringForColumn:@"processname"];
    todoInfo.incidentno = [rs stringForColumn:@"incidentno"];
    todoInfo.serial = [rs stringForColumn:@"serial"];
    todoInfo.createDeptid = [rs stringForColumn:@"createDeptid"];
    todoInfo.createDeptName = [rs stringForColumn:@"createDeptName"];
    todoInfo.initiator = [rs stringForColumn:@"initiator"];
    todoInfo.initiatorName = [rs stringForColumn:@"initiatorName"];
    todoInfo.startTime = [rs stringForColumn:@"startTime"];
    todoInfo.updateTime = [rs stringForColumn:@"updateTime"];
    todoInfo.operateUser = [rs stringForColumn:@"operateUser"];
    todoInfo.operateName = [rs stringForColumn:@"operateName"];
    todoInfo.operateDate = [rs stringForColumn:@"operateDate"];
    todoInfo.instanceId = [rs stringForColumn:@"instanceId"];
    todoInfo.recordPath = [rs stringForColumn:@"recordPath"];
    todoInfo.processFlag = [rs stringForColumn:@"processFlag"];
    todoInfo.processText = [rs stringForColumn:@"processText"];
    todoInfo.steplabel = [rs stringForColumn:@"steplabel"];
    todoInfo.uploadfilegroupid = [rs stringForColumn:@"uploadfilegroupid"];
}

-(NSMutableArray *)searchTodoInfoListByTypename:(NSString*)typeName{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];

    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where loginName=? and processname=? and (processFlag is null or processFlag='0')" inTable:TABLE_NAME],[[[UserAccountContext singletonInstance] userAccountInfo] loginName],typeName];
	while ([rs next]) {
        TodoInfo *todoInfo = [[TodoInfo alloc]init];
        [self setTodoInfoProp:rs TodoInfo:todoInfo];
        
        
		[result addObject:todoInfo];
		[todoInfo release];
	}
	[rs close];
	if ([result count]>0) {
        ApprovedInfoDao *approvedDao = [[ApprovedInfoDao alloc]init];
        for (int i=0; i<[result count]; i++) {
            TodoInfo *todoInfo2 = [result objectAtIndex:i];
            todoInfo2.applyApprovedArr = [approvedDao searchApprovedInfoList:todoInfo2.todoId Type:APPROVE_TYPE_APPLY];
            todoInfo2.subApprovedArr = [approvedDao searchApprovedInfoList:todoInfo2.todoId Type:APPROVE_TYPE_SUB];
            todoInfo2.backApplyApprovedArr = [approvedDao searchApprovedInfoList:todoInfo2.todoId Type:APPROVE_TYPE_BACK];
        }
        [approvedDao release];
    }
	return result;
}

-(void)insertTodoInfo:(TodoInfo *)todoInfo{
    if (![self containsKey:todoInfo.todoId]) {
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (todoId,app,key,data,title,status,userId,removed,todoType,loginName,occurTime,deptId,syncFlag,steplabel,processname) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" inTable:TABLE_NAME],todoInfo.todoId,todoInfo.app,todoInfo.key,todoInfo.data,todoInfo.title,todoInfo.status,todoInfo.userId,todoInfo.removed,todoInfo.todoType,todoInfo.loginName,todoInfo.occurTime,[[[UserAccountContext singletonInstance] userAccountInfo] deptId],@"1",todoInfo.steplabel,todoInfo.processname];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        ApprovedInfoDao *approvedDao = [[ApprovedInfoDao alloc]init];
        if (todoInfo.applyApprovedArr!=nil&&[todoInfo.applyApprovedArr count]>0) {
            for (int j=0; j<[todoInfo.applyApprovedArr count]; j++) {
                [approvedDao insert:[todoInfo.applyApprovedArr objectAtIndex:j]];
            }
        }
        if (todoInfo.subApprovedArr!=nil&&[todoInfo.subApprovedArr count]>0) {
            for (int m=0; m<[todoInfo.subApprovedArr count]; m++) {
                [approvedDao insert:[todoInfo.subApprovedArr objectAtIndex:m]];
            }
        }
        if (todoInfo.backApplyApprovedArr!=nil&&[todoInfo.backApplyApprovedArr count]>0) {
            for (int n=0; n<[todoInfo.backApplyApprovedArr count]; n++) {
                [approvedDao insert:[todoInfo.backApplyApprovedArr objectAtIndex:n]];
            }
        }
        
        [approvedDao release];
    } else {
        [self update:todoInfo];
    }
}

-(void)saveJsonItemToTodoList:(id)jsonObj{

                if ([[jsonObj class] isSubclassOfClass:[NSArray class]]) {
                    if (jsonObj!=nil&&[jsonObj count]>0) {
                        TodoInfoDao *dao = [[TodoInfoDao alloc]init];
                        for (int i=0; i<[jsonObj count]; i++) {
                            SBJsonParser *paramObj = [jsonObj objectAtIndex:i];
                            TodoInfo *todoInfo = [[[TodoInfo alloc]init] autorelease];
                            if ([paramObj valueForKey:@"id"]) {
                                todoInfo.todoId = [paramObj valueForKey:@"id"];
                            }
                            if ([paramObj valueForKey:@"app"]) {
                                todoInfo.app = [paramObj valueForKey:@"app"];
                            }
                            if ([paramObj valueForKey:@"type"]) {
                                NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                                todoInfo.todoType= [numberFormatter stringFromNumber:[paramObj valueForKey:@"type"]];
                            }
                            if ([paramObj valueForKey:@"key"]) {
                                todoInfo.key = [paramObj valueForKey:@"key"];
                            }
                            if ([paramObj valueForKey:@"occurtime"]) {
                                todoInfo.occurTime = [paramObj valueForKey:@"occurtime"];
                            }
                            if ([paramObj valueForKey:@"title"]) {
                                todoInfo.title = [paramObj valueForKey:@"title"];
                            }
                            if ([paramObj valueForKey:@"typename"]) {
                                todoInfo.processname = [paramObj valueForKey:@"typename"];
                            }
                            
                            if ([paramObj valueForKey:@"data"]) {
                                SBJsonParser *dataPara = [paramObj valueForKey:@"data"];
                                //todoInfo.steplabel = [dataPara valueForKey:@"STEPLABEL"];
                                todoInfo.data = [dataPara description];
                            }
                            if ([paramObj valueForKey:@"stepname"]) {
                                todoInfo.steplabel = [paramObj valueForKey:@"stepname"];
                            }
                            if ([paramObj valueForKey:@"userid"]) {
                                todoInfo.userId = [paramObj valueForKey:@"userid"];
                            }
                            if ([paramObj valueForKey:@"loginname"]) {
                                todoInfo.loginName=[[[UserAccountContext singletonInstance]userAccountInfo]loginName];
                                // todoInfo.loginName = [paramObj valueForKey:@"loginName"];
                            }
                            if ([paramObj valueForKey:@"status"]) {
                                NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                                todoInfo.status= [numberFormatter stringFromNumber:[paramObj valueForKey:@"status"]];
                            }
                            if ([paramObj valueForKey:@"removed"]) {
                                NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                                todoInfo.removed = [numberFormatter stringFromNumber:[paramObj valueForKey:@"removed"]];
                            }
                            [dao insertTodoInfo:todoInfo];
                        }
                        [dao release];
                    }
                }else{
                    TodoInfoDao *dao = [[TodoInfoDao alloc]init];
                    SBJsonParser *paramObj = jsonObj;
                    
                    TodoInfo *todoInfo = [[[TodoInfo alloc]init] autorelease];
                    if ([paramObj valueForKey:@"id"]) {
                        todoInfo.todoId = [paramObj valueForKey:@"id"];
                    }
                    if ([paramObj valueForKey:@"app"]) {
                        todoInfo.app = [paramObj valueForKey:@"app"];
                    }
                    if ([paramObj valueForKey:@"type"]) {
                        NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                        todoInfo.todoType= [numberFormatter stringFromNumber:[paramObj valueForKey:@"type"]];
                    }
                    if ([paramObj valueForKey:@"key"]) {
                        todoInfo.key = [paramObj valueForKey:@"key"];
                    }
                    if ([paramObj valueForKey:@"occurtime"]) {
                        todoInfo.occurTime = [paramObj valueForKey:@"occurtime"];
                    }
                    if ([paramObj valueForKey:@"title"]) {
                        todoInfo.title = [paramObj valueForKey:@"title"];
                    }
                    if ([paramObj valueForKey:@"typename"]) {
                        todoInfo.processname = [paramObj valueForKey:@"typename"];
                    }
                    if ([paramObj valueForKey:@"stepname"]) {
                        todoInfo.steplabel = [paramObj valueForKey:@"stepname"];
                    }
                    if ([paramObj valueForKey:@"data"]) {
                        todoInfo.data = [[paramObj valueForKey:@"data"] description];
                    }
                    if ([paramObj valueForKey:@"userid"]) {
                        todoInfo.userId = [paramObj valueForKey:@"userid"];
                    }
                    if ([paramObj valueForKey:@"loginname"]) {
                        todoInfo.loginName = [paramObj valueForKey:@"loginname"];
                    }
                    if ([paramObj valueForKey:@"status"]) {
                        NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                        todoInfo.status= [numberFormatter stringFromNumber:[paramObj valueForKey:@"status"]];
                    }
                    if ([paramObj valueForKey:@"removed"]) {
                        NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                        todoInfo.removed = [numberFormatter stringFromNumber:[paramObj valueForKey:@"removed"]];
                    }
                    [dao insertTodoInfo:todoInfo];
                    [dao release];
                }
            }

/*
-(void)saveJsonItemToTodoList:(id)jsonObj{
    if (jsonObj!=nil&&[jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        NSString *description = @"";
        if ([jsonObj valueForKey:@"description"]) {
            description = [jsonObj valueForKey:@"description"];
        }
        if ([[SystemContext singletonInstance] processHttpResponseCode:code Desc:description]) {
            id paraArr = [jsonObj valueForKey:@"result"];
            if (paraArr) {
                if ([[paraArr class] isSubclassOfClass:[NSArray class]]) {
                    if (paraArr!=nil&&[paraArr count]>0) {
                        TodoInfoDao *dao = [[TodoInfoDao alloc]init];
                        for (int i=0; i<[paraArr count]; i++) {
                            SBJsonParser *paramObj = [paraArr objectAtIndex:i];
                            TodoInfo *todoInfo = [[[TodoInfo alloc]init] autorelease];
                            if ([paramObj valueForKey:@"id"]) {
                                todoInfo.todoId = [paramObj valueForKey:@"id"];
                            }
                            if ([paramObj valueForKey:@"app"]) {
                                todoInfo.app = [paramObj valueForKey:@"app"];
                            }
                            if ([paramObj valueForKey:@"type"]) {
                                todoInfo.todoType = [paramObj valueForKey:@"type"];
                            }
                            if ([paramObj valueForKey:@"key"]) {
                                todoInfo.key = [paramObj valueForKey:@"key"];
                            }
                            if ([paramObj valueForKey:@"occurtime"]) {
                                todoInfo.occurTime = [paramObj valueForKey:@"occurtime"];
                            }
                            if ([paramObj valueForKey:@"title"]) {
                                todoInfo.title = [paramObj valueForKey:@"title"];
                            }
                            if ([paramObj valueForKey:@"typename"]) {
                                todoInfo.processname = [paramObj valueForKey:@"typename"];
                            }
                            
                            if ([paramObj valueForKey:@"data"]) {
                                SBJsonParser *dataPara = [paramObj valueForKey:@"data"];
                                //todoInfo.steplabel = [dataPara valueForKey:@"STEPLABEL"];
                                todoInfo.data = [dataPara description];
                            }
                            if ([paramObj valueForKey:@"stepname"]) {
                                todoInfo.steplabel = [paramObj valueForKey:@"stepname"];
                            }
                            if ([paramObj valueForKey:@"userid"]) {
                                todoInfo.userId = [paramObj valueForKey:@"userid"];
                            }
                            if ([paramObj valueForKey:@"loginname"]) {
                                todoInfo.loginName=[[[UserAccountContext singletonInstance]userAccountInfo]loginName];
                                // todoInfo.loginName = [paramObj valueForKey:@"loginName"];
                            }
                            if ([paramObj valueForKey:@"status"]) {
                                todoInfo.status = [paramObj valueForKey:@"status"];
                            }
                            if ([paramObj valueForKey:@"removed"]) {
                                todoInfo.removed = [paramObj valueForKey:@"removed"];
                            }
                            [dao insert:todoInfo];
                        }
                        [dao release];
                    }
                }else{
                    TodoInfoDao *dao = [[TodoInfoDao alloc]init];
                    SBJsonParser *paramObj;
                    if ([paraArr objectForKey:@"param"]) {
                        paramObj = [paraArr objectForKey:@"param"];
                    }else{
                        paramObj = paraArr;
                    }
                    TodoInfo *todoInfo = [[[TodoInfo alloc]init] autorelease];
                    if ([paramObj valueForKey:@"id"]) {
                        todoInfo.todoId = [paramObj valueForKey:@"id"];
                    }
                    if ([paramObj valueForKey:@"app"]) {
                        todoInfo.app = [paramObj valueForKey:@"app"];
                    }
                    if ([paramObj valueForKey:@"type"]) {
                        todoInfo.todoType = [paramObj valueForKey:@"type"];
                    }
                    if ([paramObj valueForKey:@"key"]) {
                        todoInfo.key = [paramObj valueForKey:@"key"];
                    }
                    if ([paramObj valueForKey:@"occurtime"]) {
                        todoInfo.occurTime = [paramObj valueForKey:@"occurtime"];
                    }
                    if ([paramObj valueForKey:@"title"]) {
                        todoInfo.title = [paramObj valueForKey:@"title"];
                    }
                    if ([paramObj valueForKey:@"typename"]) {
                        todoInfo.processname = [paramObj valueForKey:@"typename"];
                    }
                    if ([paramObj valueForKey:@"stepname"]) {
                        todoInfo.steplabel = [paramObj valueForKey:@"stepname"];
                    }
                    if ([paramObj valueForKey:@"data"]) {
                        todoInfo.data = [[paramObj valueForKey:@"data"] description];
                    }
                    if ([paramObj valueForKey:@"usertd"]) {
                        todoInfo.userId = [paramObj valueForKey:@"usertd"];
                    }
                    if ([paramObj valueForKey:@"loginname"]) {
                        todoInfo.loginName = [paramObj valueForKey:@"loginname"];
                    }
                    if ([paramObj valueForKey:@"status"]) {
                        todoInfo.status = [paramObj valueForKey:@"status"];
                    }
                    if ([paramObj valueForKey:@"removed"]) {
                        todoInfo.removed = [paramObj valueForKey:@"removed"];
                    }
                    [dao insert:todoInfo];
                    [dao release];
                }
            }
            
        }
    }
}

*/


@end
