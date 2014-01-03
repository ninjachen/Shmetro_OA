//
//  STOService.h
//  ShmetroOA
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoInfo.h"
#import "AttachFileInfo.h"
#import "MessageDetailInfo.h"
#import "MeetingInfo.h"
#import "UserInfo.h"
#import "ContactInfo.h"
#import "WorkflowInfo.h"
@interface STOService : NSObject

#pragma mark - TodoList
-(void)reflashTodoList;
-(NSArray *)searchAllTodoList;
-(TodoInfo *)getTodoInfoDetail:(NSString *)todoId;
-(NSArray *)searchAttachFileList:(NSString *)fileGroupId;
-(NSDictionary *)processTodo:(TodoInfo *)todoInfo;
-(NSDictionary *)checkCurrentVersion;
-(AttachFileInfo *)getAttachFileDietail:(AttachFileInfo *)attachFileInfo;

-(void)refreshTodoListWithType:(NSString *)type;

#pragma mark - DocSend
-(void)updateDocSendSingleData:(NSString *)pid;
-(WorkflowInfo *)getWorkflowInfoDetail:(NSString *)pid;
-(NSArray *)searchDocSendAttachFileList:(NSString *)pid;
-(NSDictionary *)searchDocSendApproveInfoList:(NSString *)pid;
-(BOOL)docSendLeaderDealWithPid:(NSString *)pid Choice:(NSString *)choice Suggest:(NSString *)suggest;


#pragma mark - Meeting
-(NSDictionary *)getOrgs;
-(NSArray *)searchMeetingRoomByOrg:(NSString *)orgId;
-(void)refreshMeetingListFromStartDate:(NSString *)startdate ToEndDate:(NSString *)enddate;
-(void)refreshMeetingListByUserName:(NSString *)userName FromStartDate:(NSString *)startdate ToEndDate:(NSString *)enddate;
-(MeetingInfo *)getMeeting:(NSString*)meetId;

#pragma mark - Contact
-(void)refreshContact;
-(ContactInfo *)refreshContactByLoginName:(NSString *)loginName;
-(NSArray *)searchContactsByDept:(NSString *)deptName;
-(NSArray *)searchContactsByUserName:(NSString *)userName;

#pragma mark - Message
-(NSMutableArray *)searchMessageListFromOffset:(NSString *)offset WithLimit:(NSString *)limit;
-(MessageDetailInfo *)getMessageDetail:(NSString*)mid App:(NSString *)appName;

#pragma mark - UserInfo Center
-(BOOL)checkNickName:(NSString *)nickName;
-(BOOL)modifyUserPasswordAndNick:(NSString *)uid Password:(NSString *)password Nickname:(NSString *)nickName;
-(BOOL)modifyUserInfo:(NSString *)uid Email:(NSString *)email Phone:(NSString *)phone Moible1:(NSString *)mobile1 Mobile2:(NSString *)mobile2;
-(UserInfo*)refreshUserInfo;
@end
