//
//  ContactViewController.h
//  ShmetroOA
//
//  Created by gisteam on 6/8/13.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"

@interface ContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(retain,nonatomic)IBOutlet UITableView *contactTableView;
@property (retain, nonatomic) IBOutlet UITextField *txtField_search;
@property (retain, nonatomic) IBOutlet UIButton *btnDept;
@property (retain, nonatomic) IBOutlet UIButton *btnName;
@property (nonatomic, assign) id<MainViewControllerDelegate> mainViewDelegate;
@property(retain,nonatomic)NSArray *contactArray;

-(void)refreshContact;
-(void)searchContactsByDept:(NSString *)dept;
-(void)searchContactsByName:(NSString *)name;
-(IBAction)searchTabClick:(id)sender;
@end
