//
//  IPad_ContactViewController.m
//  ShmetroOA
//
//  Created by gisteam on 6/9/13.
//
//

#import "IPad_ContactDetailViewController.h"
#import "TodoDetailTableviewCell.h"
#import "AppDelegate.h"
#import "STOService.h"

@interface IPad_ContactDetailViewController ()

@end

#define FONT_SIZE 27.0
@implementation IPad_ContactDetailViewController
@synthesize contactInfo,contactDetailTableView,btn_fullView,btn_smallView,btn_tips,contactDictionary,delegate,imgView_bg;
BOOL isFullScrren;

-(id)init:(ContactInfo *)contactInfoObj{
    self = [super init];
    if (self) {
        self.contactInfo = contactInfoObj;
    }
    isFullScrren = NO;
    return self;
}
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
	// Do any additional setup after loading the view.
}

-(void)viewDidUnload{
    [self setBtn_fullView:nil];
    [self setBtn_smallView:nil];
    [self setBtn_tips:nil];
    [self setContactDetailTableView:nil];
    [self setContactDictionary:nil];
    [self setContactInfo:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeScreen:(UIButton*)sender{

    switch (sender.tag) {
        case 1:
            if (self.delegate) {
                [self.delegate fullView];
            }
            
            [self.btn_fullView setHidden:YES];
            [self.btn_smallView setHidden:NO];
            [self.view setFrame:CGRectMake(0, 0, 1024, 748)];
            [self.imgView_bg setFrame:CGRectMake(0, 0, 1024, 748)];
            [self.imgView_bg setImage:[UIImage imageNamed:@"img_note.png"]];
            [self.btn_tips setFrame:CGRectMake(890, 52, 30, 30)];
            [self.btn_fullView setFrame:CGRectMake(928, 52, 30, 30)];
            [self.btn_smallView setFrame:CGRectMake(928, 52, 30, 30)];
            [self.contactDetailTableView setFrame:CGRectMake(0, 0, 920, 522)];
            
            isFullScrren = YES;
            break;
            
        case 2:
            if (self.delegate) {
                [self.delegate smallView];
            }
            [self.btn_fullView setHidden:NO];
            [self.btn_smallView setHidden:YES];
            [self.view setFrame:CGRectMake(0, 0, 678, 748)];
            [self.imgView_bg setFrame:CGRectMake(0, 0, 678, 748)];
            [self.imgView_bg setImage:[UIImage imageNamed:@"img_note_small.png"]];
            [self.btn_tips setFrame:CGRectMake(534, 52, 30, 30)];
            [self.btn_smallView setFrame:CGRectMake(572, 52, 30, 30)];
            [self.btn_fullView setFrame:CGRectMake(572, 52, 30, 30)];
            [self.contactDetailTableView setFrame:CGRectMake(0, 0, 580, 522)];
            
            isFullScrren = NO;
            break;
            
        default:
            break;
    }
    
    [self.contactDetailTableView reloadData];
}

-(IBAction)refreshData:(id)sender{
    AppDelegate *appDelegate =  (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showLoadingWithText:@"正在刷新..." inView:self.view];
    NSString *loginName = [self.contactInfo loginName];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STOService *service = [[STOService alloc]init];
        self.contactInfo =  [service refreshContactByLoginName:loginName];
        [service release];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contactDetailTableView reloadData];
            [appDelegate closeLoading];
            
        });
    });
}


#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger *row = [indexPath row];
    NSString *cellIdentifier=@"contactDetailCellIdentifier";
    TodoDetailTableviewCell *cell = (TodoDetailTableviewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[[TodoDetailTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    int int_row = row;
    switch (int_row) {
        case 0:
            [cell setHeadCell];
            [cell.lab_value setFont:[UIFont boldSystemFontOfSize: FONT_SIZE]];
            [cell.lab_value setText:[NSString stringWithFormat:@"%@(%@)",self.contactInfo.name,self.contactInfo.loginName]];
            break;
            
        case 1:
            [cell.lab_name setText:@"工号"];
            [cell.lab_value setText:[self.contactInfo uid]];
            break;
    
            
        case 2:
            [cell.lab_name setText:@"邮箱"];
            [cell.lab_value setText:[self.contactInfo email]==nil?@"":[self.contactInfo email]];
            break;
            
        case 3:
            [cell.lab_name setText:@"手机号码1"];
            [cell.lab_value setText:[self.contactInfo mobile1]];
            break;
            
        case 4:
            [cell.lab_name setText:@"手机号码2"];
            [cell.lab_value setText:[self.contactInfo mobile2]];
            break;
            
        case 5:
            [cell.lab_name setText:@"传真"];
            [cell.lab_value setText:[self.contactInfo fax]];
            break;
            
        case 6:
            [cell.lab_name setText:@"联系电话"];
            [cell.lab_value setText:[self.contactInfo phone]];
            break;
            
        case 7:
            [cell.lab_name setText:@"单位电话"];
            [cell.lab_value setText:[self.contactInfo cphone]];
            break;
            
        case 8:
            [cell.lab_name setText:@"工作单位"];
            [cell.lab_value setText:[self.contactInfo company]];
            break;
            
        case 9:
            [cell.lab_name setText:@"工作部门"];
            [cell.lab_value setText:[self.contactInfo dept]];
            break;
        default:
            break;
    }
    
//    if (isFullScrren) {
//        [cell useLong];
//    }else{
//        [cell useSmall];
//    }
    return cell;
}

#pragma mark -UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    
    return row==0?74:47;
}

-(void)dealloc{
    [contactInfo release];
    [contactDetailTableView release];
    [contactDictionary release];
    [btn_fullView release];
    [btn_smallView release];
    [btn_tips release];
    [imgView_bg release];
    [super dealloc];
}
@end
