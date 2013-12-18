//
//  UserAccountService.m
//  ShmetroOA
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserAccountService.h"
#import "UserAccountInfoDao.h"
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
@interface UserAccountService (privateMethods)
-(NSString *)getSessionKey:(NSString *)userId UserMd5Pass:(NSString *)userMd5Pass User3DesPass:(NSString *)desPass SignMd5:(NSString *)signMd5;
-(void)convertJsonItemToUserInfo:(SBJsonParser *)jsonObj UserInfo:(UserAccountInfo *)userInfo;
-(NSString *)convertJsonItemToSessionKey:(SBJsonParser *)jsonObj;
@end

@implementation UserAccountService
-(BOOL)userSignin:(NSString *)userId UserPass:(NSString *)userPass DeptId:(NSString *)deptId{
    NSString *userMd5Pass = [StringUtil md5Digest:userPass];
    NSString *desPass = [StringUtil TripleDES:userPass];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",userId,userPass,[ApiConfig getKeySecret]];
    NSString *signMd5 = [StringUtil md5Digest:sign];
    NSString *sessionKey = [self getSessionKey:userId UserMd5Pass:userMd5Pass User3DesPass:desPass SignMd5:signMd5];
    UserAccountInfoDao *userAccountInfoDao = [[UserAccountInfoDao alloc]init];
    BOOL resp =NO;
    if ([[[SystemContext singletonInstance] currentNetworkType] isEqualToString:[ApiConfig networkTypeNone]]) {
        UserAccountInfo *accountInfo = [userAccountInfoDao getUserAccountInfo:userId DeptId:deptId];
        if ([userMd5Pass isEqualToString:accountInfo.md5Pass] && [signMd5 isEqualToString:accountInfo.md5Sign] && [desPass isEqualToString:accountInfo.desPass]) {
            [[UserAccountContext singletonInstance] updateUserInfo:accountInfo];
            resp = YES;
        }
    }else{
    if (sessionKey!=nil) {
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDataExchangeAPIUrl]];
        [ApiConfig setHttpPostDataByLogin:request Method:[ApiConfig getUserLoginMethod] DeptId:deptId Key:sessionKey];
        [request setRequestMethod:@"POST"];
        [request setTimeOutSeconds:60];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
            id jsonObj = [respStr JSONValue];
            UserAccountInfo *userInfo = [[[UserAccountInfo alloc]init] autorelease];
            userInfo.md5Pass = userMd5Pass;
            userInfo.md5Sign = signMd5;
            userInfo.desPass = desPass;
            [self convertJsonItemToUserInfo:jsonObj UserInfo:userInfo];
            [userAccountInfoDao insert:userInfo];
            [[UserAccountContext singletonInstance] updateUserInfo:userInfo];
            resp = YES;
        }
    }
    }
    [userAccountInfoDao release];
    return resp;
}

-(NSArray *)getDeptArr:(NSString *)userId{
    NSMutableArray *respArr = nil;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getDeptAPIUrl]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:5];
    NSString *bodyString = [NSString stringWithFormat:@"loginName=%@",userId];
    NSMutableData *bodyData = [[[NSMutableData alloc]initWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    [request setPostBody:bodyData];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        /**
         {
         "description": "success!",
         "params": {"param":  {
         "deptName": "上海轨道交通信息管理中心",
         "userId": "2855",
         "deptId": "2549.2855"
         }},
         "code": "100"
         }
         
         or
         
         {
         "description": "success!",
         "params":  [
         {
         "deptName": "上海轨道交通信息管理中心",
         "userId": "2855",
         "deptId": "2549.2855"
         },
         {
         "deptName": "(代 陈川)上海轨道交通信息管理中心",
         "userId": "2850",
         "deptId": "2549.2850"
         }
         ],
         "code": "100"
         }
         
         */
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        DLog(@"%@",respStr);
        id jsonObj = [respStr JSONValue];
        if (jsonObj!=nil&&[jsonObj valueForKey:@"code"]) {
            if ([[SystemContext singletonInstance] processHttpResponseCode:[jsonObj valueForKey:@"code"] Desc:[jsonObj valueForKey:@"description"]]) {
                id paraArr = [jsonObj valueForKey:@"params"];
                if (paraArr!=nil) {
                    respArr = [[[NSMutableArray alloc]init] autorelease];
                    if ([paraArr isKindOfClass:[NSArray class]]) {
                        for (int i=0; i<[paraArr count]; i++) {
                            NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc]init];
                            [tmpDic setValue:[[paraArr objectAtIndex:i] valueForKey:@"deptId"] forKey:@"deptId"];
                            [tmpDic setValue:[[paraArr objectAtIndex:i] valueForKey:@"deptName"] forKey:@"deptName"];
                            [respArr addObject:tmpDic];
                            [tmpDic release];
                        }
                    }else{
                        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc]init];
                        SBJsonWriter *paramObj = [paraArr valueForKey:@"param"];
                        [tmpDic setValue:[paramObj valueForKey:@"deptId"] forKey:@"deptId"];
                        [tmpDic setValue:[paramObj valueForKey:@"deptName"] forKey:@"deptName"];
                        [respArr addObject:tmpDic];
                        [tmpDic release];
                    }
                }
            }
        }
    }
    return respArr;
}

#pragma mark - PrivateMehtod implements
-(NSString *)getSessionKey:(NSString *)userId UserMd5Pass:(NSString *)userMd5Pass User3DesPass:(NSString *)desPass SignMd5:(NSString *)signMd5{
    NSString *sessionKey=nil;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[ApiConfig getMobileSessionKeyAPIUrl]];
    NSString *pwd = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)desPass, nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSLog(@"%@", pwd);
    NSString *bodyString = [NSString stringWithFormat:@"loginName=%@&password=%@&appName=%@&sign=%@&secret=%@&deviceType=%@&deviceId=%@",userId,pwd,[ApiConfig getKeyMobile],signMd5,[ApiConfig getKeyMobile],@"1",[[UIDevice currentDevice] macaddress]];
    NSMutableData *bodyData = [[[NSMutableData alloc]initWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    [request setPostBody:bodyData];  
//    [request setRequestHeaders:headerDic];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *respStr = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id jsonObj = [respStr JSONValue];
        UserAccountInfo *userInfo = [[[UserAccountInfo alloc]init] autorelease];
        userInfo.md5Pass = userMd5Pass;
        userInfo.desPass = desPass;
        sessionKey = [self convertJsonItemToSessionKey:jsonObj];
    }else{
        NSString *respStr = @"{\"code\":\"100\",\"description\":\"<参照response_code_sheet的注释>\",\"params\":{\"param\":{\"sessionKey\":0.06723948351992137}}}";
        id jsonObj = [respStr JSONValue];
        UserAccountInfo *userInfo = [[[UserAccountInfo alloc]init] autorelease];
        userInfo.md5Pass = userMd5Pass;
        userInfo.desPass = desPass;
        sessionKey = [self convertJsonItemToSessionKey:jsonObj];
    }
//    [headerDic release];
    return sessionKey;
}


/*
 {
    "code": "参照response_code_sheet的值",
    "description": "参照response_code_sheet的注释",
        "params": {
            "param": {
                "token": "8a81a849392daa25013942833a3f0aac",
                "tuser": {
                    "id": "xxxx",
                    "loginName": "xxxxx",
                    "name": "xxxxx",
                    "password": "xxxx"
                },
                "csuser": {
                    "userId": "2850",
                    "loginName": "G001000001612549",
                    "userName": "张三",
                    "deptId": "2549",
                    "deptName": "信息管理中心"
                }
            }
        }
    }
 **/
-(void)convertJsonItemToUserInfo:(SBJsonParser *)jsonObj UserInfo:(UserAccountInfo *)userInfo{
    if (jsonObj!=nil&&[jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        NSString *description = @"";
        if ([jsonObj valueForKey:@"description"]) {
            description = [jsonObj valueForKey:@"description"];
        }
        if ([[SystemContext singletonInstance] processHttpResponseCode:code Desc:description]) {
            if ([jsonObj valueForKey:@"params"]) {
                SBJsonParser *paramsObj = [jsonObj valueForKey:@"params"];
                if ([paramsObj valueForKey:@"param"]) {
                    SBJsonWriter *paramObj = [paramsObj valueForKey:@"param"];
                    if ([paramObj valueForKey:@"token"]) {
                        userInfo.token = [paramObj valueForKey:@"token"];
                    }
                    if ([paramObj valueForKey:@"csuser"]) {
                        SBJsonParser *cuserObj = [paramObj valueForKey:@"csuser"];
                        if ([cuserObj valueForKey:@"userId"]) {
                            userInfo.userId = [cuserObj valueForKey:@"userId"];
                        }
                        if ([cuserObj valueForKey:@"loginName"]) {
                            userInfo.loginName = [cuserObj valueForKey:@"loginName"];
                        }
                        if ([cuserObj valueForKey:@"userName"]) {
                            userInfo.userName = [cuserObj valueForKey:@"userName"];
                        }
                        if ([cuserObj valueForKey:@"deptId"]) {
                            userInfo.deptId = [cuserObj valueForKey:@"deptId"];
                        }
                        if ([cuserObj valueForKey:@"deptName"]) {
                            userInfo.deptName = [cuserObj valueForKey:@"deptName"];
                        }
                    }
                }
            }
            
        }
    }
    
}
/**
 {
    "code": "<参照response_code_sheet的值>",
        "description":"<参照response_code_sheet的注释>",
        "params": {
            "param": {
                "sessionKey": 0.06723948351992137
            }
        }
 }
 */
-(NSString *)convertJsonItemToSessionKey:(SBJsonParser *)jsonObj{
    NSString *resp = nil;
    if (jsonObj!=nil&&[jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        NSString *description = @"";
        if ([jsonObj valueForKey:@"description"]) {
            description = [jsonObj valueForKey:@"description"];
        }
        if ([[SystemContext singletonInstance] processHttpResponseCode:code Desc:description]) {
            if ([jsonObj valueForKey:@"params"]) {
                SBJsonParser *paramsObj = [jsonObj valueForKey:@"params"];
                if ([paramsObj valueForKey:@"param"]) {
                    SBJsonWriter *paramObj = [paramsObj valueForKey:@"param"];
                    if ([paramObj valueForKey:@"sessionKey"]) {
                        resp = [paramObj valueForKey:@"sessionKey"];
                    }
                }
            }
            
        }
    }
    return resp;
}
@end
