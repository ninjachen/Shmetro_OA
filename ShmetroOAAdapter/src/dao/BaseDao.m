//
//  BaseDao.m
//  SQLiteSample
//
//  Created by wang xuefeng on 10-12-29.
//  Copyright 2010 www.5yi.com. All rights reserved.
//

#import "DB.h"
#import "BaseDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"


@implementation BaseDao

@synthesize db;

- (id)init{
	if(self = [super init])
	{
//        DB *fmdb = [[DB alloc]init];
//        self.db = [fmdb getDatabase];
//        [fmdb release];

     //  db = [[[DB alloc]getDatabase]retain];
		self.db = [[DB alloc] getDatabase];
	}
	
	return self;
}

-(NSString *)SQL:(NSString *)sql inTable:(NSString *)table {
	return [NSString stringWithFormat:sql, table];
}
-(NSString *)SQLWITHLIMIT:(NSString *)sql inTable:(NSString *)table Limit:(int)limit Offset:(int)offset{
	return [NSString stringWithFormat:sql, table,limit,offset];
}
- (void)dealloc {
    [db release];
	[super dealloc];
}

@end