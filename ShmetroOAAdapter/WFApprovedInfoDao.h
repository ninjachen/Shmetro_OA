//
//  WFApprovedInfoDao.h
//  ShmetroOA
//
//  Created by gisteam on 8/26/13.
//
//

#import "BaseDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "WFApprovedInfo.h"

@interface WFApprovedInfoDao : BaseDao

-(void)insert:(WFApprovedInfo *)approvedInfo;
-(void)update:(WFApprovedInfo *)approvedInfo;
-(BOOL)delete:(NSString *)incidentno;
-(NSDictionary *)searchWFApprovedInfoList:(NSString *)incidentno;
-(NSMutableArray *)searchApprovedInfoList:(NSString *)incidentno;
-(BOOL)deleteAll;
-(void)startReflashApprovedInfo:(NSString *)todoId;
-(void)endReflashApprovedInfo:(NSString *)todoId;

-(void)saveWFApprovedInfoListFromJsonValue:(id)jsonObj;
@end
