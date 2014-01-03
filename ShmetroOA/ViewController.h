//
//  ViewController.h
//  ShmetroOA
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
#import "IPhone_TabViewController.h"
@interface ViewController : UIViewController<MainViewControllerDelegate>



#pragma mark - iPhone
@property (retain, nonatomic) IBOutlet UIView *view_menu;
@property (retain, nonatomic) IBOutlet UIView *view_setting;
@property (retain,nonatomic) IPhone_TabViewController *iphoneTabListViewController;
- (IBAction)action_menuselected_iphone:(UIButton *)sender;
#pragma mark - iPad
@property (retain, nonatomic) IBOutlet UIView *view_listView;
@property (retain, nonatomic) IBOutlet UIView *view_detailView;
@property (retain, nonatomic) IBOutlet UIView *view_menuView;
@property (retain, nonatomic) IBOutlet UIImageView *img_menuSelect;
@property (retain, nonatomic) IBOutlet UIView *view_ipadMenu;
@property (retain, nonatomic) UIViewController *detailViewController;
@property (retain,nonatomic) UIViewController *currentListView;
@property (retain, nonatomic) IBOutlet UIView *view_menuSelect;
- (IBAction)action_menuSelected:(id)sender;


@end
