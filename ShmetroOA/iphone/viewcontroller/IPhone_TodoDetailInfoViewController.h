//
//  IPhone_TodoDetailInfoViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
#import "TodoInfo.h"
@interface IPhone_TodoDetailInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) id<TabbarViewControllerDelegate> tabbarDelegate;
@property (nonatomic, assign) id<DetailViewControllerDelegate> detailViewControllerDelegate;
@property (retain, nonatomic) IBOutlet UILabel *lab_todoName;
@property (retain, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,assign) TodoInfo *todoInfo;

- (IBAction)action_back:(id)sender;
- (IBAction)action_showNotice:(id)sender;
- (IBAction)action_process:(id)sender;

-(id)init:(TodoInfo *)todoInfoObj;


@end
