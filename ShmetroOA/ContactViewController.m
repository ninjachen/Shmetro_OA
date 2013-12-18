//
//  ContactViewController.m
//  ShmetroOA
//
//  Created by gisteam on 6/8/13.
//
//

#import "ContactViewController.h"
#import "ContactTableViewCell.h"
#import "ContactInfo.h"
#import "STOService.h"
#import "UserAccountContext.h"
#import "ContactInfoDao.h"
#import "AppDelegate.h"

@interface ContactViewController ()

@end

NSString *searchIdentifier;
@implementation ContactViewController
@synthesize contactArray,contactTableView,mainViewDelegate;
@synthesize btnDept,btnName,txtField_search;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
            [super initWithNibName:@"ContactViewController_iPad" bundle:nil];
        }
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
   
}
-(void)viewDidAppear:(BOOL)animated{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    searchIdentifier = @"name";
    txtField_search.delegate = self;

    [self refreshContact];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [contactArray release];
    [contactTableView release];
    [btnName release];
    [btnDept release];
    [txtField_search release];
    [super dealloc];
}

-(void)refreshContact{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *dept = [[[UserAccountContext singletonInstance]userAccountInfo]deptName];
        STOService *service = [[STOService alloc]init];
        self.contactArray = [service searchContactsByDept:dept];
        [self.contactTableView reloadData];
        [appDelegate closeLoading];
        [service release];
    });
}

-(void)searchContactsByDept:(NSString *)dept{
    STOService *service = [[STOService alloc]init];
    if (dept == nil || [dept isEqualToString:@""]) {
        NSString *deptName = [[[UserAccountContext singletonInstance]userAccountInfo]deptName];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.contactArray = [service searchContactsByDept:deptName];
            [self.contactTableView reloadData];
            [self.contactTableView setContentOffset:CGPointMake(0, 0) animated:NO];
            [appDelegate closeLoading];
            [service release];
        });

    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.contactArray = [service searchContactsByDept:dept];
            [self.contactTableView reloadData];
            [self.contactTableView setContentOffset:CGPointMake(0, 0) animated:NO];
            [appDelegate closeLoading];
            [service release];
        });
    }
}
-(void)searchContactsByName:(NSString *)name{
    STOService *service = [[STOService alloc]init];
    if (name == nil || [name isEqualToString:@""]) {
        NSString *deptName = [[[UserAccountContext singletonInstance]userAccountInfo]deptName];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.contactArray = [service searchContactsByDept:deptName];
            [self.contactTableView reloadData];
            [self.contactTableView setContentOffset:CGPointMake(0, 0) animated:NO];
            [appDelegate closeLoading];
            [service release];
        });
        
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.contactArray = [service searchContactsByUserName:name];
            [self.contactTableView reloadData];
            [self.contactTableView setContentOffset:CGPointMake(0, 0) animated:NO];
            [appDelegate closeLoading];
            [service release];
        });
    }
}

-(IBAction)searchTabClick:(id)sender{
    UIButton *button = sender;
    
    if (button.tag == 1) {
        searchIdentifier = @"dept";
        [btnDept setImage:[UIImage imageNamed:@"dept_on.png"] forState:UIControlStateNormal];
        [btnName setImage:[UIImage imageNamed:@"name_off.png"] forState:UIControlStateNormal];
    }else{
        searchIdentifier = @"name";
        [btnDept setImage:[UIImage imageNamed:@"dept_off.png"] forState:UIControlStateNormal];
        [btnName setImage:[UIImage imageNamed:@"name_on.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contactArray ==nil?0:contactArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger *row = [indexPath row];
    static NSString *cellIdentifier = @"ContactTableViewCellIdentifier";
    ContactTableViewCell *cell = (ContactTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[[ContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
    }

    ContactInfo *contactInfo = [contactArray objectAtIndex:row];
    [cell.lblName setText:contactInfo.name];
    [cell.lblDept setText:contactInfo.dept];
    [cell.lblPhone setText:contactInfo.mobile1];

    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger *row = [indexPath row];
    ContactInfo *contactInfo = [contactArray objectAtIndex:row];    
    if (mainViewDelegate) {
        [mainViewDelegate viewDetail_iPad:contactInfo];
    }
}

#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSString *searchText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([searchIdentifier isEqualToString:@"dept"]) {
        [self searchContactsByDept:searchText];
    }else{
        [self searchContactsByName:searchText];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
@end
