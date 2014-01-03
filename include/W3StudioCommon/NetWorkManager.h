//
//  NetWorkManager.h
//  Constellation
//
//  Created by jeffrey on 10-12-5.
//  Copyright 2010 AppUFO. All rights reserved.

#import <Foundation/Foundation.h>
#import "Reachability2.h"
#import <UIKit/UIKit.h>
#pragma mark NetWorkManagerDelegate

/**
 *
 * 您的应用程序需要实现此协议，当网络发生变化时候，与用户交互
 *
 */
@protocol NetWorkManagerDelegate

@required

- (void) netWorkStatusWillChange:(NetworkStatus)status;

@optional

- (void) netWorkStatusWillEnabled;

- (void) netWorkStatusWillEnabledViaWifi;

- (void) netWorkStatusWillEnabledViaWWAN;

- (void) netWorkStatusWillDisconnection;

@end


#pragma mark NetWorkManager

@interface NetWorkManager : NSObject<UIApplicationDelegate>
{
@private

	Reachability2* rech;
	
	/** 标识网络是否活跃 **/
	Boolean _netWorkIsEnabled;
	
	/** 设备链接网络的方式 **/
	NetworkStatus _witchNetWorkerEnabled;
	
	/** 代理 **/
	id<NetWorkManagerDelegate> delegate;
}

///!!!NOTICE:WNEH YOU WANT TO GET THIS,YOU MUST START THE WATCH FIRST
@property (readonly, getter = witchNetWorkerEnabled) NetworkStatus _witchNetWorkerEnabled;

///!!!NOTICE:WNEH YOU WANT TO GET THIS,YOU MUST START THE WATCH FIRST
@property (readonly, getter = netWorkIsEnabled) Boolean _netWorkIsEnabled;

@property (nonatomic, retain) id<NetWorkManagerDelegate> delegate;

/**
 *
 * 获取网络管理器
 *
 */
+ (id) sharedManager;

/**
 *
 * 防止以其他方法创建第二实例
 *
 */
+ (id) allocWithZone:(NSZone *)zone;

/**
 *
 * 检测当前网络状态
 *
 */
- (NetworkStatus) checkNowNetWorkStatus;
/**
 *
 * 开始检测网络
 *
 */
- (Boolean) startNetWorkeWatch;

/**
 *
 * 停止检测网络
 *
 */
- (void) stopNetWorkWatch;

@end

#pragma mark NetWorkManagerPrivateMethod

@interface NetWorkManager(private)

/**
 *
 * 当网络发生变化时
 *
 */
- (void)reachabilityChanged:(NSNotification *)note; 

@end

