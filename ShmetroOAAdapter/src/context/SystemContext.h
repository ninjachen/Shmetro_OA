//
//  SystemContext.h
//  ShmetroOA
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemContext : NSObject


@property (nonatomic,retain) NSString *currentVersion;
@property (nonatomic,retain) NSString *terminalType;
@property (nonatomic,retain) NSString *currentNetworkType;
@property Boolean isTokenTimeOut;
+(id)singletonInstance;
-(Boolean)processHttpResponseCode:(NSString *)code Desc:(NSString *)desc;
-(Boolean)processHttpResponseCode:(NSString *)code;
-(id)init;
-(void)initSystemInv:(NSString *)terminalType CurrentVersion:(NSString *)currentVersion;
-(void)setRemindOf3G:(BOOL)remind;
-(BOOL)getRemindOf3G;
-(void)setDownloadOnlyWifi:(BOOL)wifi;
-(BOOL)getDownloadOnlyWifi;
-(void)resetAutoRefreshTime:(NSString *)newTime;
-(NSString *)getAutoRefreshTime;
@end
