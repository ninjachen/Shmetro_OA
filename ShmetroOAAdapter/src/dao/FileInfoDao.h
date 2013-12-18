//
//  FileInfoDao.h
//  EYun
//
//  Created by caven on 11-9-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FileInfo.h"
@interface FileInfoDao : BaseDao {
     
}
-(void)insert:(FileInfo *)fileInfo;

-(void)update:(FileInfo *)fileInfo;
-(BOOL)delete:(NSString *)index;
-(BOOL)deleteByFileID:(NSString *)fileID;
-(NSArray *)searchFileInfoArr;
-(FileInfo *)getFileInfo:(NSString *)fileId;
-(FileInfo *)getFileInfoByIndex:(NSString *)fileIndex;

-(void)insertUploadFile:(FileInfo *)fileInfo;
-(void)insertDownloadFile:(FileInfo *)fileInfo;

-(NSMutableArray *)searchUploadArr;
-(BOOL)deleteAllUploadArr;

-(NSMutableArray *)searchDownloadArr;
-(BOOL)deleteAllDownloadArr;
-(void)cancelDownload:(NSString *)fileID;
-(BOOL)checkUploaed:(NSString *)filePath;
@end
