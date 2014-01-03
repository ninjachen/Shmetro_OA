//
//  SettingViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/2/12.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SettingViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,retain) UISwitch *vpnModeSwitch;
- (IBAction)action_back:(id)sender;
@end
