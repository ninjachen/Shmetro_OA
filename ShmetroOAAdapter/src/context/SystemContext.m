//
//  SystemContext.m
//  ShmetroOA
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SystemContext.h"
#import "AppDelegate.h"
@implementation SystemContext
@synthesize currentVersion,terminalType,currentNetworkType;
@synthesize isTokenTimeOut;
static SystemContext *instance = NULL;
//SUCCESS
NSString *CODE_100=@"100";
NSString *CODE_1000=@"1000";
//没有相关数据记录
NSString *CODE_101=@"101";
//参数appName,token,method,sign不可为null
NSString *CODE_102=@"102";
//无效的sessionKey
NSString *CODE_103=@"103";
//应用appName无效
NSString *CODE_104=@"104";
//令牌token无效
NSString *CODE_105=@"105";
//令牌token已过期
NSString *CODE_106=@"106";
//参数method不正确，不存在此方法
NSString *CODE_107=@"107";
//参数sign验证无效
NSString *CODE_108=@"108";
//参数dataParams格式不正确，应为xml格式
NSString *CODE_109=@"109";
//参数dataParams中对应此method的参数不全
NSString *CODE_110=@"110";
//未知错误,请联系系统管理员
NSString *CODE_200=@"120";
+(id)singletonInstance{
    if(instance==nil){
        instance = [[SystemContext alloc]init];
        
    }
    return (instance);
}
-(id)init{
	self = [super init];
    if(self){
        
    }
    return self;
}

-(Boolean)processHttpResponseCode:(NSString *)code Desc:(NSString *)desc{
    Boolean resp = NO;
    if ([code isEqualToString:CODE_100]||[code isEqualToString:CODE_1000]) {
        resp = YES;
    }else if([code isEqualToString:CODE_101]){
        resp = NO;
    }else if([code isEqualToString:CODE_103]||[code isEqualToString:CODE_105]||[code isEqualToString:CODE_106]){
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate userLogout];
    }else {
        //终端操作提示用户
    }
    return resp;
}

-(Boolean)processHttpResponseCode:(NSString *)code{
    Boolean resp = NO;
    if ([code isEqualToString:CODE_1000]) {
        resp = YES;
    }else {
        //终端操作提示用户
    }
    return resp;
}

-(void)resetAutoRefreshTime:(NSString *)newTime{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *settingInfoPath=[path stringByAppendingPathComponent:@"systemconfig.plist"];
	
	NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:settingInfoPath];
    if (array==nil) {
        array = [[NSMutableArray alloc]init];
    }else{
        [array removeObjectAtIndex:0];
    }
    [array insertObject:newTime atIndex:0];
    [array writeToFile:settingInfoPath atomically:YES];
    [array release];
}

-(NSString *)getAutoRefreshTime{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *settingInfoPath=[path stringByAppendingPathComponent:@"systemconfig.plist"];
	
	NSMutableArray *array = [[[NSMutableArray alloc]initWithContentsOfFile:settingInfoPath] autorelease];
    if (array!=nil) {
        return [array objectAtIndex:0];
    }else{
        return @"3";
    }
}
@end
