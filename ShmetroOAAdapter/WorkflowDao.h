//
//  WorkflowDao.h
//  ShmetroOA
//
//  Created by gisteam on 8/22/13.
//
//

#import "BaseDao.h"
#import "WorkflowInfo.h"

@interface WorkflowDao : BaseDao

-(BOOL)insert:(WorkflowInfo *)workflowInfo;
-(BOOL)update:(WorkflowInfo *)workflowInfo;
-(BOOL)deleteAll;

-(NSArray *)queryWorkflowList;
-(WorkflowInfo *)getWorkflowByPid:(NSString *)pid;

-(void)saveWorkflowlistFromJsonValue:(id)jsonObj;
-(void)saveWorkflowDetailFromJsonValue:(id)jsonObj;
@end
