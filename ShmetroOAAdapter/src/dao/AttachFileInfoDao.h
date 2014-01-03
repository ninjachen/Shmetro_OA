//
//  AttachFileInfoDao.h
//  ShmetroOA
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AttachFileInfo.h"

@interface AttachFileInfoDao : BaseDao
//-(void)insert:(AttachFileInfo *)fileInfo;
//-(void)update:(AttachFileInfo *)fileInfo;
//-(BOOL)delete:(NSString *)fileGroupId FileId:(NSString *)fileId;
//-(BOOL)deleteGroupFile:(NSString *)fileGroupId;
//-(NSMutableArray *)searchAttachFileInfoList:(NSString *)fileGroupId;
//-(BOOL)deleteAll;
-(void)startReflashAttachFileInfo:(NSString *)fileGroupId;
-(void)endReflashAttachFileInfo:(NSString *)fileGroupId;

-(void)insertTodo:(AttachFileInfo *)fileInfo;
-(void)updateTodo:(AttachFileInfo *)fileInfo;
-(BOOL)deleteTodo:(NSString *)fileGroupId FileId:(NSString *)fileId;
-(BOOL)deleteTodoGroupFile:(NSString *)fileGroupId;
-(NSMutableArray *)searchTodoAttachFileInfoList:(NSString *)fileGroupId;
-(BOOL)deleteTodoAll;

-(void)insertWorkflow:(AttachFileInfo *)fileInfo;
-(void)updateWorkflow:(AttachFileInfo *)fileInfo;
-(BOOL)deleteWorkflow:(NSString *)fileGroupId FileId:(NSString *)fileId;
-(BOOL)deleteWorkflowGroupFile:(NSString *)pid;
-(NSMutableArray *)searchWorkflowAttachFileInfoList:(NSString *)pif;
-(BOOL)deleteWorkflowAll;
-(void)saveWorkflowInfoFromJsonValue:(id)jsonObj WithPid:(NSString *)pid;

-(void)insertDocument:(AttachFileInfo *)fileInfo;
-(void)updateDocument:(AttachFileInfo *)fileInfo;
-(BOOL)deleteDocumentGroupFile:(NSString *)pid;
-(NSMutableArray *)searchDocumentList:(NSString *)pif;
-(BOOL)deleteDocumentAll;
-(void)saveDocumentFromJsonValue:(id)jsonObj WithPid:(NSString *)pid;
@end
