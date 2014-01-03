//
//  WorkflowDao.m
//  ShmetroOA
//
//  Created by gisteam on 8/22/13.
//
//

#import "WorkflowDao.h"
#import "DB.h"
#import "SystemContext.h"
#include "JSON.h"
#import "NSString+SBJSON.h"
#import "WorkflowInfo.h"
#import "AttachFileInfoDao.h"
#import "AttachFileInfo.h"
#define TABLE_NAME @"workflowinfo"

@interface WorkflowDao(PrivateMethods)
-(BOOL)containsKey:(NSString *)pid;
-(void)setWorkflowProp:(FMResultSet *)rs WorkflowInfo:(WorkflowInfo *)workflowInfo;
@end

@implementation WorkflowDao

-(BOOL)insert:(WorkflowInfo *)workflowInfo{
    if (![self containsKey:workflowInfo.pid]) {
        if (![db open]) {
            NSLog(@"Could not open db: insertMeetingInfo");
            return NO;
        }
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (id,app,docTitle,pid,occurTime,typeName,pname,cname,stepname) VALUES (?,?,?,?,?,?,?,?,?) " inTable:TABLE_NAME],workflowInfo.id,workflowInfo.app,workflowInfo.docTitle,workflowInfo.pid,workflowInfo.occurTime,workflowInfo.typeName,workflowInfo.pname,workflowInfo.cname,workflowInfo.stepname];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            [db close];
            return NO;
        }
        [db close];
    }else
    {
        [self update:workflowInfo];
    }
    return YES;

}
-(BOOL)update:(WorkflowInfo *)workflowInfo{
    if (![db open]) {
        NSLog(@"Could not open db: update");
        return NO;
    }
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc]init];
    if (workflowInfo.sendId && ![workflowInfo.sendId isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendId forKey:@"sendId"];
    }
    if (workflowInfo.typeTitle && ![workflowInfo.typeTitle isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.typeTitle forKey:@"typeTitle"];
    }
    if (workflowInfo.app && ![workflowInfo.app isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.app forKey:@"app"];
    }
    if (workflowInfo.occurTime && ![workflowInfo.occurTime isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.occurTime forKey:@"occurTime"];
    }
    if (workflowInfo.typeName && ![workflowInfo.typeName isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.typeName forKey:@"typeName"];
    }
    if (workflowInfo.pname && ![workflowInfo.pname isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.pname forKey:@"pname"];
    }
    if (workflowInfo.cname && ![workflowInfo.cname isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.cname forKey:@"cname"];
    }
    if (workflowInfo.stepname && ![workflowInfo.stepname isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.stepname forKey:@"stepname"];
    }
    if (workflowInfo.docClass && ![workflowInfo.docClass isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.docClass forKey:@"docClass"];
    }
    if (workflowInfo.secretClass && ![workflowInfo.secretClass isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.secretClass forKey:@"secretClass"];
    }
    if (workflowInfo.hj && ![workflowInfo.hj isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.hj forKey:@"hj"];
    }
    if (workflowInfo.fileType && ![workflowInfo.fileType isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.fileType forKey:@"fileType"];
    }
    if (workflowInfo.secretLimit && ![workflowInfo.secretLimit isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.secretLimit forKey:@"secretLimit"];
    }
    if (workflowInfo.docTitle && ![workflowInfo.docTitle isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.docTitle forKey:@"docTitle"];
    }
    if (workflowInfo.sendMain && ![workflowInfo.sendMain isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendMain forKey:@"sendMain"];
    }
    if (workflowInfo.sendMainId && ![workflowInfo.sendMainId isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendMainId forKey:@"sendMainId"];
    }
    if (workflowInfo.sendCopy && ![workflowInfo.sendCopy isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendCopy forKey:@"sendCopy"];
    }
    if (workflowInfo.sendInside && ![workflowInfo.sendInside isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendInside forKey:@"sendInside"];
    }
    if (workflowInfo.sendType && ![workflowInfo.sendType isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendType forKey:@"sendType"];
    }
    if (workflowInfo.contentAttMain && ![workflowInfo.contentAttMain isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.contentAttMain forKey:@"contentAttMain"];
    }
    if (workflowInfo.sendTitleType && ![workflowInfo.sendTitleType isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendTitleType forKey:@"sendTitleType"];
    }
    if (workflowInfo.sendUser && ![workflowInfo.sendUser isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendUser forKey:@"sendUser"];
    }
    if (workflowInfo.sendUserLeader && ![workflowInfo.sendUserLeader isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendUserLeader forKey:@"sendUserLeader"];
    }
    if (workflowInfo.sendUserdept && ![workflowInfo.sendUserdept isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendUserdept forKey:@"sendUserdept"];
    }
    if (workflowInfo.operator && ![workflowInfo.operator isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.operator forKey:@"operator"];
    }
    if (workflowInfo.sendDate && ![workflowInfo.sendDate isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendDate forKey:@"sendDate"];
    }
    if (workflowInfo.docCount && ![workflowInfo.docCount isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.docCount forKey:@"docCount"];
    }
    if (workflowInfo.operateTime && ![workflowInfo.operateTime isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.operateTime forKey:@"operateTime"];
    }
    if (workflowInfo.sendInsideId && ![workflowInfo.typeTitle isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.sendInsideId forKey:@"sendInsideId"];
    }
    if (workflowInfo.typeTitle && ![workflowInfo.typeTitle isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.typeTitle forKey:@"typeTitle"];
    }
    if (workflowInfo.typeTitle && ![workflowInfo.typeTitle isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.typeTitle forKey:@"typeTitle"];
    }
    if (workflowInfo.processText && ![workflowInfo.typeTitle isEqualToString:@""]) {
        [updateDictionary setValue:workflowInfo.processText forKey:@"processText"];
    }
    
    NSString *fieldString = @"";
    NSString *key;
    for (int i=0; i<updateDictionary.allKeys.count; i++) {
        key = [updateDictionary.allKeys objectAtIndex:i];
        if (i==0) {
            fieldString = [NSString stringWithFormat:@"%@=?",key];
        }else{
            fieldString =  [NSString stringWithFormat:@"%@,%@=?",fieldString,key];
        }
    }
    
    NSMutableArray *fieldValues=[[NSMutableArray alloc]initWithArray:[updateDictionary allValues]];
    [fieldValues addObject:workflowInfo.pid];
    [updateDictionary release];
    NSString *updateSql=[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE pid=?",TABLE_NAME,fieldString];
    
    [db executeUpdate:updateSql withArgumentsInArray:fieldValues];
    [fieldValues release];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return NO;
    }
    
    [db close];
    return YES;
}
-(BOOL)deleteAll{
    if (![db open]) {
        NSLog(@"Could not open db: deleteAllM");
        return NO;
    }
    [db executeUpdate:[self SQL:@"DELETE FROM  %@" inTable:TABLE_NAME]];
    if ([db hadError]) {
        NSLog(@"Err %d:%@",[db lastErrorCode],[db lastErrorMessage]);
        [db close];
        return NO;
    }
    
    [db close];
    return YES;
}

-(NSArray *)queryWorkflowList{
    if (![db open]) {
        NSLog(@"Could not open db: queryWorkflowList");
        return NO;
    }
    NSMutableArray *workflowInfoArray = [[[NSMutableArray alloc]init]autorelease];
    FMResultSet *workflowInfoResultSet = [db executeQuery:[self SQL:@"SELECT * FROM %@ " inTable:TABLE_NAME]];
    while ([workflowInfoResultSet next]) {
        WorkflowInfo *workflowInfo = [[WorkflowInfo alloc]init];
        [self setWorkflowProp:workflowInfoResultSet WorkflowInfo:workflowInfo];
        
        [workflowInfoArray addObject:workflowInfo];
        [workflowInfo release];
    }
    
    [workflowInfoResultSet close];
    return workflowInfoArray;
    [db close];
    return workflowInfoArray;
}

-(WorkflowInfo *)getWorkflowByPid:(NSString *)pid{
    WorkflowInfo *workflowInfo = nil;
    if (![db open]) {
        NSLog(@"Could not open db: getWorkflowByPid");
        return NO;
    }
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ WHERE pid=?" inTable:TABLE_NAME],pid];
    while ([rs next]) {
        workflowInfo = [[[WorkflowInfo alloc]init]autorelease];
        [self setWorkflowProp:rs WorkflowInfo:workflowInfo];
    }
    
    [rs close];
    [db close];
    return workflowInfo;
}


-(void)saveWorkflowlistFromJsonValue:(id)jsonObj{
 
                if ([[jsonObj class]isSubclassOfClass:[NSArray class]]) {
                    if (jsonObj!=nil && [jsonObj count]>0) {
                        [self deleteAll];
                        for (int i=0; i<[jsonObj count]; i++) {
                            SBJsonWriter *paramObj = [jsonObj objectAtIndex:i];
                            WorkflowInfo *workflowInfo = [[WorkflowInfo alloc]init];
                            if ([paramObj valueForKey:@"pincident"]) {
                                NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                                workflowInfo.pid = [numberFormatter stringFromNumber:[paramObj valueForKey:@"pincident"]];
                            }
                            if ([paramObj valueForKey:@"id"]) {
                                workflowInfo.id = [paramObj valueForKey:@"id"];
                            }
                            if ([paramObj valueForKey:@"app"]) {
                                workflowInfo.app = [paramObj valueForKey:@"app"];
                            }
                            if ([paramObj valueForKey:@"title"]) {
                                workflowInfo.docTitle= [paramObj valueForKey:@"title"];
                            }
                            if ([paramObj valueForKey:@"typename"]) {
                                workflowInfo.typeName = [paramObj valueForKey:@"typename"];
                            }
                            if ([paramObj valueForKey:@"pname"]) {
                                workflowInfo.pname = [paramObj valueForKey:@"pname"];
                            }
                            if ([paramObj valueForKey:@"stepname"]) {
                                workflowInfo.stepname = [paramObj valueForKey:@"stepname"];
                            }
                            if ([paramObj valueForKey:@"occurtime"]) {
                                workflowInfo.occurTime = [paramObj valueForKey:@"occurtime"];
                            }
                            
                            [self insert:workflowInfo];
                            [workflowInfo release];
                        }
                    }
                }

}
-(void)saveWorkflowDetailFromJsonValue:(id)jsonObj{
    if (jsonObj!=nil && [jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        
        if ([[SystemContext singletonInstance]processHttpResponseCode:code]) {
            if ([jsonObj valueForKey:@"result"]) {
                SBJsonParser *paramObj = [jsonObj valueForKey:@"result"];
                WorkflowInfo *workflowInfo = [[WorkflowInfo alloc]init];
                if ([paramObj valueForKey:@"pinstanceid"]) {
                    workflowInfo.pid =[paramObj valueForKey:@"pinstanceid"];
                }
                if ([paramObj valueForKey:@"id"]) {
                    workflowInfo.sendId = [paramObj valueForKey:@"id"];
                }
                if ([paramObj valueForKey:@"docClass"]) {
                    workflowInfo.docClass = [paramObj valueForKey:@"docClass"];
                }
                if ([paramObj valueForKey:@"docCount"]) {
                    workflowInfo.docCount = [paramObj valueForKey:@"docCount"];
                }
                if ([paramObj valueForKey:@"docTitle"]) {
                    workflowInfo.docTitle = [paramObj valueForKey:@"docTitle"];
                }
                if ([paramObj valueForKey:@"operator"]) {
                    workflowInfo.operator = [paramObj valueForKey:@"operator"];
                }
                if ([paramObj valueForKey:@"secretClass"]) {
                    workflowInfo.secretClass = [paramObj valueForKey:@"secretClass"];
                }
                if ([paramObj valueForKey:@"sendDate"]) {
                    workflowInfo.sendDate = [paramObj valueForKey:@"sendDate"];
                }
                if ([paramObj valueForKey:@"sendId"]) {
                    workflowInfo.sendId = [paramObj valueForKey:@"sendId"];
                }
                if ([paramObj valueForKey:@"sendInside"]) {
                    workflowInfo.sendInside = [paramObj valueForKey:@"sendInside"];
                }
                if ([paramObj valueForKey:@"sendMain"]) {
                    workflowInfo.sendMain = [paramObj valueForKey:@"sendMain"];
                }
                if ([paramObj valueForKey:@"sendUser"]) {
                    workflowInfo.sendUser = [paramObj valueForKey:@"sendUser"];
                }
                if ([paramObj valueForKey:@"sendUserdept"]) {
                    workflowInfo.sendUserdept = [paramObj valueForKey:@"sendUserdept"];
                }
                if ([paramObj valueForKey:@"operateTime"]) {
                    workflowInfo.operateTime = [paramObj valueForKey:@"operateTime"];
                }
                if ([paramObj valueForKey:@"hj"]) {
                    workflowInfo.hj = [paramObj valueForKey:@"hj"];
                }
                if ([paramObj valueForKey:@"fileType"]) {
                    workflowInfo.fileType = [paramObj valueForKey:@"fileType"];
                }
                if ([paramObj valueForKey:@"sendMainId"]) {
                    workflowInfo.sendMainId = [paramObj valueForKey:@"sendMainId"];
                }
                if ([paramObj valueForKey:@"sendInsideId"]) {
                    workflowInfo.sendInsideId = [paramObj valueForKey:@"sendInsideId"];
                }
                if ([paramObj valueForKey:@"sendUserLeader"]) {
                    workflowInfo.sendUserLeader = [paramObj valueForKey:@"sendUserLeader"];
                }
                if ([paramObj valueForKey:@"contentAttMain"]) {
                    workflowInfo.contentAttMain = [paramObj valueForKey:@"contentAttMain"];
                }
                if ([paramObj valueForKey:@"sendType"]) {
                    workflowInfo.sendType = [paramObj valueForKey:@"sendType"];
                }
                if ([paramObj valueForKey:@"typeTitle"]) {
                    workflowInfo.typeTitle = [paramObj valueForKey:@"typeTitle"];
                }
                
                if ([paramObj valueForKey:@"AttMain"]) {
                    id jsonObj = [paramObj valueForKey:@"AttMain"];
                    if ([[jsonObj class]isSubclassOfClass:[NSArray class]]) {
                        if (jsonObj != nil && [jsonObj count]>0) {
                            jsonObj = [jsonObj objectAtIndex:0];
                            AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
                            [dao deleteDocumentGroupFile:workflowInfo.pid];
                            for (int i =0; i<[jsonObj count]; i++) {
                                SBJsonWriter *fileObj = [jsonObj objectAtIndex:i];
                                 [dao saveDocumentFromJsonValue:fileObj WithPid:workflowInfo.pid];
                            }
                            [dao release];
                        }
                    }
                }
                
                [self insert:workflowInfo];
                [workflowInfo release];
            }
        }
    }
}


-(BOOL)containsKey:(NSString *)pid{
    if (pid==nil) {
        return NO;
    }
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@	WHERE pid=?" inTable:TABLE_NAME],pid];
    while ([rs next]) {
        [rs close];
        return YES;
    }
    [rs close];
    return NO;
}

-(void)setWorkflowProp:(FMResultSet *)rs WorkflowInfo:(WorkflowInfo *)workflowInfo{
    workflowInfo.pid = [rs stringForColumn:@"pid"];
    workflowInfo.id = [rs stringForColumn:@"id"];
    workflowInfo.sendId = [rs stringForColumn:@"sendId"];
    workflowInfo.app = [rs stringForColumn:@"app"];
    workflowInfo.occurTime = [rs stringForColumn:@"occurTime"];
    workflowInfo.typeName = [rs stringForColumn:@"typeName"];
    workflowInfo.pname = [rs stringForColumn:@"pname"];
    workflowInfo.cname = [rs stringForColumn:@"cname"];
    workflowInfo.stepname = [rs stringForColumn:@"stepname"];
    workflowInfo.docClass = [rs stringForColumn:@"docClass"];
    workflowInfo.secretClass = [rs stringForColumn:@"secretClass"];
    workflowInfo.hj = [rs stringForColumn:@"hj"];
    workflowInfo.fileType = [rs stringForColumn:@"fileType"];
    workflowInfo.secretLimit = [rs stringForColumn:@"secretLimit"];
    workflowInfo.docTitle = [rs stringForColumn:@"docTitle"];
    workflowInfo.sendMain = [rs stringForColumn:@"sendMain"];
    workflowInfo.sendMainId = [rs stringForColumn:@"sendMainId"];
    workflowInfo.sendCopy = [rs stringForColumn:@"sendCopy"];
    workflowInfo.sendInside = [rs stringForColumn:@"sendInside"];
    workflowInfo.sendInsideId = [rs stringForColumn:@"sendInsideId"];
    workflowInfo.sendType = [rs stringForColumn:@"sendType"];
    workflowInfo.contentAttMain = [rs stringForColumn:@"contentAttMain"];
    workflowInfo.typeTitle = [rs stringForColumn:@"typeTitle"];
    workflowInfo.sendTitleType = [rs stringForColumn:@"sendTitleType"];
    workflowInfo.sendUser = [rs stringForColumn:@"sendUser"];
    workflowInfo.sendUserLeader = [rs stringForColumn:@"sendUserLeader"];
    workflowInfo.sendUserdept = [rs stringForColumn:@"sendUserdept"];
    workflowInfo.operator = [rs stringForColumn:@"operator"];
    workflowInfo.sendDate = [rs stringForColumn:@"sendDate"];
    workflowInfo.docCount = [rs stringForColumn:@"docCount"];
    workflowInfo.operateTime = [rs stringForColumn:@"operateTime"];
    workflowInfo.processText = [rs stringForColumn:@"processText"];
}

@end
