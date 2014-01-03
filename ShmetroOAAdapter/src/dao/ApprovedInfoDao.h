//
//  ApprovedInfoDao.h
//  ShmetroOA
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "ApprovedInfo.h"
@interface ApprovedInfoDao : BaseDao

-(void)insert:(ApprovedInfo *)approvedInfo;
-(void)update:(ApprovedInfo *)approvedInfo;
-(BOOL)delete:(NSString *)todoId GUID:(NSString *)guid;
-(NSMutableArray *)searchApprovedInfoList:(NSString *)todoId Type:(NSString *)type;
-(BOOL)deleteAll;
-(void)startReflashApprovedInfo:(NSString *)todoId;
-(void)endReflashApprovedInfo:(NSString *)todoId;

@end
