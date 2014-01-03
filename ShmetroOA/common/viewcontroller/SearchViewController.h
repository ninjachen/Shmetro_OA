//
//  SearchViewController.h
//  ShmetroOA
//
//  Created by caven shen on 10/30/12.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, assign) id<MainViewControllerDelegate> mainViewDelegate;
@property (retain, nonatomic) IBOutlet UITableView *tableview;
@property (retain, nonatomic) IBOutlet UITextField *ipad_textFieldSearch;
@end
