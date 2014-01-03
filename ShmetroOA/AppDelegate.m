//
//  AppDelegate.m
//  ShmetroOA
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ApiConfig.h"
#import "ContactInfoDao.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "UserAccountContext.h"
#import "MessageDao.h"
#import "MeetingDao.h"
#import "NetWorkManager.h"
#import "SystemContext.h"
#import "STOService.h"
#import "TodoInfoDao.h"
#import "FileUploadContext.h"
NSString *updateUrl;
@interface AppDelegate(PrivateMethods)
-(void)checkNetwork;
@end
@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize loginViewController;
@synthesize navcontroller;
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [loginViewController release];
    [navcontroller release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *tmpWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window =tmpWindow;
    [tmpWindow release];
    
    if([[UserAccountContext singletonInstance] isSign]){
        [self loginSuccess];
    }else{
        [self userLogout];
    }
    
    [self.window makeKeyAndVisible];
    [self checkNetwork];
    STOService *service = [[STOService alloc]init];
    NSDictionary *versionDic = [service checkCurrentVersion];
    [service release];
    if (versionDic!=nil) {
        NSString *appUrl = [versionDic valueForKey:@"appUrl"];
        updateUrl = [[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=itms-services:///?action=download-manifest&url=%@",appUrl]retain];
//        updateUrl = [[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=itms-services:///?action=download-manifest&url=%@",[[versionDic valueForKey:@"appUrl"] retain]] retain];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示" message:[NSString stringWithFormat:@"您当前版本过低，需要升级，当前最高版本为:%@,您是否要立即升级?",[versionDic valueForKey:@"topVersion"]] delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"退出应用", nil];
        [alert show];
        [alert release];
    }else{
        [FileUploadContext singletonInstance];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - PublicMethod Implements
-(void)loginSuccess{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
        UINavigationController *tmpNavigationController = [[UINavigationController alloc]initWithRootViewController:self.viewController];
        self.navcontroller = tmpNavigationController;
        [tmpNavigationController release];
        //self.navcontroller = [[UINavigationController alloc]initWithRootViewController:self.viewController];
        [self.navcontroller setNavigationBarHidden:YES];
         self.window.rootViewController = self.navcontroller;
    } else {
        ViewController *tmpViewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
        self.viewController = tmpViewController;
        [tmpViewController release];
         self.window.rootViewController = self.viewController;
    }
   
}

-(void)userLogout{
    [[UserAccountContext singletonInstance] userLogout];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        LoginViewController *tmpLoginViewController =  [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPhone" bundle:nil];
        self.loginViewController = tmpLoginViewController;
        [tmpLoginViewController release];
    } else {
        LoginViewController *tmpLoginViewController =  [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPad" bundle:nil];
        self.loginViewController = tmpLoginViewController;
        [tmpLoginViewController release];
    }
    self.window.rootViewController = self.loginViewController;
}

-(void)refreshCache{
    NSMutableString *strMessage = [[[NSMutableString alloc] init]autorelease];
    NSString *temp = nil;
    MessageDao *tmpMessageDao = [[MessageDao alloc]init];
    if ([tmpMessageDao deleteAllMessages])//清空最新消息缓存
    {
        temp = @"清空最新消息缓存成功\n";
        [strMessage appendString:temp];
        [temp release];
    }
    else
    {
        temp = @"清空最新消息缓存失败\n";
        [strMessage appendString:temp];
        [temp release];

    }
    [tmpMessageDao release];

    TodoInfoDao *tmpTodoInfoDao = [[TodoInfoDao alloc]init];
    if ([tmpTodoInfoDao deleteAll])//清空待办事项缓存
    {
        temp = @"清空待办事项缓存成功\n";
        [strMessage appendString:temp];
        [temp release];

    }
    else
    {
        temp = @"清空待办事项缓存失败\n";
        [strMessage appendString:temp];
        [temp release];

    }
    [tmpTodoInfoDao release];
    
    MeetingDao *tmpMeetingDao = [[MeetingDao alloc]init];
    if ([tmpMeetingDao deleteAllMeetingInfo] && [tmpMeetingDao deleteAllOrg])//清空会议安排缓存
    {
        temp = @"清空会议安排缓存成功\n";
        [strMessage appendString:temp];
        [temp release];

    }
    else
    {
        temp = @"清空会议安排缓存失败\n";
        [strMessage appendString:temp];
        [temp release];

    }
    [tmpMeetingDao release];
//
//    
    ContactInfoDao *tmpContactInfoDao = [[ContactInfoDao alloc]init];
    if ([tmpContactInfoDao deleteAllContacts])//清空通讯录缓存
    {
        temp = @"清空通讯录缓存成功\n";
        [strMessage appendString:temp];
        [temp release];

    }
    else
    {
        temp = @"清空通讯录缓存失败\n";
        [strMessage appendString:temp];
        [temp release];

    }
    [tmpContactInfoDao release];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:strMessage delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
//    [strMessage release];

    [alert show];
    [alert release];
}


- (void) netWorkStatusWillEnabledViaWifi{
    [[SystemContext singletonInstance] setCurrentNetworkType:[ApiConfig networkTypeWifi]];
}

- (void) netWorkStatusWillEnabledViaWWAN{
    
    [[SystemContext singletonInstance] setCurrentNetworkType:[ApiConfig networkType3G]];
    if([[SystemContext singletonInstance] getRemindOf3G]){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"您正在使用数据网络数据网络" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void) netWorkStatusWillDisconnection{
    [[SystemContext singletonInstance] setCurrentNetworkType:[ApiConfig networkTypeNone]];

    
}

- (void) netWorkStatusWillChange:(NetworkStatus)status
{
	if (status == NotReachable)
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"您的网络现在为不可用状态！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        [alert release];
	}
}


#pragma mark - PrivateMethodImpelemtns
-(void)checkNetwork{
    //获取网络管理器
	NetWorkManager *manager = [NetWorkManager sharedManager];
	
	//设置网络管理器代理
	manager.delegate = self;
	
	//开始检测网络
    [manager startNetWorkeWatch];
    NetworkStatus * status = [manager checkNowNetWorkStatus];
    if (status == NotReachable) {
        [[SystemContext singletonInstance]setCurrentNetworkType:[ApiConfig networkTypeNone]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//														message:@"您的网络现在为不可用状态，请稍候再试！"
//													   delegate:nil
//											  cancelButtonTitle:@"确认" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
    }
    
//	if (!bStart)
//	{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//														message:@"您的网络现在为不可用状态，请稍候再试！"
//													   delegate:nil
//											  cancelButtonTitle:@"确认" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
//		
//	}
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            exit(1);
            break;
        case 1:
            exit(1);
            break;
        default:
            break;
    }
}

#pragma mark - Public Methods
- (void)showLoading {
    if (HUD != nil) {
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithWindow:self.window];
	[self.window addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"正在载入...";
    
    [HUD show:YES];
}

- (void)showLoadingWithText:(NSString *)text {
    if (HUD != nil) {
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithWindow:self.window];
	[self.window addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = text;
    
    [HUD show:YES];
}

- (void)showLoadingWithImage:(UIImage *)image andText:(NSString *)text {
    if (HUD != nil) {
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithWindow:self.window];
	[self.window addSubview:HUD];
    
    HUD.customView = [[[UIImageView alloc] initWithImage:image] autorelease];
    
    HUD.delegate = self;
	HUD.labelText = text;
    
    [HUD show:YES];
}

- (void)showToast:(NSString *)text hideAfterSecond:(NSInteger)second {
    if (HUD != nil) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
	hud.margin = 10.f;
	hud.yOffset = -100.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:second];
}

- (void)showLoadingWithText:(NSString *)text inView:(UIView *)view {
    if (HUD != nil) {
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = text;
    
    [HUD show:YES];
}

- (void)changeLoadingText:(NSString *)text {
    [HUD setLabelText:text];
}

- (void)closeLoading {
    [HUD hide:YES];
   //HUD = nil;
}

- (void)closeLoadingAfterSecond:(NSInteger)second {
    [HUD hide:YES afterDelay:second];
 //   HUD = nil;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

@end
