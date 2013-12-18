//
//  IPhone_TabViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/13/12.
//
//

#import <UIKit/UIKit.h>
#import "TodoListViewController.h"
#import "IPhone_MainScheduleViewController.h"
#import "IPhone_MainUserCenterViewController.h"
#import "IPhone_MainContactViewController.h"
#import "IPhone_MainMoreViewController.h"
#import "ShmetroOADelegate.h"
@interface IPhone_TabViewController : UITabBarController<TabbarViewControllerDelegate>

@property (nonatomic,retain) TodoListViewController *todoListViewController;
@property (nonatomic,retain) IPhone_MainScheduleViewController *scheduleViewController;
@property (nonatomic,retain) IPhone_MainUserCenterViewController *userCenterViewController;
@property (nonatomic,retain) IPhone_MainContactViewController *contactViewController;
@property (nonatomic,retain) IPhone_MainMoreViewController *moreViewController;

-(void)reloadControllers:(int)index;
@end
