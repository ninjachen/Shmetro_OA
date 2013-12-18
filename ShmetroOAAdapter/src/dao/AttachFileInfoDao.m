//
//  AttachFileInfoDao.m
//  ShmetroOA
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AttachFileInfoDao.h"
#import "SystemContext.h"
#include "JSON.h"
#import "NSString+SBJSON.h"

#define TODO_TABLE_NAME @"attachfileinfo"
#define WORKFLOW_TABLE_NAME @"wfattachfileinfo"
#define DOCUMENT_TABLE_NAME @"wfdocument"

#define TABLE_NAME @"attachfileinfo"
@interface AttachFileInfoDao(PrivateMethods)
-(void)insert:(AttachFileInfo *)fileInfo InTable:(NSString *)tableName;
-(void)update:(AttachFileInfo *)fileInfo InTable:(NSString *)tableName;
-(BOOL)delete:(NSString *)fileGroupId FileId:(NSString *)fileId InTable:(NSString *)tableName;
-(BOOL)deleteGroupFile:(NSString *)fileGroupId InTable:(NSString *)tableName;
-(NSMutableArray *)searchAttachFileInfoList:(NSString *)fileGroupId InTable:(NSString *)tableName;
-(BOOL)deleteAllInTable:(NSString *)tableName;

-(Boolean)containsKey:(NSString *)fileGroupId FileId:(NSString *)fileId InTable:(NSString *)tableName;
-(void)setAttachFileInfoProp:(FMResultSet *)rs AttachFileInfo:(AttachFileInfo *)attachFileInfo;
@end
@implementation AttachFileInfoDao

#pragma mark -TODO
-(void)insertTodo:(AttachFileInfo *)fileInfo{
    [self insert:fileInfo InTable:TODO_TABLE_NAME];
}
-(void)updateTodo:(AttachFileInfo *)fileInfo{
    [self update:fileInfo InTable:TODO_TABLE_NAME];
}
-(BOOL)deleteTodo:(NSString *)fileGroupId FileId:(NSString *)fileId{
    return  [self delete:fileGroupId FileId:fileId InTable:TODO_TABLE_NAME];
}
-(BOOL)deleteTodoGroupFile:(NSString *)fileGroupId{
    return  [self deleteGroupFile:fileGroupId InTable:TODO_TABLE_NAME];
}
-(NSMutableArray *)searchTodoAttachFileInfoList:(NSString *)fileGroupId{
    return [self searchAttachFileInfoList:fileGroupId InTable:TODO_TABLE_NAME];
}
-(BOOL)deleteTodoAll{
    return [self deleteAllInTable:TODO_TABLE_NAME];
}

#pragma mark - WORKFLOW
-(void)insertWorkflow:(AttachFileInfo *)fileInfo{
    [self insert:fileInfo InTable:WORKFLOW_TABLE_NAME];
}
-(void)updateWorkflow:(AttachFileInfo *)fileInfo{
    [self update:fileInfo InTable:WORKFLOW_TABLE_NAME];
}
-(BOOL)deleteWorkflow:(NSString *)fileGroupId FileId:(NSString *)fileId{
    return [self delete:fileGroupId FileId:fileId InTable:WORKFLOW_TABLE_NAME];
}
-(BOOL)deleteWorkflowGroupFile:(NSString *)pid{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE pid=?" inTable:WORKFLOW_TABLE_NAME],pid];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}
-(NSMutableArray *)searchWorkflowAttachFileInfoList:(NSString *)pid{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	
	FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where pid=?" inTable:WORKFLOW_TABLE_NAME],pid];
	while ([rs next]) {
        AttachFileInfo *attachFileInfo = [[AttachFileInfo alloc]init];
        [self setAttachFileInfoProp:rs AttachFileInfo:attachFileInfo];
		[result addObject:attachFileInfo];
		[attachFileInfo release];
	}
	[rs close];
	
	return result;
}
-(BOOL)deleteWorkflowAll{
    return [self deleteAllInTable:WORKFLOW_TABLE_NAME];
}

-(void)saveWorkflowInfoFromJsonValue:(id)jsonObj WithPid:(NSString *)pid{
    if (jsonObj!=nil && [jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        
        if ([[SystemContext singletonInstance]processHttpResponseCode:code]) {
            if ([jsonObj valueForKey:@"result"]) {
                id paramArray = [jsonObj valueForKey:@"result"];
                if ([[paramArray class]isSubclassOfClass:[NSArray class]]) {
                    if (paramArray!=nil&&[paramArray count]>0) {
                        [self deleteWorkflowGroupFile:pid];
                        AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
                        for (int i=0; i<[paramArray count]; i++) {
                            SBJsonWriter *fileObj = [paramArray objectAtIndex:i];
                            AttachFileInfo *fileInfo = [[[AttachFileInfo alloc]init] autorelease];
                            fileInfo.pid = pid;
                            if ([fileObj valueForKey:@"id"]) {
                                fileInfo.fileId = [fileObj valueForKey:@"id"];
                            }
                            if ([fileObj valueForKey:@"fileName"]) {
                                fileInfo.fileName = [fileObj valueForKey:@"fileName"];
                            }
                            if ([fileObj valueForKey:@"fileExtName"]) {
                                fileInfo.fileExtName = [fileObj valueForKey:@"fileExtName"];
                            }
                            if ([fileObj valueForKey:@"path"]) {
                                fileInfo.path = [fileObj valueForKey:@"path"];
                            }
                            if ([fileObj valueForKey:@"fileSize"]) {
                                fileInfo.fileSize = [fileObj valueForKey:@"fileSize"];
                            }
                            if ([fileObj valueForKey:@"uploader"]) {
                                fileInfo.uploader = [fileObj valueForKey:@"uploader"];
                            }
                            if ([fileObj valueForKey:@"uploaderLoginName"]) {
                                fileInfo.uploaderLoginName = [fileObj valueForKey:@"uploaderLoginName"];
                            }
                            if ([fileObj valueForKey:@"uploadDate"]) {
                                fileInfo.uploadDate = [fileObj valueForKey:@"uploadDate"];
                            }
                            if ([fileObj valueForKey:@"groupId"]) {
                                fileInfo.groupId = [fileObj valueForKey:@"groupId"];
                            }
                            if ([fileObj valueForKey:@"appName"]) {
                                fileInfo.appName = [fileObj valueForKey:@"appName"];
                            }
                            if ([fileObj valueForKey:@"saveFileName"]) {
                                fileInfo.saveFileName = [fileObj valueForKey:@"saveFileName"];
                            }
                            if ([fileObj valueForKey:@"memo"]) {
                                fileInfo.memo = [fileObj valueForKey:@"memo"];
                            }
                            if ([fileObj valueForKey:@"memo"]) {
                                fileInfo.memo = [fileObj valueForKey:@"memo"];
                            }
                            if ([fileObj valueForKey:@"version"]) {
                                fileInfo.version = [fileObj valueForKey:@"version"];
                            }
                            if ([fileObj valueForKey:@"status"]) {
                                fileInfo.status = [fileObj valueForKey:@"status"];
                            }
                            if ([fileObj valueForKey:@"operateTime"]) {
                                fileInfo.operateTime = [fileObj valueForKey:@"operateTime"];
                            }
                            if ([fileObj valueForKey:@"removed"]) {
                                fileInfo.removed = [fileObj valueForKey:@"removed"];
                            }
                            
                            [dao insertWorkflow:fileInfo];
                        }
                        [dao release];
                    }
                }
            }
            
        }
    }
}

#pragma mark - Document
-(void)insertDocument:(AttachFileInfo *)fileInfo{
    [self insert:fileInfo InTable:DOCUMENT_TABLE_NAME];
}
-(void)updateDocument:(AttachFileInfo *)fileInfo{
    [self update:fileInfo InTable:DOCUMENT_TABLE_NAME];
}
-(BOOL)deleteDocumentGroupFile:(NSString *)pid{
    return [self deleteGroupFile:pid InTable:DOCUMENT_TABLE_NAME];
}
-(NSMutableArray *)searchDocumentList:(NSString *)pid{
    return [self searchAttachFileInfoList:pid InTable:DOCUMENT_TABLE_NAME];
}
-(BOOL)deleteDocumentAll{
    return [self deleteAllInTable:DOCUMENT_TABLE_NAME];
}
-(void)saveDocumentFromJsonValue:(id)fileObj WithPid:(NSString *)pid{
    AttachFileInfo *fileInfo = [[[AttachFileInfo alloc]init] autorelease];
    fileInfo.pid = pid;
    if ([fileObj valueForKey:@"id"]) {
        fileInfo.fileId = [fileObj valueForKey:@"id"];
    }
    if ([fileObj valueForKey:@"fileName"]) {
        fileInfo.fileName = [fileObj valueForKey:@"fileName"];
    }
    if ([fileObj valueForKey:@"fileExtName"]) {
        fileInfo.fileExtName = [fileObj valueForKey:@"fileExtName"];
    }
    if ([fileObj valueForKey:@"path"]) {
        fileInfo.path = [fileObj valueForKey:@"path"];
    }
    if ([fileObj valueForKey:@"fileSize"]) {
        fileInfo.fileSize = [fileObj valueForKey:@"fileSize"];
    }
    if ([fileObj valueForKey:@"uploader"]) {
        fileInfo.uploader = [fileObj valueForKey:@"uploader"];
    }
    if ([fileObj valueForKey:@"uploaderLoginName"]) {
        fileInfo.uploaderLoginName = [fileObj valueForKey:@"uploaderLoginName"];
    }
    if ([fileObj valueForKey:@"uploadDate"]) {
        fileInfo.uploadDate = [fileObj valueForKey:@"uploadDate"];
    }
    if ([fileObj valueForKey:@"groupId"]) {
        fileInfo.groupId = [fileObj valueForKey:@"groupId"];
    }
    if ([fileObj valueForKey:@"appName"]) {
        fileInfo.appName = [fileObj valueForKey:@"appName"];
    }
    if ([fileObj valueForKey:@"saveFileName"]) {
        fileInfo.saveFileName = [fileObj valueForKey:@"saveFileName"];
    }
    if ([fileObj valueForKey:@"memo"]) {
        fileInfo.memo = [fileObj valueForKey:@"memo"];
    }
    if ([fileObj valueForKey:@"memo"]) {
        fileInfo.memo = [fileObj valueForKey:@"memo"];
    }
    if ([fileObj valueForKey:@"version"]) {
        fileInfo.version = [fileObj valueForKey:@"version"];
    }
    if ([fileObj valueForKey:@"status"]) {
        fileInfo.status = [fileObj valueForKey:@"status"];
    }
    if ([fileObj valueForKey:@"operateTime"]) {
        fileInfo.operateTime = [fileObj valueForKey:@"operateTime"];
    }
    if ([fileObj valueForKey:@"removed"]) {
        fileInfo.removed = [fileObj valueForKey:@"removed"];
    }
    AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
    [dao insertDocument:fileInfo];
    [dao release];
}

#pragma mark - Private Methods
-(void)insert:(AttachFileInfo *)fileInfo InTable:(NSString *)tableName{
    if (![self containsKey:fileInfo.groupId FileId:fileInfo.fileId InTable:tableName]) {
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (memo,path,fileId,status,appName,fileGroupId,removed,version,fileName,fileSize,uploader,uploadDate,fileExtName,operateTime,saveFileName,uploaderLoginName,syncFlag,pid) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" inTable:tableName],fileInfo.memo,fileInfo.path,fileInfo.fileId,fileInfo.status,fileInfo.appName,fileInfo.groupId,fileInfo.removed,fileInfo.version,fileInfo.fileName,fileInfo.fileSize,fileInfo.uploader,fileInfo.uploadDate,fileInfo.fileExtName,fileInfo.operateTime,fileInfo.saveFileName,fileInfo.uploaderLoginName,@"1",fileInfo.pid];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        
    } else {
        [self update:fileInfo InTable:tableName];
    }
}
-(void)update:(AttachFileInfo *)fileInfo InTable:(NSString *)tableName{
    NSMutableDictionary *updateDic = [[[NSMutableDictionary alloc]init] autorelease];
    if (fileInfo.fileName&&![fileInfo.fileName isEqualToString:@""]) {
        [updateDic setValue:fileInfo.fileName forKey:@"fileName"];
    }
    if (fileInfo.fileExtName&&![fileInfo.fileExtName isEqualToString:@""]) {
        [updateDic setValue:fileInfo.fileExtName forKey:@"fileExtName"];
    }
    if (fileInfo.path&&![fileInfo.path isEqualToString:@""]) {
        [updateDic setValue:fileInfo.path forKey:@"path"];
    }
    if (fileInfo.fileSize&&![fileInfo.fileSize isEqualToString:@""]) {
        [updateDic setValue:fileInfo.fileSize forKey:@"fileSize"];
    }
    if (fileInfo.uploader&&![fileInfo.uploader isEqualToString:@""]) {
        [updateDic setValue:fileInfo.uploader forKey:@"uploader"];
    }
    if (fileInfo.uploaderLoginName&&![fileInfo.uploaderLoginName isEqualToString:@""]) {
        [updateDic setValue:fileInfo.uploaderLoginName forKey:@"uploaderLoginName"];
    }
    if (fileInfo.uploadDate&&![fileInfo.uploadDate isEqualToString:@""]) {
        [updateDic setValue:fileInfo.uploadDate forKey:@"uploadDate"];
    }
    if (fileInfo.appName&&![fileInfo.appName isEqualToString:@""]) {
        [updateDic setValue:fileInfo.appName forKey:@"appName"];
    }
    if (fileInfo.saveFileName&&![fileInfo.saveFileName isEqualToString:@""]) {
        [updateDic setValue:fileInfo.saveFileName forKey:@"saveFileName"];
    }
    if (fileInfo.memo&&![fileInfo.memo isEqualToString:@""]) {
        [updateDic setValue:fileInfo.memo forKey:@"memo"];
    }
    if (fileInfo.version&&![fileInfo.version isEqualToString:@""]) {
        [updateDic setValue:fileInfo.version forKey:@"version"];
    }
    if (fileInfo.status&&![fileInfo.status isEqualToString:@""]) {
        [updateDic setValue:fileInfo.status forKey:@"status"];
    }
    if (fileInfo.operateTime&&![fileInfo.operateTime isEqualToString:@""]) {
        [updateDic setValue:fileInfo.operateTime forKey:@"operateTime"];
    }
    if (fileInfo.localPath&&![fileInfo.localPath isEqualToString:@""]) {
        [updateDic setValue:fileInfo.localPath forKey:@"localPath"];
    }
    if (fileInfo.downloadUrl&&![fileInfo.downloadUrl isEqualToString:@""]) {
        [updateDic setValue:fileInfo.downloadUrl forKey:@"downloadUrl"];
    }
    if (fileInfo.removed&&![fileInfo.removed isEqualToString:@""]) {
        [updateDic setValue:fileInfo.removed forKey:@"removed"];
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
    [fieldValues addObject:fileInfo.groupId];
    [fieldValues addObject:fileInfo.fileId];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE fileGroupId=? and fileId=?",tableName,fieldsStr];
    [db executeUpdate:sql withArgumentsInArray:fieldValues];
}
-(BOOL)delete:(NSString *)fileGroupId FileId:(NSString *)fileId InTable:(NSString *)tableName{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE fileGroupId=? and fileId=?" inTable:tableName],fileGroupId,fileId];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}
-(BOOL)deleteGroupFile:(NSString *)fileGroupId InTable:(NSString *)tableName{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE fileGroupId=?" inTable:tableName],fileGroupId];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}
-(NSMutableArray *)searchAttachFileInfoList:(NSString *)fileGroupId InTable:(NSString *)tableName{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    NSString *filedGroupName = @"pid";
    
	if ([tableName isEqualToString:TODO_TABLE_NAME]) {
        filedGroupName = @"fileGroupId";
    }
//	FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where %@=?" inTable:tableName],fileGroupId,filedGroupName];
    NSString *select = [NSString stringWithFormat:@"SELECT * FROM %@ where %@=?", tableName, filedGroupName];
    FMResultSet *rs = [db executeQuery:select, fileGroupId];
	while ([rs next]) {
        AttachFileInfo *attachFileInfo = [[AttachFileInfo alloc]init];
        [self setAttachFileInfoProp:rs AttachFileInfo:attachFileInfo];
		[result addObject:attachFileInfo];
		[attachFileInfo release];
	}
	[rs close];
	
	return result;
}
-(BOOL)deleteAllInTable:(NSString *)tableName{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@" inTable:tableName]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}
-(void)startReflashAttachFileInfo:(NSString *)fileGroupId{
    [db executeUpdate:[self SQL:@"UPDATE %@ SET syncFlag=? where fileGroupId=?" inTable:TABLE_NAME],@"0",fileGroupId];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}
}
-(void)endReflashAttachFileInfo:(NSString *)fileGroupId{
    [db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE syncFlag=? and fileGroupId=?" inTable:TABLE_NAME],@"0",fileGroupId];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}
}

#pragma mark - Private Method Implements
-(Boolean)containsKey:(NSString *)fileGroupId FileId:(NSString *)fileId InTable:(NSString *)tableName{
    if (fileGroupId==nil||fileId==nil) {
        return NO;
    }
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@	WHERE fileGroupId=? and fileId=?" inTable:tableName],fileGroupId,fileId];
    while ([rs next]) {
        [rs close];
        return YES;
    }
    [rs close];
    return NO;
}
-(void)setAttachFileInfoProp:(FMResultSet *)rs AttachFileInfo:(AttachFileInfo *)attachFileInfo
{
    attachFileInfo.fileId = [rs stringForColumn:@"fileId"];
    attachFileInfo.memo = [rs stringForColumn:@"memo"];
    attachFileInfo.path = [rs stringForColumn:@"path"];
    attachFileInfo.status = [rs stringForColumn:@"status"];
    attachFileInfo.appName = [rs stringForColumn:@"appName"];
    attachFileInfo.groupId = [rs stringForColumn:@"fileGroupId"];
    attachFileInfo.removed = [rs stringForColumn:@"removed"];
    attachFileInfo.version = [rs stringForColumn:@"version"];
    attachFileInfo.fileName = [rs stringForColumn:@"fileName"];
    attachFileInfo.uploader = [rs stringForColumn:@"uploader"];
    attachFileInfo.uploadDate = [rs stringForColumn:@"uploadDate"];
    attachFileInfo.fileExtName = [rs stringForColumn:@"fileExtName"];
    attachFileInfo.operateTime = [rs stringForColumn:@"operateTime"];
    attachFileInfo.saveFileName = [rs stringForColumn:@"saveFileName"];
    attachFileInfo.uploaderLoginName = [rs stringForColumn:@"uploaderLoginName"];
    attachFileInfo.localPath = [rs stringForColumn:@"localPath"];
    attachFileInfo.downloadUrl = [rs stringForColumn:@"downloadUrl"];
    attachFileInfo.fileSize = [rs stringForColumn:@"fileSize"];
}
@end
