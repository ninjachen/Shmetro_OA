//
//  ApiConfig.h
//  ShmetroOA
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
@interface ApiConfig : NSObject
+(NSString *)getKeyMobile;
+(NSString *)getKeySecret;
+(NSString *)getUserLoginMethod;
+(NSString *)getTodoListMethod;
+(NSString *)getTodoDetailMethod;
+(NSString *)getAttachFileMethod;
+(NSString *)getTodoSubmitMethod;
+(NSString *)getBeginUploadMethod;
+(NSString *)getFileUploadMethod;
+(NSString *)getEndUploadMethod;

+(NSURL *)getMobileSessionKeyAPIUrl;
+(NSURL *)getDataExchangeAPIUrl;
+(NSString *)getAttachFileDetailMethod;
+(NSURL *)getDeptAPIUrl;
+(NSURL *)getVersionUpdateAPIUrl;
+(NSURL *)getApproveMonitorUrl:(NSString *)todoId;
+(NSURL *)getTodoListAPIURLWithType:(NSString *)typeName ByLoginName:(NSString *)loginName;

#pragma mark - DocSend
+(NSURL *)getUpdateSingleDataAPIURLWithType:(NSString *)typeName Pid:(NSString *)pid;
+(NSURL *)getProcessdataAPIURLWithType:(NSString *)typeName Pid:(NSString *)pid DataType:(NSString *)dataType;
+(NSURL *)getDocSendLeaderDealAPIURLWithPid:(NSString *)pid Choice:(NSString *)choice Suggest:(NSString *)suggest LoginName:(NSString *)loginName;
#pragma mark - Userinfo
+(NSURL *)getUserInfoAPIUrl:(NSString *)loginName;
+(NSURL *)checkNicknameUniqueAPIUrl:(NSString *)nickName;
+(NSURL *)modifyUserPasswordAndNickAPIUrl:(NSString *)uid Password:(NSString *)password Nickname:(NSString *)nickName;
+(NSURL *)modifyUserInfoAPIUrl:(NSString *)uid Email:(NSString *)email Phone:(NSString *)phone Moible1:(NSString *)mobile1 Mobile2:(NSString *)mobile2;

#pragma mark - Contact
+(NSURL *)getContactsAPIUrlByDeptName:(NSString *)deptName;
+(NSURL *)getContactsAPIUrlByUserName:(NSString *)userName;

#pragma mark - Meeting
+(NSURL *)getOrgsAPIUrl;
+(NSURL *)getMeetingRoomInfoAPIUrlByOrg:(NSString *)org;
+(NSURL *)getMeetingListAPIUrlFromStartDate:(NSString *)startdate ToEndDate:(NSString *)enddate;
+(NSURL *)getMeetingDetailAPIUrl:(NSString *)meetId;
+(NSURL *)getMeetingListAPIUrlByUserName:(NSString *)userName FromStartDate:(NSString *)startdate ToEndDate:(NSString *)enddate;

#pragma mark - Message
+(NSURL*)getMessagesFromOffset:(NSString *)offset WithLimit:(NSString *)limit;
+(NSURL *)getMessageDetailById:(NSString *)messageId App:(NSString *)appName;

#pragma mark - fileupload
//upload
+(NSURL *)getUploadFileUrl;
+(NSMutableDictionary *)getHttpRequestDic:(NSString *)method DataParams:(NSString *)dataParams Key:(NSString *)key;

+(void)setHttpPostData:(ASIHTTPRequest *)request Method:(NSString *)method DataParams:(NSString *)dataParams Key:(NSString *)key;

+(void)setHttpPostDataByLogin:(ASIHTTPRequest *)request Method:(NSString *)method DeptId:(NSString *)deptId Key:(NSString *)key;

+(NSString *)networkType3G;
+(NSString *)networkTypeWifi;
+(NSString *)networkTypeNone;
@end
