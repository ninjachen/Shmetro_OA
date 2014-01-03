//
//  LoginViewController.h
//  ShmetroOA
//
//  Created by caven shen on 10/8/12.
//
//

#import <UIKit/UIKit.h>
@interface LoginViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>{
}
@property (retain, nonatomic) IBOutlet UITextField *txt_userId;
@property (retain, nonatomic) IBOutlet UITextField *txt_userPass;
@property (retain,nonatomic) UIPopoverController *sortPopover;
@property (nonatomic,retain) NSArray *deptArr;
@property (retain, nonatomic) IBOutlet UILabel *lab_deptId;
@property (nonatomic,retain) UIPickerView *sortPickerView;
- (IBAction)action_login:(id)sender;
- (IBAction)action_getDeptId:(UIButton *)sender;
@end
