//
//  TodoInfoDao.h
//  ShmetroOA
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "TodoInfo.h"
@interface TodoInfoDao : BaseDao
-(void)insert:(TodoInfo *)todoInfo;
-(void)update:(TodoInfo *)todoInfo;
-(BOOL)delete:(NSString *)todoId;
-(NSMutableArray *)searchAllTodoInfoList;
-(TodoInfo *)getTodoInfo:(NSString *)todoId;
-(BOOL)deleteAll;
-(void)startReflashTodoInfo;
-(void)endReflashTodoInfo;


-(NSMutableArray *)searchTodoInfoListByTypename:(NSString*)typeName;
-(void)insertTodoInfo:(TodoInfo *)todoInfo;
-(void)saveJsonItemToTodoList:(id)jsonObj;
@end
