//
//  AppDelegate.h
//  ShmetroOA
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttachFileInfo.h"
#import "MBProgressHUD.h"
#import "NetWorkManager.h"
@class ViewController;
@class LoginViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,NetWorkManagerDelegate>{
     MBProgressHUD *HUD;
}

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)id<NetWorkManagerDelegate>delegate;
@property (strong, nonatomic) ViewController *viewController;
@property (strong,nonatomic) LoginViewController *loginViewController;
@property (nonatomic,retain) UINavigationController *navcontroller ;

-(void)loginSuccess;
-(void)userLogout;

- (void)showLoading;
- (void)showLoadingWithText:(NSString *)text;
- (void)showLoadingWithText:(NSString *)text inView:(UIView *)view;
- (void)showLoadingWithImage:(UIImage *)image andText:(NSString *)text;
- (void)showToast:(NSString *)text hideAfterSecond:(NSInteger)second;
- (void)changeLoadingText:(NSString *)text;
- (void)closeLoading;
- (void)closeLoadingAfterSecond:(NSInteger)second;
@end
