//
//  SettingAutoRefreshTimeViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/21/12.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
@interface SettingAutoRefreshTimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,assign) NSArray *selDataArr;
@property (nonatomic, assign) id<SettingViewControllerDelegate> settingDelegate;
- (IBAction)action_back:(id)sender;

-(id)init:(NSArray *)dataArr;
@end
