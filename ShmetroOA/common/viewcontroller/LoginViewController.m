//
//  LoginViewController.m
//  ShmetroOA
//
//  Created by caven shen on 10/8/12.
//
//

#import "LoginViewController.h"
#import "UserAccountService.h"
#import "UserAccountInfoDao.h"
#import "AppDelegate.h"
#import "SystemContext.h"
#import "ApiConfig.h"
@interface LoginViewController ()
-(void)action_datapickerSelected:(UIButton *)button;
@end

@implementation LoginViewController
@synthesize txt_userId;
@synthesize txt_userPass;
@synthesize sortPopover;
@synthesize deptArr;
@synthesize lab_deptId;
@synthesize sortPickerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:@"userId"]) {
        self.txt_userId.text= [userDefaults stringForKey:@"userId"];
    }
}

- (void)viewDidUnload
{
    [self setTxt_userId:nil];
    [self setTxt_userPass:nil];
    [self setLab_deptId:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)||(interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
}

- (void)dealloc {
    [deptArr release];
    [sortPopover release];
    [txt_userId release];
    [txt_userPass release];
    [lab_deptId release];
    [super dealloc];
}
- (IBAction)action_login:(id)sender {
    if (self.txt_userId.text==nil||[self.txt_userId.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if(self.txt_userPass.text==nil||[self.txt_userPass.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if(self.lab_deptId.text==nil||[self.lab_deptId.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请选择登陆部门" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
        if ([[[SystemContext singletonInstance] currentNetworkType] isEqualToString:[ApiConfig networkTypeNone]]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"您的网络目前为不可用状态，请确认是否连接到网络" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
           // return;
        }
        NSString *deptId = [[self.deptArr objectAtIndex:[self.sortPickerView selectedRowInComponent:0]] objectForKey:@"deptId"];
        UserAccountService *service = [[UserAccountService alloc]init];
        BOOL resp = [service userSignin:self.txt_userId.text UserPass:self.txt_userPass.text DeptId:deptId];
        [service release];
        if (resp) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:txt_userId.text forKey:@"userId"];
            [userDefaults synchronize];
            AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loginSuccess];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"用户登陆失败，请重试!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

- (IBAction)action_getDeptId:(UIButton *)sender {
    if ([[[SystemContext singletonInstance] currentNetworkType] isEqualToString:[ApiConfig networkTypeNone]]){
        UserAccountInfoDao *dao =[[[UserAccountInfoDao alloc]init]autorelease];
        self.deptArr = [dao getDeptArray:self.txt_userId.text];
    }else{
        UserAccountService *service = [[UserAccountService alloc]init];
        self.deptArr = [service getDeptArr:self.txt_userId.text];
        [service release];
    }
    if (self.deptArr!=nil&&[self.deptArr count]>0) {
        UIViewController *sortViewController = [[[UIViewController alloc] init] autorelease];
        //ios 7 bug
//        [sortViewController.view setBackgroundColor:[UIColor blackColor]];
        self.sortPickerView = [[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)] autorelease];
        [sortViewController.view addSubview:sortPickerView];
        
        UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnOK setFrame:CGRectMake(0, 216, 160, 44)];
        [btnOK setTitle:@"确认" forState:UIControlStateNormal];
        btnOK.tag = 1;
        UIButton *btnNO = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnNO setFrame:CGRectMake(160, 216, 160, 44)];
        [btnNO setTitle:@"取消" forState:UIControlStateNormal];
        btnNO.tag = 2;
        [btnOK addTarget:self action:@selector(action_datapickerSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btnNO addTarget:self action:@selector(action_datapickerSelected:) forControlEvents:UIControlEventTouchUpInside];
        [sortViewController.view addSubview:btnNO];
        [sortViewController.view addSubview:btnOK];
        
        
        sortPickerView.delegate = self;
        sortPickerView.dataSource = self;
        sortPickerView.showsSelectionIndicator = YES;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"\n\n\n\\n\n\n\\n\n\n\n\n\n\n"
                                                                      delegate:self
                                                             cancelButtonTitle:@"取消"
                                                        destructiveButtonTitle:@"确认"
                                                             otherButtonTitles:nil] autorelease];
            actionSheet.userInteractionEnabled = YES;
            [actionSheet addSubview:self.sortPickerView];
            [actionSheet showInView:self.view];
        } else {
            sortViewController.contentSizeForViewInPopover = CGSizeMake(320, 260);
            
            self.sortPopover = [[[UIPopoverController alloc] initWithContentViewController:sortViewController] autorelease];
            [self.sortPopover presentPopoverFromRect:CGRectMake(375, 60, 320, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"获取部门列表失败，请确认您的用户名是否填写正确" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}
#pragma mark - PrivateMethod
-(void)action_datapickerSelected:(UIButton *)button{
    if (button.tag==1) {
        [self.lab_deptId setText:[[self.deptArr objectAtIndex:[self.sortPickerView selectedRowInComponent:0]] objectForKey:@"deptName"]];
    }
    [self.sortPopover dismissPopoverAnimated:YES];
}


#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.deptArr==nil?0:[self.deptArr count];
}
#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[self.deptArr objectAtIndex:row] objectForKey:@"deptName"];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string] == YES){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    self.view.center = CGPointMake(160,200);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    self.view.center = CGPointMake(160,230);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.txt_userId isFirstResponder] && [touch view] != self.txt_userId) {
        [self.txt_userId resignFirstResponder];
    }
    if ([self.txt_userPass isFirstResponder] && [touch view] != self.txt_userPass) {
        [self.txt_userPass resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self.lab_deptId setText:[[self.deptArr objectAtIndex:[self.sortPickerView selectedRowInComponent:0]] objectForKey:@"deptName"]];
            break;
        case 2:
            
            break;
        default:
            break;
    }
}



@end
