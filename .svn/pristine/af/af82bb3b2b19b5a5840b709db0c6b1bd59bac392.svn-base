//
//  SettingViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/2/12.
//
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "UserAccountContext.h"
#import "SettingAutoRefreshTimeViewController.h"
#import "SystemContext.h"
#import "HelpViewController.h"
@interface SettingViewController (PrivateMethod)
+(NSString *)reuseIdentifier_help;
+(NSString *)reuseIdentifier_vpn;
+(NSString *)reuseIdentifier_autoRefresh;
+(NSString *)reuseIdentifier_signinUser;
+(NSString *)reuseIdentifier_signOut;
+(NSString *)reuseIdentifier_checkAppUpdate;
-(void)action_userSignOut:(UIButton *)btn;
-(void)action_appCheckUpdate:(UIButton *)btn;
-(void)changeVpnSetting:(UISwitch *)obj;
@end

@implementation SettingViewController
@synthesize tableview;
@synthesize vpnModeSwitch;
NSArray *autoRefreshTimeNameArr;
NSArray *autoRefreshTimeValueArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self = [super initWithNibName:@"SettingViewController_iPhone" bundle:nil];
    } else {
        self = [super initWithNibName:@"SettingViewController_iPad" bundle:nil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    autoRefreshTimeNameArr = [[NSArray alloc]initWithObjects:@"3分钟",@"5分钟",@"15分钟",@"30分钟",@"60分钟", nil];
    autoRefreshTimeValueArr = [[NSArray alloc]initWithObjects:@"3",@"5",@"15",@"30",@"60", nil];
    [self.tableview setBackgroundView:nil];
    [self.tableview setBackgroundView:[[[UIView alloc] init] autorelease]];
    self.vpnModeSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
    [self.vpnModeSwitch addTarget:self action:@selector(changeVpnSetting:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    [tableview release];
    [vpnModeSwitch release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int resp = 0;
    switch (section) {
        case 0:
            resp =1;
            break;
            
        default:
            resp =1;
            break;
    }
    return resp;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    int row = [indexPath row];
    switch ([indexPath section]) {
        case 0:{
            switch (row) {
//                case 0:{
//                    cell = [tableView dequeueReusableCellWithIdentifier:[SettingViewController reuseIdentifier_vpn]];
//                    if (cell==nil) {
//                        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[SettingViewController reuseIdentifier_vpn]] autorelease];
//                        [cell.contentView setBackgroundColor:[UIColor clearColor]];
//                        [cell setBackgroundColor:[UIColor clearColor]];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.accessoryView = self.vpnModeSwitch;
//                    [cell.textLabel setText:@"VPN连接设置"];
//                    break;
//                }
                case 0:{
                    cell = [tableView dequeueReusableCellWithIdentifier:[SettingViewController reuseIdentifier_autoRefresh]];
                    if (cell==nil) {
                        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[SettingViewController reuseIdentifier_autoRefresh]] autorelease];
                        [cell.contentView setBackgroundColor:[UIColor clearColor]];
                        [cell setBackgroundColor:[UIColor clearColor]];
                        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                        [cell.textLabel setText:@"自动刷新"];
                    }
                    [cell.detailTextLabel setText:[autoRefreshTimeNameArr objectAtIndex:[autoRefreshTimeValueArr indexOfObject:[[SystemContext singletonInstance] getAutoRefreshTime]]]];
                    break;
                }
                default:
                    break;
            }
             break;
        }
        case 1:{
            switch (row) {
                case 0:{
                    cell = [tableView dequeueReusableCellWithIdentifier:[SettingViewController reuseIdentifier_signinUser]];
                    if (cell==nil) {
                        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[SettingViewController reuseIdentifier_signinUser]] autorelease];
                        [cell.contentView setBackgroundColor:[UIColor clearColor]];
                        [cell setBackgroundColor:[UIColor clearColor]];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        [cell.textLabel setText:@"登录用户"];
                    }
                    [cell.detailTextLabel setText:[[[UserAccountContext singletonInstance]userAccountInfo]userName]];
                    break;
                }
                default:
                    break;
            }
             break;
        }
        case 2:{
            switch (row) {
                case 0:{
                    cell = [tableView dequeueReusableCellWithIdentifier:[SettingViewController reuseIdentifier_signOut]];
                    if (cell==nil) {
                        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SettingViewController reuseIdentifier_signOut]] autorelease];
                        [cell.contentView setBackgroundColor:[UIColor clearColor]];
                        [cell setBackgroundColor:[UIColor clearColor]];
//                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                        [btn setBackgroundImage:[UIImage imageNamed:@"iphone_bt_2_off.png"] forState:UIControlStateNormal];
//                        [btn setBackgroundImage:[UIImage imageNamed:@"iphone_bt_2_on.png"] forState:UIControlStateHighlighted];
//                        [btn addTarget:self action:@selector(userSignOut:) forControlEvents:UIControlEventTouchUpInside];
//                        [btn setFrame:CGRectMake(0, 0, 295, 40)];
//                        [cell.contentView addSubview:btn];
                        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                        [cell.textLabel setText:@"注销登录"];
                    }
                    break;
                }
                    
                default:
                    break;
            }
             break;
        }
        case 3:{
            switch (row) {
                case 0:{
                    cell = [tableView dequeueReusableCellWithIdentifier:[SettingViewController reuseIdentifier_help]];
                    if (cell==nil) {
                        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SettingViewController reuseIdentifier_help]] autorelease];
                        [cell.contentView setBackgroundColor:[UIColor clearColor]];
                        [cell setBackgroundColor:[UIColor clearColor]];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        [cell.textLabel setText:@"帮助"];
                    }
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 4:{
            switch (row) {
                case 0:{
                    cell = [tableView dequeueReusableCellWithIdentifier:[SettingViewController reuseIdentifier_checkAppUpdate]];
                    if (cell==nil) {
                        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SettingViewController reuseIdentifier_checkAppUpdate]] autorelease];
                        [cell.contentView setBackgroundColor:[UIColor clearColor]];
                        [cell setBackgroundColor:[UIColor clearColor]];
//                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                        [btn setBackgroundImage:[UIImage imageNamed:@"iphone_bt_3_off.png"] forState:UIControlStateNormal];
//                        [btn setBackgroundImage:[UIImage imageNamed:@"iphone_bt_3_on.png"] forState:UIControlStateHighlighted];
//                        
//                        [btn addTarget:self action:@selector(action_appCheckUpdate:) forControlEvents:UIControlEventTouchUpInside];
//                        [btn setFrame:CGRectMake(0, 0, 295, 40)];
//                        [cell.contentView addSubview:btn];
                        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                        [cell.textLabel setText:@"检查更新"];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *resp = nil;
    switch (section) {
        case 0:
            resp = @"系统设置";
            break;
        case 1:
            resp = @"账户设置";
            break;
        case 3:
            resp = @"其他";
            break;
        default:
            break;
    }
    return resp;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:
        case 3:{
            return 40;
            break;
        }
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ([indexPath section]) {
        case 0:{
            switch ([indexPath row]) {
                case 0:{
                    //自动刷新设置
                    SettingAutoRefreshTimeViewController *autoRefreshTimeViewController = [[SettingAutoRefreshTimeViewController alloc]init:autoRefreshTimeNameArr];
                    autoRefreshTimeViewController.settingDelegate = self;
                    [self.navigationController pushViewController:autoRefreshTimeViewController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch ([indexPath row]) {
                case 0:{
                    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate userLogout];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        case 3:{
            switch ([indexPath row]) {
                case 0:{
                    //帮助
                    HelpViewController *helpController = [[[HelpViewController alloc]init]autorelease];
                    [self.navigationController pushViewController:helpController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 4:{
            switch ([indexPath row]) {
                case 0:{
                    
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - PrivateMethod
+(NSString *)reuseIdentifier_help{
    return @"SettingViewController_help";
}
+(NSString *)reuseIdentifier_vpn{
    return @"SettingViewController_vpn";
}
+(NSString *)reuseIdentifier_autoRefresh{
    return @"SettingViewController_autoRefresh";
}
+(NSString *)reuseIdentifier_signinUser{
    return @"SettingViewController_signinUser";
}
+(NSString *)reuseIdentifier_signOut{
    return @"SettingViewController_signOut";
    return [NSString stringWithFormat:@"%@_signOUt",NSStringFromClass([self class])];
}
+(NSString *)reuseIdentifier_checkAppUpdate{
    return @"SettingViewController_checkPppUpdate";
}
- (IBAction)action_back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)action_userSignOut:(UIButton *)btn{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate userLogout];
}

-(void)changeVpnSetting:(UISwitch *)obj{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network/VPN"]];
    NSURL*url=[NSURL URLWithString:@"prefs:root=General&path=Network/VPN"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - SettingViewControllerDelegate
-(void)setAutoRefreshTime:(int)index{
    UITableViewCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell.detailTextLabel setText:[autoRefreshTimeNameArr objectAtIndex:index]];
    [[SystemContext singletonInstance] resetAutoRefreshTime:[autoRefreshTimeValueArr objectAtIndex:index]];
}
@end
