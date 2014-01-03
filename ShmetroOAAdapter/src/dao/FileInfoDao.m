//
//  FileInfoDao.m
//  EYun
//
//  Created by caven on 11-9-8.
//  Copyright 2011Âπ¥ __MyCompanyName__. All rights reserved.
//

#import "FileInfoDao.h"
#import "UserAccountContext.h"
#define TABLE_NAME @"fileInfo"
@interface FileInfoDao (PrivateMethod)
-(Boolean)containsKey:(FileInfo *)fileInfo;
-(NSMutableArray *)searchFileInfo:(NSDictionary *)searhPara;
-(void)setFileInfoPara:(FMResultSet *)rs FileInfo:(FileInfo *)fileInfo;
-(NSString *)getMediaId:(NSString *)mediaPath;
@end


@implementation FileInfoDao
-(void)insert:(FileInfo *)fileInfo{
    if ([self containsKey:fileInfo]) {
        [self update:fileInfo];
    }else{
        UserAccountContext *userAccountContext = [UserAccountContext singletonInstance];
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (fileID,fileName,fileSize,fileType,status,downloadUrl,uploadType,uploadStatus,createTime,localPath,date,localDate,localModifyTime,uploadFlag,syncFlag,mediaPath,userId,groupId,todoId) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" inTable:TABLE_NAME],fileInfo.fileID,fileInfo.fileName,fileInfo.fileSize,fileInfo.fileType,fileInfo.status,fileInfo.downloadUrl,fileInfo.uploadType,fileInfo.uploadStatus,fileInfo.createTime,fileInfo.localPath,fileInfo.date,fileInfo.localDate,fileInfo.localModifyTime,fileInfo.uploadFlag,fileInfo.syncFlag,fileInfo.mediaPath,userAccountContext.userAccountInfo.userId,fileInfo.groupId,fileInfo.todoId];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
    }
    
}
-(Boolean)containsKey:(FileInfo *)fileInfo{
    Boolean resp = NO;
    if (fileInfo!=nil) {
        
        if(fileInfo.fileID!=nil){
            FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@	WHERE fileID=?" inTable:TABLE_NAME],fileInfo.fileID];
            while ([rs next]) {
                fileInfo.index = [rs stringForColumn:@"id"];
                resp = YES;
            }
            [rs close];
        }    
    }
    return resp;
    
}
-(void)update:(FileInfo *)fileInfo{
	NSMutableDictionary *updateDic = [[[NSMutableDictionary alloc]init] autorelease];
    
    if (fileInfo.fileID&&![fileInfo.fileID isEqualToString:@""]) {
        [updateDic setValue:fileInfo.fileID forKey:@"fileID"];
    }
    if(fileInfo.fileName&&![fileInfo.fileName isEqualToString:@""]){
        [updateDic setValue:fileInfo.fileName forKey:@"fileName"];
    }
    if(fileInfo.fileSize&&![fileInfo.fileSize isEqualToString:@""]){
        [updateDic setValue:fileInfo.fileSize forKey:@"fileSize"];
    }
    if(fileInfo.fileType&&![fileInfo.fileType isEqualToString:@""]){
        [updateDic setValue:fileInfo.fileType forKey:@"fileType"];
    }
    if(fileInfo.status&&![fileInfo.status isEqualToString:@""]){
        [updateDic setValue:fileInfo.status forKey:@"status"];
    }
    if(fileInfo.downloadUrl&&![fileInfo.downloadUrl isEqualToString:@""]){
        [updateDic setValue:fileInfo.downloadUrl forKey:@"downloadUrl"];
    }
    if(fileInfo.uploadType&&![fileInfo.uploadType isEqualToString:@""]){
        [updateDic setValue:fileInfo.uploadType forKey:@"uploadType"];
    }
    if(fileInfo.uploadStatus&&![fileInfo.uploadStatus isEqualToString:@""]){
        [updateDic setValue:fileInfo.uploadStatus forKey:@"uploadStatus"];
    }
    if(fileInfo.createTime&&![fileInfo.createTime isEqualToString:@""]){
        [updateDic setValue:fileInfo.createTime forKey:@"createTime"];
    }
    if(fileInfo.localPath&&![fileInfo.localPath isEqualToString:@""]){
        [updateDic setValue:fileInfo.localPath forKey:@"localPath"];
    }
    if(fileInfo.date&&![fileInfo.date isEqualToString:@""]){
        [updateDic setValue:fileInfo.date forKey:@"date"];
    }
    if(fileInfo.localDate&&![fileInfo.date isEqualToString:@""]){
        [updateDic setValue:fileInfo.localDate forKey:@"localDate"];
    }
    if(fileInfo.localModifyTime&&![fileInfo.localModifyTime isEqualToString:@""]){
        [updateDic setValue:fileInfo.localModifyTime forKey:@"localModifyTime"];
    }
    if(fileInfo.uploadFlag&&![fileInfo.uploadFlag isEqualToString:@""]){
        [updateDic setValue:fileInfo.uploadFlag forKey:@"uploadFlag"];
    }
    if(fileInfo.downloadFlag&&![fileInfo.downloadFlag isEqualToString:@""]){
        [updateDic setValue:fileInfo.downloadFlag forKey:@"downloadFlag"];
    }
    if(fileInfo.percent>=0){
        [updateDic setValue:[NSNumber numberWithInt:fileInfo.percent] forKey:@"percent"];
    }
    if(fileInfo.mediaPath&&![fileInfo.mediaPath isEqualToString:@""]){
        [updateDic setValue:fileInfo.mediaPath forKey:@"mediaPath"];
    }
    if(fileInfo.groupId&&![fileInfo.groupId isEqualToString:@""]){
        [updateDic setValue:fileInfo.groupId forKey:@"groupId"];
    }
    if(fileInfo.todoId&&![fileInfo.todoId isEqualToString:@""]){
        [updateDic setValue:fileInfo.todoId forKey:@"todoId"];
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
    [fieldValues addObject:[NSNumber numberWithInt:[fileInfo.index intValue]]];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE id=?",TABLE_NAME,fieldsStr];
    [db executeUpdate:sql withArgumentsInArray:fieldValues];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}
}




-(NSArray *)searchFileInfoArr{
    UserAccountContext *userAccountContext = [UserAccountContext singletonInstance];
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ WHERE userId=? and syncFlag=? and (uploadFlag is null or uploadFlag=?)" inTable:TABLE_NAME],userAccountContext.userAccountInfo.userId,@"1",@"13"];
    NSMutableArray *respArr = [[[NSMutableArray alloc]init] autorelease];
	while ([rs next]) {
        FileInfo *fileInfo = [[FileInfo alloc]init];
        [self setFileInfoPara:rs FileInfo:fileInfo];
		[respArr addObject:fileInfo];
		[fileInfo release];
	}
	
	[rs close];
    return respArr;
}
-(BOOL)deleteByFileID:(NSString *)fileID{
    BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE fileID = ?" inTable:TABLE_NAME],fileID];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}
- (BOOL)delete:(NSString *)index{
	BOOL success = YES;
	[db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE id = ?" inTable:TABLE_NAME],[NSNumber numberWithInt:[index intValue]]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}

-(NSMutableArray *)searchUploadArr{
    UserAccountContext *userAccountContext = [UserAccountContext singletonInstance];
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ WHERE userId=? and ( uploadFlag=? OR uploadFlag=? OR uploadFlag=?)" inTable:TABLE_NAME],userAccountContext.userAccountInfo.userId,[FileInfo UPLOAD_FLAG_BEGIN],[FileInfo UPLOAD_FLAG_ING],[FileInfo UPLOAD_FLAG_FAIL]];
    while ([rs next]) {
        FileInfo *fileInfo = [[FileInfo alloc]init];
        [self setFileInfoPara:rs FileInfo:fileInfo];
		[result addObject:fileInfo];
		[fileInfo release];
    }
    return result;
}

-(BOOL)deleteAllUploadArr{
    UserAccountContext *userAccountContext = [UserAccountContext singletonInstance];
    BOOL success = YES;
    [db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE userId = ? and ( uploadFlag=? OR uploadFlag=? OR uploadFlag=?)" inTable:TABLE_NAME],userAccountContext.userAccountInfo.userId,[FileInfo UPLOAD_FLAG_BEGIN],[FileInfo UPLOAD_FLAG_ING],[FileInfo UPLOAD_FLAG_FAIL]];
    if ([db hadError]) {
    	NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    	success = NO;
    }
    return success;
}

-(NSMutableArray *)searchDownloadArr{
    UserAccountContext *userAccountContext = [UserAccountContext singletonInstance];
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ WHERE userId=? and ( downloadFlag=? OR downloadFlag=? OR downloadFlag=?)" inTable:TABLE_NAME],userAccountContext.userAccountInfo.userId,[FileInfo DOWNLOAD_FLAG_BEGIN],[FileInfo DOWNLOAD_FLAG_ING],[FileInfo DOWNLOAD_FLAG_FAIL]];
    while ([rs next]) {
        FileInfo *fileInfo = [[FileInfo alloc]init];
        [self setFileInfoPara:rs FileInfo:fileInfo];
		[result addObject:fileInfo];
		[fileInfo release];
    }
    return result;
}

-(BOOL)deleteAllDownloadArr{
    UserAccountContext *userAccountContext = [UserAccountContext singletonInstance];
    BOOL success = YES;
    [db executeUpdate:[self SQL:@"UPDATE %@ SET downloadFlag=? and downloadUrl =? and percent=? and localPath=? WHERE userId=? and ( downloadFlag=? OR downloadFlag=? OR downloadFlag=?)" inTable:TABLE_NAME],@"",@"",[NSNumber numberWithInt:0],@"",userAccountContext.userAccountInfo.userId,[FileInfo DOWNLOAD_FLAG_BEGIN],[FileInfo DOWNLOAD_FLAG_ING],[FileInfo DOWNLOAD_FLAG_BEGIN]];
    if ([db hadError]) {
    	NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    	success = NO;
    }
    return success;
}

-(void)cancelDownload:(NSString *)fileID{
    FileInfo *fileInfo = [[[FileInfo alloc]init] autorelease];
    fileInfo.fileID = fileID;
    fileInfo.downloadFlag = @"null";
    fileInfo.downloadUrl = @"";
    fileInfo.percent = 0;
    fileInfo.localPath = @"";
    [self insert:fileInfo];
}

-(FileInfo *)getFileInfo:(NSString *)fileId{
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where fileID=?" inTable:TABLE_NAME],fileId];
    FileInfo *fileInfo = nil;
	while ([rs next]) {
        fileInfo = [[[FileInfo alloc]init] autorelease];
        [self setFileInfoPara:rs FileInfo:fileInfo];
	}
	
	[rs close];
    return fileInfo;
}
-(FileInfo *)getFileInfoByIndex:(NSString *)fileIndex{
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ where id=?" inTable:TABLE_NAME],[NSNumber numberWithInt:[fileIndex intValue]]];
    FileInfo *fileInfo = nil;
	while ([rs next]) {
        fileInfo = [[[FileInfo alloc]init] autorelease];
        [self setFileInfoPara:rs FileInfo:fileInfo];
	}
	
	[rs close];
    return fileInfo;
}


-(void)insertUploadFile:(FileInfo *)fileInfo{
    fileInfo.uploadFlag = [FileInfo UPLOAD_FLAG_BEGIN];
    [self insert:fileInfo];
}

-(void)insertDownloadFile:(FileInfo *)fileInfo{
    fileInfo.uploadFlag = [FileInfo DOWNLOAD_FLAG_BEGIN];
    [self insert:fileInfo];
}

-(BOOL)checkUploaed:(NSString *)filePath{
    if (filePath==nil) {
        return NO;
    }
    UserAccountContext *userAccountContext = [UserAccountContext singletonInstance];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:filePath forKey:@"mediaPath"];
    [dic setValue:userAccountContext.userAccountInfo.userId forKey:@"userId"];
    NSMutableArray *queryArr = [self searchFileInfo:dic];
    [dic release];
    if (queryArr!=nil&&[queryArr count]>0) {
        return YES;
    }else{
        return NO;
    }
    return NO;

}

- (void)dealloc
{
	[super dealloc];
}


#pragma mark - PrivateMethods Implements
-(NSMutableArray *)searchFileInfo:(NSDictionary *)searhPara{
    NSString *whereStr=@"";
    NSString *key;
    if ([searhPara.allKeys count]>0) {
        for (int i=0; i<[searhPara.allKeys count]; i++) {
            key = [searhPara.allKeys objectAtIndex:i];
            if (i==0) {
                whereStr = [NSString stringWithFormat:@"%@=?",key];
            }else {
                whereStr = [NSString stringWithFormat:@"%@ and %@=?",whereStr,key];
            }
        }
    }
    NSMutableArray *fieldValues = [[[NSMutableArray alloc]initWithArray:[searhPara allValues]] autorelease];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",TABLE_NAME,whereStr];
    FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:fieldValues];
    
    NSMutableArray *respArr = [[[NSMutableArray alloc]init] autorelease];
	while ([rs next]) {
        FileInfo *fileInfo = [[FileInfo alloc]init];
        [self setFileInfoPara:rs FileInfo:fileInfo];
		[respArr addObject:fileInfo];
		[fileInfo release];
	}
	
	[rs close];
    return respArr;
}

-(void)setFileInfoPara:(FMResultSet *)rs FileInfo:(FileInfo *)fileInfo{
    fileInfo.index = [NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]];
    fileInfo.fileID = [rs stringForColumn:@"fileID"];
    fileInfo.fileName = [rs stringForColumn:@"fileName"];
    fileInfo.fileSize = [rs stringForColumn:@"fileSize"];
    fileInfo.fileType=[rs stringForColumn:@"fileType"];
    fileInfo.status=[rs stringForColumn:@"status"];
    fileInfo.downloadUrl=[rs stringForColumn:@"downloadUrl"];
    fileInfo.uploadType=[rs stringForColumn:@"uploadType"];
    fileInfo.uploadStatus=[rs stringForColumn:@"uploadStatus"];
    fileInfo.createTime=[rs stringForColumn:@"createTime"];
    fileInfo.localPath=[rs stringForColumn:@"localPath"];
    fileInfo.date=[rs stringForColumn:@"date"];
    fileInfo.localDate = [rs stringForColumn:@"localDate"];
    fileInfo.localModifyTime = [rs stringForColumn:@"localModifyTime"];
    fileInfo.uploadFlag = [rs stringForColumn:@"uploadFlag"];
    fileInfo.downloadFlag = [rs stringForColumn:@"downloadFlag"];
    fileInfo.percent = [rs intForColumn:@"percent"];
    fileInfo.mediaPath = [rs stringForColumn:@"mediaPath"];
    fileInfo.groupId = [rs stringForColumn:@"groupId"];
    fileInfo.todoId = [rs stringForColumn:@"todoId"];
}
//assets-library://asset/asset.JPG?id=20B6AA3C-5688-4615-AA1B-E00231C799B2&ext=JPG
-(NSString *)getMediaId:(NSString *)mediaPath{
    NSRange nsr1= [mediaPath rangeOfString:@"?id="];
    NSRange nsr2 = [mediaPath rangeOfString:@"&ext"];
    return [mediaPath substringWithRange:NSMakeRange(nsr1.location+nsr1.length, nsr2.location)];
}
@end
