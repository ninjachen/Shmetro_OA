//
//  Database.m
//  SQLiteSample
//
//  Created by wang xuefeng on 10-12-29.
//  Copyright 2010 www.5yi.com. All rights reserved.
//

#import "DB.h"

#define DB_NAME @"sto.sqlite"
#define DB_VERSION @"3"

@implementation DB


- (BOOL)initDatabase
{
	BOOL success;
	NSError *error;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
	
	success = [fm fileExistsAtPath:writableDBPath];
	
	if(!success){
		NSString *defaultDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:DB_NAME];
		NSLog(@"%@",defaultDBPath);
		success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if(!success){
			NSLog(@"error: %@", [error localizedDescription]);
		}
        [self resetDbVersion];
		success = YES;
	}
	
	if(success){
        NSString *currentDbVersion = [self getDbVersion];
        if (currentDbVersion==nil||![currentDbVersion isEqualToString:DB_VERSION]) {
            [fm removeItemAtPath:writableDBPath error:&error];
            NSString *defaultDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:DB_NAME];
            NSLog(@"%@",defaultDBPath);
            success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
            if(!success){
                NSLog(@"error: %@", [error localizedDescription]);
            }
            [self resetDbVersion];
            success = YES;
        }
		//db = [[FMDatabase databaseWithPath:writableDBPath] retain];
        db = [FMDatabase databaseWithPath:writableDBPath];
		if ([db open]) {
			[db setShouldCacheStatements:YES];
		}else{
			NSLog(@"Failed to open database.");
			success = NO;
		}
	}
	
	return success;
}

-(void)resetDbVersion{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *settingInfoPath=[path stringByAppendingPathComponent:@"db.plist"];
	
	NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:settingInfoPath];
    if (array==nil) {
        array = [[NSMutableArray alloc]init];
    }else{
        [array removeObjectAtIndex:0];
    }
    [array insertObject:DB_VERSION atIndex:0];
    [array writeToFile:settingInfoPath atomically:YES];
    [array release];
}

-(NSString *)getDbVersion{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *settingInfoPath=[path stringByAppendingPathComponent:@"db.plist"];
	
	NSMutableArray *array = [[[NSMutableArray alloc]initWithContentsOfFile:settingInfoPath] autorelease];
    if (array!=nil) {
        return [array objectAtIndex:0];
    }else{
        return nil;
    }
}


- (void)closeDatabase
{
	[db close];
}


- (FMDatabase *)getDatabase
{
	if ([self initDatabase]){
		return db;
	}
	
	return NULL;
}

- (void)dealloc
{
	[self closeDatabase];
	
	//[db release];
	[super dealloc];
}

@end
