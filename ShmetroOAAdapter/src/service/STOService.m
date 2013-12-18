//
//  STOService.m
//  ShmetroOA
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "STOService.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "StringUtil.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "UIDevice-Extensions.h"
#include <netinet/in.h>
#import "ApiConfig.h"
#import "StringUtil.h"
#include "JSON.h"
#import "NSString+SBJSON.h"
#import "SystemContext.h"
#import "UserAccountContext.h"
#import "TodoInfoDao.h"
#import "ApprovedInfo.h"
#import "AttachFileInfoDao.h"
#import "TodoInfo.h"
#import "AppDelegate.h"
#import "ContactInfoDao.h"
#import "MessageDao.h"
#import "MeetingDao.h"
#import "UserInfoDao.h"
#import "WorkflowDao.h"
#import "WFApprovedInfoDao.h"
static NSString *APPROVE_TYPE_APPLY=@"APPLY";
static NSString *APPROVE_TYPE_SUB=@"SUB";
static NSString *APPROVE_TYPE_BACK=@"BACK";
@interface STOService (PrivateMethods)
-(void)convertJsonItemToTodoList:(SBJsonParser *)jsonObj;
-(void)reflashTodoInfoDetail:(NSString *)todoId TodoId:(NSString *)todoId;
-(void)convertJsonItemToTodoDetail:(SBJsonParser *)jsonObj;
-(ApprovedInfo *)convertJsonItemToApprovedInfo:(SBJsonParser *)jsonObj;
-(void)reflashAttachFile:(NSString *)fileGroupId;
-(void)convertJsonItemToAttachFileInfo:(SBJsonParser *)jsonObj GroupId:(NSString *)groupId;
-(NSDictionary *)convertProcessJson:(SBJsonParser *)jsonObj TodoId:(NSString *)todoId;
-(NSDictionary *)convertCheckVersionJson:(SBJsonParser *)jsonObj;
-(NSString *)convertJsonItemToAttachFileDetailInfo:(SBJsonParser *)jsonObj;
-(UserInfo*)refreshUserInfo;
@end

@implementation STOService
-(void)reflashTodoList{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDataExchangeAPIUrl]];
    [ApiConfig setHttpPostData:request Method:[ApiConfig getTodoListMethod] DataParams:nil Key:[[[UserAccountContext singletonInstance] userAccountInfo] token]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [self convertJsonItemToTodoList:jsonObj];
    }
}

-(void)refreshTodoListWithType:(NSString *)type{
    //TodoInfoDao *todoInfoDao = [[TodoInfoDao alloc]init];
    NSString *loginName = [[[UserAccountContext singletonInstance]userAccountInfo]loginName];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getTodoListAPIURLWithType:type ByLoginName:loginName]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        if ([type isEqualToString:@"多级工作联系单"]) {
            TodoInfoDao *todoInfoDao = [[TodoInfoDao alloc]init];
              [todoInfoDao saveJsonItemToTodoList:jsonObj];
              [todoInfoDao release];
        }else if([type isEqualToString:@"新发文流程"]){
            WorkflowDao *workflowDao = [[WorkflowDao alloc]init];
            [workflowDao saveWorkflowlistFromJsonValue:jsonObj];
            [workflowDao release];
        }
    }
}

#pragma mark - DocSend
-(void)updateDocSendSingleData:(NSString *)pid{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getUpdateSingleDataAPIURLWithType:@"docSend" Pid:pid]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
}

-(WorkflowInfo *)getWorkflowInfoDetail:(NSString *)pid{
    [self updateDocSendSingleData:pid];
    
    WorkflowDao *workflowDao = [[WorkflowDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getProcessdataAPIURLWithType:@"docSend" Pid:pid DataType:@"1"]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [workflowDao saveWorkflowDetailFromJsonValue:jsonObj];
    }
    WorkflowInfo *workflowInfo = [workflowDao getWorkflowByPid:pid];
    [workflowDao release];
    
    return workflowInfo;
}

-(NSArray *)searchDocSendAttachFileList:(NSString *)pid{
    AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getProcessdataAPIURLWithType:@"docSend" Pid:pid DataType:@"2"]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
    
        [dao saveWorkflowInfoFromJsonValue:jsonObj WithPid:pid];
    }
    
    NSMutableArray *attachFileList = [dao searchWorkflowAttachFileInfoList:pid];
    [dao release];
    
    return attachFileList;
}
-(NSDictionary *)searchDocSendApproveInfoList:(NSString *)pid{
     WFApprovedInfoDao *dao = [[WFApprovedInfoDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getProcessdataAPIURLWithType:@"docSend" Pid:pid DataType:@"3"]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [dao saveWFApprovedInfoListFromJsonValue:jsonObj];
    }
    
    NSDictionary *wfApprovedInfoList = [dao searchWFApprovedInfoList:pid];
    [dao release];
    
    return wfApprovedInfoList;
}

-(BOOL)docSendLeaderDealWithPid:(NSString *)pid Choice:(NSString *)choice Suggest:(NSString *)suggest;
{
    BOOL result = NO;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDocSendLeaderDealAPIURLWithPid:pid Choice:choice Suggest:suggest LoginName: [[[UserAccountContext singletonInstance]userAccountInfo]loginName]]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        if (jsonObj != nil && [jsonObj valueForKey:@"code"]) {
            result = [[SystemContext singletonInstance]processHttpResponseCode:[jsonObj valueForKey:@"code"]];
        }
    }
   
    return result;
}

-(NSArray *)searchAllTodoList{
    NSArray *resp = nil;
    TodoInfoDao *dao = [[TodoInfoDao alloc] init];
    resp = [dao searchAllTodoInfoList];
    [dao release];
    return resp;
}

-(TodoInfo *)getTodoInfoDetail:(NSString *)todoId{
    [self reflashTodoInfoDetail:todoId];
    TodoInfo *todoInfo = nil;
    TodoInfoDao *dao = [[TodoInfoDao alloc] init];
    todoInfo = [dao getTodoInfo:todoId];
    [dao release];
    return todoInfo;
}

-(NSArray *)searchAttachFileList:(NSString *)fileGroupId{
    [self reflashAttachFile:fileGroupId];
    AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
    NSArray *resp = nil;
    resp = [dao searchTodoAttachFileInfoList:fileGroupId];
//    resp = [dao searchAttachFileInfoList:fileGroupId];
    [dao release];
    return resp;
}

-(AttachFileInfo *)getAttachFileDietail:(AttachFileInfo *)attachFileInfo{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDataExchangeAPIUrl]];
    NSString *dataPara = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><params><attachId>%@</attachId></params>",attachFileInfo.fileId];
    [ApiConfig setHttpPostData:request Method:[ApiConfig getAttachFileDetailMethod] DataParams:dataPara Key:[[[UserAccountContext singletonInstance] userAccountInfo] token]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
         NSString *attachFilePath = [self convertJsonItemToAttachFileDetailInfo:jsonObj];
        if (attachFilePath!=nil) {
            attachFilePath = [NSString stringWithFormat:@"%@&%@.%@",attachFilePath,attachFileInfo.fileName,attachFileInfo.fileExtName];
            NSLog(@"%@",attachFilePath);
            if (attachFileInfo.downloadUrl==nil||![attachFilePath isEqualToString:attachFileInfo.downloadUrl]){
                attachFileInfo.downloadUrl = attachFilePath;
                attachFileInfo.localPath = @"null";
                AttachFileInfoDao *attachFileInfoDao = [[AttachFileInfoDao alloc]init];
                [attachFileInfoDao updateTodo:attachFileInfo];
                [attachFileInfoDao release];
                return attachFileInfo;
            }
            return attachFileInfo;
        }
    }
    return nil;
}

-(NSDictionary *)processTodo:(TodoInfo *)todoInfo{
    NSDictionary *resp = nil;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDataExchangeAPIUrl]];
    NSString *dataPara = nil;
    if (todoInfo.uploadfilegroupid!=nil) {
        dataPara = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><params><todoId>%@</todoId><data>{'choice':'2','suggest':'%@',attachId:'%@'}</data></params>",todoInfo.todoId,todoInfo.processText,todoInfo.uploadfilegroupid];
    }else{
         dataPara = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><params><todoId>%@</todoId><data>{'choice':'1','suggest':'%@'}</data></params>",todoInfo.todoId,todoInfo.processText];
    }
    
    [ApiConfig setHttpPostData:request Method:[ApiConfig getTodoSubmitMethod] DataParams:dataPara Key:[[[UserAccountContext singletonInstance] userAccountInfo] token]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        resp = [self convertProcessJson:jsonObj TodoId:todoInfo.todoId];
    }
    return resp;
}

-(NSDictionary *)checkCurrentVersion{
    NSDictionary *resp = nil;
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* versionNum = [infoDict objectForKey:@"CFBundleVersion"];
//    NSString *appName = [infoDict objectForKey:@"CFBundleDisplayName"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getVersionUpdateAPIUrl]];
    NSString *bodyString = [NSString stringWithFormat:@"deviceType=ios&currentVersion=%@",versionNum];
    NSMutableData *bodyData = [[[NSMutableData alloc]initWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    [request setPostBody:bodyData];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        resp = [self convertCheckVersionJson:jsonObj];
    }
    
    return resp;
}
#pragma mark - Private Methods Implement
/**
{
    "description": "success!",
    "params": {
        "param": {
            "occurTime": "2012-08-29 11:57:35",
            "id": "C85FA1645C8351D1E0440018FE2DB9AD",
            "app": "workflow",
            "title": "ttttttttt",
            "status": "0",
            "data": {
                "CINCIDENT": "13",
                "STEPLABEL": "部门内部签发",
                "PNAME": "多级工作联系单",
                "CREATE_DEPTNAME": "信息管理中心",
                "START_TIME": "2012-08-29 11:57:35",
                "THEME": "ttttttttt",
                "CNAME": "多级工作联系单",
                "MAIN_UNIT": "纪委监察室",
                "INITIATOR_NAME": "李名敏",
                "CONTENT": "t",
                "REPLY_DATE": "2012-08-03",
                "TASKID": "0829122791f98397d10dfdc67b3b1f",
                "ASSIGNEDTOUSER": "ST/G020001000502549",
                "CONTENT_ATTACHMENT_ID": "{C78D5B46-2628-A4B3-A6F0-A8933CDB6468}",
                "CONTACT_DATE": "2012-08-01",
                "PINCIDENT": "13"
            },
            "removed": "0",
            "type": "1",
            "key": "0829122791f98397d10dfdc67b3b1f",
            "loginName": "ST/G020001000502549"
        }
    },
    "code": "100"
}
 */
-(void)convertJsonItemToTodoList:(SBJsonParser *)jsonObj{
    if (jsonObj!=nil&&[jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        NSString *description = @"";
        if ([jsonObj valueForKey:@"description"]) {
            description = [jsonObj valueForKey:@"description"];
        }
        if ([[SystemContext singletonInstance] processHttpResponseCode:code Desc:description]) {
            id paraArr = [jsonObj valueForKey:@"params"];
            if (paraArr) {
                if ([[paraArr class] isSubclassOfClass:[NSArray class]]) {
                    if (paraArr!=nil&&[paraArr count]>0) {
                        TodoInfoDao *dao = [[TodoInfoDao alloc]init];
                        for (int i=0; i<[paraArr count]; i++) {
                            SBJsonParser *paramObj = [paraArr objectAtIndex:i];
                            TodoInfo *todoInfo = [[[TodoInfo alloc]init] autorelease];
                            if ([paramObj valueForKey:@"id"]) {
                                todoInfo.todoId = [paramObj valueForKey:@"id"];
                            }
                            if ([paramObj valueForKey:@"app"]) {
                                todoInfo.app = [paramObj valueForKey:@"app"];
                            }
                            if ([paramObj valueForKey:@"type"]) {
                                todoInfo.todoType = [paramObj valueForKey:@"type"];
                            }
                            if ([paramObj valueForKey:@"key"]) {
                                todoInfo.key = [paramObj valueForKey:@"key"];
                            }
                            if ([paramObj valueForKey:@"occurTime"]) {
                                todoInfo.occurTime = [paramObj valueForKey:@"occurTime"];
                            }
                            if ([paramObj valueForKey:@"title"]) {
                                todoInfo.title = [paramObj valueForKey:@"title"];
                            }
                            if ([paramObj valueForKey:@"data"]) {
                                SBJsonParser *dataPara = [paramObj valueForKey:@"data"];
                                todoInfo.steplabel = [dataPara valueForKey:@"STEPLABEL"];
                                todoInfo.data = [dataPara description];
                            }
                            if ([paramObj valueForKey:@"userId"]) {
                                todoInfo.userId = [paramObj valueForKey:@"userId"];
                            }
                            if ([paramObj valueForKey:@"loginName"]) {
                                todoInfo.loginName=[[[UserAccountContext singletonInstance]userAccountInfo]loginName];
                               // todoInfo.loginName = [paramObj valueForKey:@"loginName"];
                            }
                            if ([paramObj valueForKey:@"status"]) {
                                todoInfo.status = [paramObj valueForKey:@"status"];
                            }
                            if ([paramObj valueForKey:@"removed"]) {
                                todoInfo.removed = [paramObj valueForKey:@"removed"];
                            }
                            [dao insert:todoInfo];
                        }
                        [dao release];
                    }
                }else{
                    TodoInfoDao *dao = [[TodoInfoDao alloc]init];
                    SBJsonParser *paramObj;
                    if ([paraArr objectForKey:@"param"]) {
                        paramObj = [paraArr objectForKey:@"param"];
                    }else{
                        paramObj = paraArr;
                    }
                    TodoInfo *todoInfo = [[[TodoInfo alloc]init] autorelease];
                    if ([paramObj valueForKey:@"id"]) {
                        todoInfo.todoId = [paramObj valueForKey:@"id"];
                    }
                    if ([paramObj valueForKey:@"app"]) {
                        todoInfo.app = [paramObj valueForKey:@"app"];
                    }
                    if ([paramObj valueForKey:@"type"]) {
                        todoInfo.todoType = [paramObj valueForKey:@"type"];
                    }
                    if ([paramObj valueForKey:@"key"]) {
                        todoInfo.key = [paramObj valueForKey:@"key"];
                    }
                    if ([paramObj valueForKey:@"occurTime"]) {
                        todoInfo.occurTime = [paramObj valueForKey:@"occurTime"];
                    }
                    if ([paramObj valueForKey:@"title"]) {
                        todoInfo.title = [paramObj valueForKey:@"title"];
                    }
                    if ([paramObj valueForKey:@"data"]) {
                        todoInfo.data = [[paramObj valueForKey:@"data"] description];
                    }
                    if ([paramObj valueForKey:@"userId"]) {
                        todoInfo.userId = [paramObj valueForKey:@"userId"];
                    }
                    if ([paramObj valueForKey:@"loginname"]) {
                        todoInfo.loginName = [paramObj valueForKey:@"loginname"];
                    }
                    if ([paramObj valueForKey:@"status"]) {
                        todoInfo.status = [paramObj valueForKey:@"status"];
                    }
                    if ([paramObj valueForKey:@"removed"]) {
                        todoInfo.removed = [paramObj valueForKey:@"removed"];
                    }
                    [dao insert:todoInfo];
                    [dao release];
                }
            }
            
        }
    }
}

-(void)reflashTodoInfoDetail:(NSString *)todoId{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDataExchangeAPIUrl]];
    NSString *dataPara = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><params><todoId>%@</todoId></params>",todoId];
    [ApiConfig setHttpPostData:request Method:[ApiConfig getTodoDetailMethod] DataParams:dataPara Key:[[[UserAccountContext singletonInstance] userAccountInfo] token]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
      //  DLog(@"%@",respStr);
        [self convertJsonItemToTodoDetail:jsonObj TodoId:todoId];
    }else{
       
    }
}

-(void)convertJsonItemToTodoDetail:(SBJsonParser *)jsonObj TodoId:(NSString *)todoId{
    if (jsonObj!=nil&&[jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        NSString *description = @"";
        if ([jsonObj valueForKey:@"description"]) {
            description = [jsonObj valueForKey:@"description"];
        }
        if ([[SystemContext singletonInstance] processHttpResponseCode:code Desc:description]) {
            if ([jsonObj valueForKey:@"params"]) {
                SBJsonParser *paramsObj = [jsonObj valueForKey:@"params"];
                SBJsonParser *paramObj = [paramsObj valueForKey:@"param"];
                TodoInfo *todoInfo = [[[TodoInfo alloc]init] autorelease];
                TodoInfoDao *dao = [[TodoInfoDao alloc]init];
                if ([paramObj valueForKey:@"type"]) {
                    todoInfo.todoType = [paramObj valueForKey:@"type"];
                }
                SBJsonParser *mainObj = [paramObj valueForKey:@"main"];
                todoInfo.todoId = todoId;
                if ([mainObj valueForKey:@"id"]) {
                    todoInfo.instanceId = [mainObj valueForKey:@"id"];
                }
                if ([mainObj valueForKey:@"mainUnitId"]) {
                    todoInfo.mainUnitId = [mainObj valueForKey:@"mainUnitId"];
                }
                
                if ([mainObj valueForKey:@"mainUnit"]) {
                    todoInfo.mainUnit = [mainObj valueForKey:@"mainUnit"];
                }
                if ([mainObj valueForKey:@"contactDate"]) {
                    todoInfo.contactDate = [mainObj valueForKey:@"contactDate"];
                }
                if ([mainObj valueForKey:@"replyDate"]) {
                    todoInfo.replyDate = [mainObj valueForKey:@"replyDate"];
                }
                if ([mainObj valueForKey:@"timeDiff"]) {
                    todoInfo.timeDiff = [mainObj valueForKey:@"timeDiff"];
                }
                if ([mainObj valueForKey:@"theme"]) {
                    todoInfo.theme = [mainObj valueForKey:@"theme"];
                }
                if ([mainObj valueForKey:@"content"]) {
                    todoInfo.content = [mainObj valueForKey:@"content"];
                }
                if ([mainObj valueForKey:@"contentAttachmentId"]) {
                    todoInfo.contentAttachmentId = [mainObj valueForKey:@"contentAttachmentId"];
                }
                if ([mainObj valueForKey:@"processname"]) {
                    todoInfo.processname = [mainObj valueForKey:@"processname"];
                }
                if ([mainObj valueForKey:@"incidentno"]) {
                    todoInfo.incidentno = [mainObj valueForKey:@"incidentno"];
                }
                if ([mainObj valueForKey:@"serial"]) {
                    todoInfo.serial = [mainObj valueForKey:@"serial"];
                }
                if ([mainObj valueForKey:@"createDeptid"]) {
                    todoInfo.createDeptid = [mainObj valueForKey:@"createDeptid"];
                }
                if ([mainObj valueForKey:@"createDeptname"]) {
                    todoInfo.createDeptName = [mainObj valueForKey:@"createDeptname"];
                }
                if ([mainObj valueForKey:@"initiator"]) {
                    todoInfo.initiator = [mainObj valueForKey:@"initiator"];
                }
                if ([mainObj valueForKey:@"initiatorName"]) {
                    todoInfo.initiatorName = [mainObj valueForKey:@"initiatorName"];
                }
                if ([mainObj valueForKey:@"startTime"]) {
                    todoInfo.startTime = [mainObj valueForKey:@"startTime"];
                }
                if ([mainObj valueForKey:@"updateTime"]) {
                    todoInfo.updateTime = [mainObj valueForKey:@"updateTime"];
                }
                if ([mainObj valueForKey:@"operateUser"]) {
                    todoInfo.operateUser = [mainObj valueForKey:@"operateUser"];
                }
                if ([mainObj valueForKey:@"operateName"]) {
                    todoInfo.operateName = [mainObj valueForKey:@"operateName"];
                }
                if ([mainObj valueForKey:@"operateDate"]) {
                    todoInfo.operateDate = [mainObj valueForKey:@"operateDate"];
                }
                if ([mainObj valueForKey:@"removed"]) {
                    todoInfo.removed = [mainObj valueForKey:@"removed"];
                }
                
                SBJsonParser *commentObj = [paramObj valueForKey:@"comment"];
                if (commentObj!=nil) {
                    id applyApprovedInfoObj = [commentObj valueForKey:@"applyApprovedInfo"];
                     NSMutableArray *applyInfoArr = [[[NSMutableArray alloc]init] autorelease];
                    if ([[applyApprovedInfoObj class] isSubclassOfClass:[NSArray class]]) {
                        NSArray *applyObjArr = applyApprovedInfoObj;
                        if (applyObjArr!=nil&&[applyObjArr count]>0) {
                            for (int i=0; i<[applyObjArr count]; i++) {
                                SBJsonParser *applyObj = [applyObjArr objectAtIndex:i];
                                ApprovedInfo *info = [self convertJsonItemToApprovedInfo:applyObj TodoId:todoId];
                                info.approveType = APPROVE_TYPE_APPLY;
                                [applyInfoArr addObject:info];
                            }
                        }
                    }else{
                        if ([applyApprovedInfoObj valueForKey:@"e"]) {
                            SBJsonParser *applyObj = [applyApprovedInfoObj valueForKey:@"e"];
                            ApprovedInfo *info = [self convertJsonItemToApprovedInfo:applyObj TodoId:todoId];
                            info.approveType = APPROVE_TYPE_APPLY;
                            [applyInfoArr addObject:info];
                        }
                    }
                    
                    if ([applyInfoArr count]>0) {
                        todoInfo.applyApprovedArr = applyInfoArr;
                    }
                    
                    id subApprovedInfoObj = [commentObj valueForKey:@"subApprovedInfo"];
                    NSMutableArray *subInfoArr = [[[NSMutableArray alloc]init] autorelease];
                    if ([[subApprovedInfoObj class] isSubclassOfClass:[NSArray class]]) {
                        NSArray *subObjArr = subApprovedInfoObj;
                        if (subObjArr!=nil&&[subObjArr count]>0) {
                            for (int j=0; j<[subObjArr count]; j++) {
                                SBJsonParser *subObj = [subObjArr objectAtIndex:j];
                                ApprovedInfo *info = [self convertJsonItemToApprovedInfo:subObj TodoId:todoId];
                                info.approveType = APPROVE_TYPE_SUB;
                                [subInfoArr addObject:info];
                            }
                        }
                    }else{
                        if ([subApprovedInfoObj valueForKey:@"e"]) {
                            SBJsonParser *subObj = [subApprovedInfoObj valueForKey:@"e"];
                            ApprovedInfo *info = [self convertJsonItemToApprovedInfo:subObj TodoId:todoId];
                            info.approveType = APPROVE_TYPE_SUB;
                            [subInfoArr addObject:info];
                        }
                    }
                    
                    if ([subInfoArr count]>0) {
                        todoInfo.subApprovedArr = subInfoArr;
                    }
                    
                    id backApplyApprovedInfoObj = [commentObj valueForKey:@"backApplyApprovedInfo"];
                    NSMutableArray *backInfoArr = [[[NSMutableArray alloc]init] autorelease];
                    if ([[backApplyApprovedInfoObj class] isSubclassOfClass:[NSArray class]]) {
                        NSArray *backObjArr = backApplyApprovedInfoObj;
                        if (backObjArr!=nil&&[backObjArr count]>0) {
                            for (int m=0; m<[backObjArr count]; m++) {
                                SBJsonParser *backObj = [backObjArr objectAtIndex:m];
                                ApprovedInfo *info = [self convertJsonItemToApprovedInfo:backObj TodoId:todoId];
                                info.approveType = APPROVE_TYPE_BACK;
                                [backInfoArr addObject:info];
                            }
                        }
                    }else{
                        if ([backApplyApprovedInfoObj valueForKey:@"e"]) {
                            SBJsonParser *backObj = [backApplyApprovedInfoObj valueForKey:@"e"];
                            ApprovedInfo *info = [self convertJsonItemToApprovedInfo:backObj TodoId:todoId];
                            info.approveType = APPROVE_TYPE_BACK;
                            [backInfoArr addObject:info];
                        }
                    }
                    
                    if ([backInfoArr count]>0) {
                        todoInfo.backApplyApprovedArr = backInfoArr;
                    }
                }
                [dao update:todoInfo];
                [dao release];
            }
            
        }
    }
}

-(ApprovedInfo *)convertJsonItemToApprovedInfo:(SBJsonParser *)jsonObj TodoId:(NSString *)todoId{
    ApprovedInfo *appInfo = [[[ApprovedInfo alloc]init] autorelease];
    if ([jsonObj valueForKey:@"TYPE"]) {
        appInfo.type = [jsonObj valueForKey:@"TYPE"];
    }
    if ([jsonObj valueForKey:@"CNAME"]) {
        appInfo.cname = [jsonObj valueForKey:@"CNAME"];
    }
    if ([jsonObj valueForKey:@"CINCIDENT"]) {
        appInfo.cincident = [jsonObj valueForKey:@"CINCIDENT"];
    }
    if ([jsonObj valueForKey:@"STEPNAME"]) {
        appInfo.stepname = [jsonObj valueForKey:@"STEPNAME"];
    }
    if ([jsonObj valueForKey:@"OPTION_CODE"]) {
        appInfo.optionCode = [jsonObj valueForKey:@"OPTION_CODE"];
    }
    if ([jsonObj valueForKey:@"DEPT_ID"]) {
        appInfo.deptId = [jsonObj valueForKey:@"DEPT_ID"];
    }
    if ([jsonObj valueForKey:@"DEPT"]) {
        appInfo.dept = [jsonObj valueForKey:@"DEPT"];
    }
    if ([jsonObj valueForKey:@"USERNAME"]) {
        appInfo.userName = [jsonObj valueForKey:@"USERNAME"];
    }
    if ([jsonObj valueForKey:@"USERFULLNAME"]) {
        appInfo.userFullName = [jsonObj valueForKey:@"USERFULLNAME"];
    }
    if ([jsonObj valueForKey:@"REMARK"]) {
        appInfo.remark = [jsonObj valueForKey:@"REMARK"];
    }
    if ([jsonObj valueForKey:@"UPDDATE"]) {
        appInfo.updDate = [jsonObj valueForKey:@"UPDDATE"];
    }
    if ([jsonObj valueForKey:@"DAY"]) {
        appInfo.day = [jsonObj valueForKey:@"DAY"];
    }
    if ([jsonObj valueForKey:@"TIME"]) {
        appInfo.time = [jsonObj valueForKey:@"TIME"];
    }
    if ([jsonObj valueForKey:@"GUID"]) {
        appInfo.guid = [jsonObj valueForKey:@"GUID"];
    }
    if ([jsonObj valueForKey:@"P_ID"]) {
        appInfo.pId = [jsonObj valueForKey:@"P_ID"];
    }
    if ([jsonObj valueForKey:@"C_ID"]) {
        appInfo.cId = [jsonObj valueForKey:@"C_ID"];
    }
//    if ([jsonObj valueForKey:@"C_ID"]) {
//        appInfo.todoId = [jsonObj valueForKey:@"C_ID"];
//    }
    appInfo.todoId = todoId;
    if ([jsonObj valueForKey:@"FILE_GROUP_ID"]) {
        appInfo.fileGroupId = [jsonObj valueForKey:@"FILE_GROUP_ID"];
    }
    return appInfo;
}

-(void)reflashAttachFile:(NSString *)fileGroupId{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDataExchangeAPIUrl]];
    NSString *dataPara = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><params><groupId>%@</groupId></params>",fileGroupId];
    [ApiConfig setHttpPostData:request Method:[ApiConfig getAttachFileMethod] DataParams:dataPara Key:[[[UserAccountContext singletonInstance] userAccountInfo] token]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [self convertJsonItemToAttachFileInfo:jsonObj GroupId:fileGroupId];
    }else{
        
    }
}

-(void)convertJsonItemToAttachFileInfo:(SBJsonParser *)jsonObj GroupId:(NSString *)groupId{
    if (jsonObj!=nil&&[jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        NSString *description = @"";
        if ([jsonObj valueForKey:@"description"]) {
            description = [jsonObj valueForKey:@"description"];
        }
        if ([[SystemContext singletonInstance] processHttpResponseCode:code Desc:description]) {
            if ([jsonObj valueForKey:@"params"]) {
                id paraArr = [jsonObj valueForKey:@"params"];
                if ([[paraArr class] isSubclassOfClass:[NSArray class]]) {
                    if (paraArr!=nil&&[paraArr count]>0) {
                        AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
                        for (int i=0; i<[paraArr count]; i++) {
                            SBJsonWriter *paramObj = [paraArr objectAtIndex:i];
                            SBJsonWriter *fileObj =[paramObj valueForKey:@"attachFile"];
                            AttachFileInfo *fileInfo = [[[AttachFileInfo alloc]init] autorelease];
                            if ([fileObj valueForKey:@"id"]) {
                                fileInfo.fileId = [fileObj valueForKey:@"id"];
                            }
                            if ([fileObj valueForKey:@"fileName"]) {
                                fileInfo.fileName = [fileObj valueForKey:@"fileName"];
                            }
                            if ([fileObj valueForKey:@"fileExtName"]) {
                                fileInfo.fileExtName = [fileObj valueForKey:@"fileExtName"];
                            }
                            if ([fileObj valueForKey:@"path"]) {
                                fileInfo.path = [fileObj valueForKey:@"path"];
                            }
                            if ([fileObj valueForKey:@"fileSize"]) {
                                fileInfo.fileSize = [fileObj valueForKey:@"fileSize"];
                            }
                            if ([fileObj valueForKey:@"uploader"]) {
                                fileInfo.uploader = [fileObj valueForKey:@"uploader"];
                            }
                            if ([fileObj valueForKey:@"uploaderLoginName"]) {
                                fileInfo.uploaderLoginName = [fileObj valueForKey:@"uploaderLoginName"];
                            }
                            if ([fileObj valueForKey:@"uploadDate"]) {
                                fileInfo.uploadDate = [fileObj valueForKey:@"uploadDate"];
                            }
                            fileInfo.groupId = groupId;
                            if ([fileObj valueForKey:@"appName"]) {
                                fileInfo.appName = [fileObj valueForKey:@"appName"];
                            }
                            if ([fileObj valueForKey:@"saveFileName"]) {
                                fileInfo.saveFileName = [fileObj valueForKey:@"saveFileName"];
                            }
                            if ([fileObj valueForKey:@"memo"]) {
                                fileInfo.memo = [fileObj valueForKey:@"memo"];
                            }
                            if ([fileObj valueForKey:@"memo"]) {
                                fileInfo.memo = [fileObj valueForKey:@"memo"];
                            }
                            if ([fileObj valueForKey:@"version"]) {
                                fileInfo.version = [fileObj valueForKey:@"version"];
                            }
                            if ([fileObj valueForKey:@"status"]) {
                                fileInfo.status = [fileObj valueForKey:@"status"];
                            }
                            if ([fileObj valueForKey:@"operateTime"]) {
                                fileInfo.operateTime = [fileObj valueForKey:@"operateTime"];
                            }
                            if ([fileObj valueForKey:@"removed"]) {
                                fileInfo.removed = [fileObj valueForKey:@"removed"];
                            }
               
                                [dao insertTodo:fileInfo];
      
                          //  [dao insert:fileInfo];
                        }
                        [dao release];
                    }
                }else{
                    AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
                    SBJsonWriter *paramObj = [paraArr valueForKey:@"param"];
                    SBJsonWriter *fileObj =[paramObj valueForKey:@"attachFile"];
                    AttachFileInfo *fileInfo = [[[AttachFileInfo alloc]init] autorelease];
                    if ([fileObj valueForKey:@"id"]) {
                        fileInfo.fileId = [fileObj valueForKey:@"id"];
                    }
                    if ([fileObj valueForKey:@"fileName"]) {
                        fileInfo.fileName = [fileObj valueForKey:@"fileName"];
                    }
                    if ([fileObj valueForKey:@"fileExtName"]) {
                        fileInfo.fileExtName = [fileObj valueForKey:@"fileExtName"];
                    }
                    if ([fileObj valueForKey:@"path"]) {
                        fileInfo.path = [fileObj valueForKey:@"path"];
                    }
                    if ([fileObj valueForKey:@"fileSize"]) {
                        fileInfo.fileSize = [fileObj valueForKey:@"fileSize"];
                    }
                    if ([fileObj valueForKey:@"uploader"]) {
                        fileInfo.uploader = [fileObj valueForKey:@"uploader"];
                    }
                    if ([fileObj valueForKey:@"uploaderLoginName"]) {
                        fileInfo.uploaderLoginName = [fileObj valueForKey:@"uploaderLoginName"];
                    }
                    if ([fileObj valueForKey:@"uploadDate"]) {
                        fileInfo.uploadDate = [fileObj valueForKey:@"uploadDate"];
                    }
                   // fileInfo.groupId = groupId;
                    if (groupId !=nil) {
                        fileInfo.groupId = groupId;
                    }else if([fileObj valueForKey:@"groupId"]){
                        fileInfo.groupId = [fileObj valueForKey:@"groupId"];
                    }
                    if ([fileObj valueForKey:@"appName"]) {
                        fileInfo.appName = [fileObj valueForKey:@"appName"];
                    }
                    if ([fileObj valueForKey:@"saveFileName"]) {
                        fileInfo.saveFileName = [fileObj valueForKey:@"saveFileName"];
                    }
                    if ([fileObj valueForKey:@"memo"]) {
                        fileInfo.memo = [fileObj valueForKey:@"memo"];
                    }
                    if ([fileObj valueForKey:@"memo"]) {
                        fileInfo.memo = [fileObj valueForKey:@"memo"];
                    }
                    if ([fileObj valueForKey:@"version"]) {
                        fileInfo.version = [fileObj valueForKey:@"version"];
                    }
                    if ([fileObj valueForKey:@"status"]) {
                        fileInfo.status = [fileObj valueForKey:@"status"];
                    }
                    if ([fileObj valueForKey:@"operateTime"]) {
                        fileInfo.operateTime = [fileObj valueForKey:@"operateTime"];
                    }
                    if ([fileObj valueForKey:@"removed"]) {
                        fileInfo.removed = [fileObj valueForKey:@"removed"];
                    }
                    
                    [dao insertTodo:fileInfo];
    
                  //  [dao insert:fileInfo];
                    [dao release];
                }
                
            }
            
        }
    }
}

-(NSDictionary *)convertProcessJson:(SBJsonParser *)jsonObj TodoId:(NSString *)todoId{
    
    /**
     {
     "description": "success!",
     "params": {"param":  {
     "infos": [],
     "errors": [],
     "refresh": "false",
     "checkFlag": "true"
     }},
     "code": "100"
     }
     
     {
     "description": "success!",
     "params": {"param":  {
     "infos": [],
     "errors": {"e":   {
     "actionField": [],
     "type": "10",
     "textCn": "操作不存在或操作已完成！"
     }},
     "refresh": "true",
     "checkFlag": "false"
     }},
     "code": "100"
     }
     
     */
    NSDictionary *resp = nil;
    if (jsonObj!=nil&&[jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        NSString *description = @"";
        if ([jsonObj valueForKey:@"description"]) {
            description = [jsonObj valueForKey:@"description"];
        }
        if ([[SystemContext singletonInstance] processHttpResponseCode:code Desc:description]) {
            SBJsonParser *paramsObj = [jsonObj valueForKey:@"params"];
            SBJsonParser *paramObj = [paramsObj valueForKey:@"param"];
            id errorObj = [paramObj valueForKey:@"errors"];
            if ([[errorObj class] isSubclassOfClass:[NSArray class]]) {
                description = @"待办事项已提交处理";
            }else{
                SBJsonParser *eObj = [errorObj valueForKey:@"e"];
                description = [eObj valueForKey:@"textCn"];
            }
        }
        NSArray *objectsArray = [[NSArray alloc]initWithObjects:code,description, nil];
        NSArray *keysArray = [[NSArray alloc]initWithObjects:@"code",@"description", nil];
        resp = [[[NSDictionary alloc]initWithObjects:objectsArray forKeys:keysArray]autorelease];
        [objectsArray release];
        [keysArray release];
        
       
    }
    return resp;
}

-(NSDictionary *)convertCheckVersionJson:(SBJsonParser *)jsonObj{
    /**
     {
     "description": "success!",
     "params": {"param":  {
     "appUrl": "http://10.1.40.201:8088/ca/mobile/eyun.plist",
     "topVersion": "1.0",
     "deviceType": "ios"
     }},
     "code": "100"
     }
     
     
     Printing description of respStr:
     {
     "description": "无版本更新",
     "params": [],
     "code": "117"
     }
     */
    if (jsonObj==nil) {
        return nil;
    }
    id paramsObj = [jsonObj valueForKey:@"params"];
if([[paramsObj class] isSubclassOfClass:[NSArray class]]){
    return nil;
}else{
    SBJsonParser *paramObj = [paramsObj valueForKey:@"param"];
    NSArray *tempArray = [[NSArray alloc]initWithObjects:[paramObj valueForKey:@"appUrl"],[paramObj valueForKey:@"topVersion"], nil];
    NSArray *keys = [[NSArray alloc]initWithObjects:@"appUrl",@"topVersion", nil];
    NSDictionary *resultDic = [[[NSDictionary alloc]initWithObjects:tempArray forKeys:keys] autorelease];
    [tempArray release];
    [keys release];
    return resultDic;
}
}

//{
//    "description": "success!",
//    "params": {"param": {"attachUrl": "http://10.1.40.201:8088/workflowLocal/api/downloadFile.action?fileId=60108"}},
//    "code": "100"
//}
-(NSString *)convertJsonItemToAttachFileDetailInfo:(SBJsonParser *)jsonObj{
    NSString *resp = nil;
    if (jsonObj!=nil&&[jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        NSString *description = @"";
        if ([jsonObj valueForKey:@"description"]) {
            description = [jsonObj valueForKey:@"description"];
        }
        if ([[SystemContext singletonInstance] processHttpResponseCode:code Desc:description]) {
            SBJsonParser *paramsObj = [jsonObj valueForKey:@"params"];
            if (paramsObj) {
                SBJsonParser *paramObj = [paramsObj valueForKey:@"param"];
                if (paramObj) {
                    resp = [paramObj valueForKey:@"attachUrl"];
                }
            }
        }
    }
    
    return resp;
}

#pragma mark - Meeting
-(NSDictionary *)getOrgs{
    MeetingDao *meetingDao = [[MeetingDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getOrgsAPIUrl]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [meetingDao saveMeetingOrgInfoFromJsonValue:jsonObj];
        
    }
    NSDictionary *orgs = [meetingDao queryAllOrg];
    [meetingDao release];
    return orgs;
}

-(NSArray *)searchMeetingRoomByOrg:(NSString *)orgId{
    MeetingDao *meetingDao = [[MeetingDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getMeetingRoomInfoAPIUrlByOrg:orgId]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [meetingDao saveMeetingRoomInfoFromJsonValue:jsonObj];
        
    }
    NSArray *meetingRoomInfos = [meetingDao queryMeetingRoomByOrg:orgId];
    [meetingDao release];
    return meetingRoomInfos;

}

-(void)refreshMeetingListFromStartDate:(NSString *)startdate ToEndDate:(NSString *)enddate{
    MeetingDao *meetingDao = [[MeetingDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getMeetingListAPIUrlFromStartDate:startdate ToEndDate:enddate]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
       [meetingDao saveMeetinglistFromJsonValue:jsonObj];
        
    }
    [meetingDao release];
}

-(void)refreshMeetingListByUserName:(NSString *)userName FromStartDate:(NSString *)startdate ToEndDate:(NSString *)enddate
{
    MeetingDao *meetingDao = [[MeetingDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getMeetingListAPIUrlByUserName:userName FromStartDate:startdate ToEndDate:enddate]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [meetingDao saveMeetinglistFromJsonValue:jsonObj];
        
    }
    [meetingDao release];
}
-(MeetingInfo *)getMeeting:(NSString*)meetId{
    MeetingDao *meetingDao = [[MeetingDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getMeetingDetailAPIUrl:meetId]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [meetingDao saveMeetingDetailFromJsonValue:jsonObj];
    }
    MeetingInfo *meetingInfo = [meetingDao getMeetingById:meetId];
    [meetingDao release];
    
    return meetingInfo;
}

#pragma mark - Contact
-(void)refreshContact{
    ContactInfoDao *contactInfoDao = [[ContactInfoDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDataExchangeAPIUrl]];
    [ApiConfig setHttpPostData:request Method:[ApiConfig getTodoListMethod] DataParams:nil Key:[[[UserAccountContext singletonInstance] userAccountInfo] token]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [contactInfoDao saveContactFromJsonValue:jsonObj];
        
    }
    [contactInfoDao release];
}

-(ContactInfo *)refreshContactByLoginName:(NSString *)loginName{
    ContactInfoDao *contactInfoDao = [[ContactInfoDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getUserInfoAPIUrl:loginName]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [contactInfoDao saveContactFromJsonValue:jsonObj clearContacts:NO];
    }
    ContactInfo *contactInfo = [contactInfoDao getContactByLoginName:loginName];
    [contactInfoDao release];
    
    return contactInfo;
}

-(NSArray *)searchContactsByDept:(NSString *)deptName{
    ContactInfoDao *contactInfoDao = [[ContactInfoDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getContactsAPIUrlByDeptName:deptName]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [contactInfoDao saveContactFromJsonValue:jsonObj clearContacts:YES];

    }
    NSArray *contacts = [contactInfoDao queryContactByDept:deptName];
    [contactInfoDao release];
    return contacts;
}
-(NSArray *)searchContactsByUserName:(NSString *)userName{
    ContactInfoDao *contactInfoDao = [[ContactInfoDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getContactsAPIUrlByUserName:userName]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [contactInfoDao saveContactFromJsonValue:jsonObj clearContacts:YES];
        
    }
    NSArray *contacts = [contactInfoDao queryContactByName:userName];
    [contactInfoDao release];
    return contacts;
}


#pragma mark - UserInfo Center
-(BOOL)checkNickName:(NSString *)nickName{
    BOOL isUnique = NO;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig checkNicknameUniqueAPIUrl:nickName]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        NSString *code = [jsonObj valueForKey:@"code"];
        isUnique = [code isEqualToString:@"1000"]?YES:NO;
    }
    
    return isUnique;
}

-(BOOL)modifyUserPasswordAndNick:(NSString *)uid Password:(NSString *)password Nickname:(NSString *)nickName{
    BOOL isSuccess = NO;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[ApiConfig modifyUserPasswordAndNickAPIUrl:uid Password:password Nickname:nickName]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:uid forKey:@"id"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:nickName forKey:@"nickName"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        if ([[SystemContext singletonInstance] processHttpResponseCode:[jsonObj valueForKey:@"code"] Desc:[jsonObj valueForKey:@"description"]]) {
            isSuccess = YES;
        }
    }
    
    return isSuccess;
}
-(BOOL)modifyUserInfo:(NSString *)uid Email:(NSString *)email Phone:(NSString *)phone Moible1:(NSString *)mobile1 Mobile2:(NSString *)mobile2{
    BOOL isSuccess = NO;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[ApiConfig modifyUserInfoAPIUrl:uid Email:email Phone:phone Moible1:mobile1 Mobile2:mobile2]];
    [request setPostValue:uid forKey:@"id"];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:mobile1 forKey:@"mobile1"];
    [request setPostValue:mobile2 forKey:@"mobile2"];
    
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        if ([[SystemContext singletonInstance] processHttpResponseCode:[jsonObj valueForKey:@"code"] Desc:[jsonObj valueForKey:@"description"]]) {
            isSuccess = YES;
        }
    }
    
    return isSuccess;
}

-(UserInfo*)refreshUserInfo{
    UserInfoDao *userInfoDao = [[UserInfoDao alloc]init];
    NSString *loginName = [[[UserAccountContext singletonInstance]userAccountInfo]loginName];
    loginName = [loginName substringToIndex:12];
   ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getUserInfoAPIUrl:loginName]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [userInfoDao saveUserInfoFromJsonValue:jsonObj];
    }
    UserInfo *userInfo = [userInfoDao getUserInfoByLoginName:loginName];
    [userInfoDao release];
    
    return userInfo;
}

#pragma mark - Message
-(NSMutableArray *)searchMessageListFromOffset:(NSString *)offset WithLimit:(NSString *)limit{
    MessageDao *dao = [[MessageDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getMessagesFromOffset:offset WithLimit:limit]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [dao saveMessagelistFromJsonValue:jsonObj];
    }
    
    NSMutableArray *messages = [dao queryAllMessagelList];
    [dao release];
    return messages;
}

-(MessageDetailInfo *)getMessageDetail:(NSString*)mid App:(NSString *)appName{
     MessageDao *dao = [[MessageDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getMessageDetailById:mid App:appName]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [dao saveMessageDetailFromJsonValue:jsonObj];
    }
    MessageDetailInfo *messageDetailInfo = [dao getMessageDetailById:mid App:appName];
    [dao release];
    
    return messageDetailInfo;
}


-(void)refreshMeetingList{
    MeetingDao *dao = [[MeetingDao alloc]init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDataExchangeAPIUrl]];
    [ApiConfig setHttpPostData:request Method:[ApiConfig getTodoListMethod] DataParams:nil Key:[[[UserAccountContext singletonInstance] userAccountInfo] token]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        [dao saveMeetinglistFromJsonValue:jsonObj];
        
    }
    [dao release];
}
@end
