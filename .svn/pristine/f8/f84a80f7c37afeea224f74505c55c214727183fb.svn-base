//
//  MessageDao.h
//  ShmetroOA
//
//  Created by gisteam on 6/14/13.
//
//

#import "BaseDao.h"
#import "MessageDetailInfo.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface MessageDao : BaseDao

-(BOOL)insert:(MessageDetailInfo*)messageInfo;
-(BOOL)update:(MessageDetailInfo*)messageInfo;
-(BOOL)deleteAllMessages;
-(BOOL)delete:(NSString *)mid;
-(MessageDetailInfo*)getMessageDetailById:(NSString *)mid App:(NSString *)appName;
-(NSMutableArray *)queryAllMessagelList;

-(void)saveMessagelistFromJsonValue:(id)jsonObj;
-(void)saveMessageDetailFromJsonValue:(id)jsonObj;

@end
