//
//  IPad_UserInfoDetailViewController.h
//  ShmetroOA
//
//  Created by gisteam on 6/18/13.
//
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface IPad_UserInfoDetailViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{

}

@property(nonatomic,retain)UserInfo *userInfo;
//@property (retain,nonatomic) UIPopoverController *sortPopover;
//@property(nonatomic,retain) UIDatePicker *birthdayPicker;
//@property(nonatomic,retain)UIPickerView *dataPickView;
//@property(nonatomic,retain)NSArray *dataArr;
//@property(nonatomic,retain)UITextField *selectedTextFiled;

@property(nonatomic,retain)IBOutlet UIView *view_infomation;
@property(nonatomic,retain)IBOutlet UIView *view_passwordnickname;
@property(nonatomic,retain)IBOutlet UIView *view_contact;
@property(nonatomic,retain)IBOutlet UIView *view_other;

@property(nonatomic,retain)IBOutlet UIButton *btnInfo;
@property(nonatomic,retain)IBOutlet UIButton *btnContact;
@property(nonatomic,retain)IBOutlet UIButton *btnOther;
@property(nonatomic,retain)IBOutlet UIButton *btnPassword;

@property(nonatomic,retain)IBOutlet UIButton *btnSave;
@property(nonatomic,retain)IBOutlet UIButton *btnRefresh;
@property(nonatomic,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblLoginName1;
@property(nonatomic,retain)IBOutlet UILabel *lblLoginName2;
@property(nonatomic,retain)IBOutlet UILabel *lblLoginName3;
@property(nonatomic,retain)IBOutlet UILabel *lblLoginName4;

@property(nonatomic,retain)IBOutlet UITextField *txtSex;
@property(nonatomic,retain)IBOutlet UITextField *txtZN;
@property(nonatomic,retain)IBOutlet UITextField *txtRetire;
@property(nonatomic,retain)IBOutlet UITextField *txtIdCard;
@property(nonatomic,retain)IBOutlet UITextField *txtBirthday;
@property(nonatomic,retain)IBOutlet UITextField *txtBirthplace;
@property(nonatomic,retain)IBOutlet UITextField *txtNation;
@property(nonatomic,retain)IBOutlet UITextField *txtPolitical;
@property(nonatomic,retain)IBOutlet UITextField *txtDegree;
@property(nonatomic,retain)IBOutlet UITextField *txtAddress;
@property(nonatomic,retain)IBOutlet UITextField *txtPostcode;
@property(nonatomic,retain)IBOutlet UITextField *txtPhone;
@property(nonatomic,retain)IBOutlet UITextField *txtMobile1;
@property(nonatomic,retain)IBOutlet UITextField *txtMobile2;
@property(nonatomic,retain)IBOutlet UITextField *txtEmail;
@property(nonatomic,retain)IBOutlet UITextField *txtCompany;
@property(nonatomic,retain)IBOutlet UITextField *txtDept;
@property(nonatomic,retain)IBOutlet UITextField *txtTitle;
@property(nonatomic,retain)IBOutlet UITextField *txtMajor;
@property(nonatomic,retain)IBOutlet UITextField *txtGrade;
@property(nonatomic,retain)IBOutlet UITextField *txtCaddress;
@property(nonatomic,retain)IBOutlet UITextField *txtCpostcode;
@property(nonatomic,retain)IBOutlet UITextField *txtCphone;
@property(nonatomic,retain)IBOutlet UITextField *txtRemark;
@property(nonatomic,retain)IBOutlet UITextField *txtRank;

@property(nonatomic,retain)IBOutlet UITextField *txtNickName2;
@property(nonatomic,retain)IBOutlet UITextField *txtNewPassword;
@property(nonatomic,retain)IBOutlet UITextField *txtConfirmPassword;

-(void)datePick;
-(void)dataPick:(UITextField*)txtFiled DataArray:(NSArray *)dataArr;

-(IBAction)saveUserInfoModify:(id)sender;
-(IBAction)refreshData:(id)sender;

-(IBAction)menu_select:(id)sender;

-(id)init:(UserInfo *)userInfoObj;
@end
