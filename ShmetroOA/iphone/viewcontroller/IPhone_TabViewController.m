//
//  IPhone_TabViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/13/12.
//
//

#import "IPhone_TabViewController.h"

@interface IPhone_TabViewController ()


@end

@implementation IPhone_TabViewController
@synthesize todoListViewController;
@synthesize scheduleViewController,userCenterViewController,contactViewController,moreViewController;
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
    [self hiddenTabbar:NO];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"iphone_bg_tab.png"]];
    
    IPhone_MainScheduleViewController *scheduleViewCtl = [[IPhone_MainScheduleViewController alloc]init];
    UITabBarItem *scheduleViewTabbarItem = [[UITabBarItem alloc] init];
    scheduleViewTabbarItem.tag = 1;
    [scheduleViewTabbarItem setFinishedSelectedImage:[UIImage imageNamed:@"iphone_ic_tab1_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iphone_ic_tab1_off.png"]];
    [scheduleViewTabbarItem setTitle:@"日程安排"];
    [scheduleViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor whiteColor], UITextAttributeTextColor,
                                                    nil] forState:UIControlStateNormal];
    [scheduleViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor colorWithRed:19.0f/255.0f green:36.0f/255.0f blue:70.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                    nil] forState:UIControlStateSelected];
    scheduleViewCtl.tabbarDelegate = self;
    scheduleViewCtl.tabBarItem = scheduleViewTabbarItem;
    self.scheduleViewController = scheduleViewCtl;
    
	TodoListViewController *todoListViewCtl = [[TodoListViewController alloc] init];
    todoListViewCtl.tabbarDelegate = self;
    UITabBarItem *todoListTabbarItem = [[UITabBarItem alloc] init];
    todoListTabbarItem.tag = 2;
    [todoListTabbarItem setFinishedSelectedImage:[UIImage imageNamed:@"iphone_ic_tab2_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iphone_ic_tab2_off.png"]];
    [todoListTabbarItem setTitle:@"待办事项"];
    [todoListTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor whiteColor], UITextAttributeTextColor,
                                                    nil] forState:UIControlStateNormal];
    [todoListTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor colorWithRed:19.0f/255.0f green:36.0f/255.0f blue:70.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                    nil] forState:UIControlStateSelected];
    todoListViewCtl.tabBarItem = todoListTabbarItem;
    self.todoListViewController = todoListViewCtl;
    
    
    
    IPhone_MainUserCenterViewController *userCenterViewCtl = [[IPhone_MainUserCenterViewController alloc]init];
    UITabBarItem *ucenterViewTabbarItem = [[UITabBarItem alloc] init];
    ucenterViewTabbarItem.tag = 3;
    [ucenterViewTabbarItem setFinishedSelectedImage:[UIImage imageNamed:@"iphone_ic_tab3_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iphone_ic_tab3_off.png"]];
    [ucenterViewTabbarItem setTitle:@"个人中心"];
    [ucenterViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor whiteColor], UITextAttributeTextColor,
                                                nil] forState:UIControlStateNormal];
    [ucenterViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithRed:19.0f/255.0f green:36.0f/255.0f blue:70.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                nil] forState:UIControlStateSelected];
    userCenterViewCtl.tabbarDelegate = self;
    userCenterViewCtl.tabBarItem = ucenterViewTabbarItem;
    self.userCenterViewController = userCenterViewCtl;
    
    
    IPhone_MainContactViewController *contactViewCtl = [[IPhone_MainContactViewController alloc]init];
    UITabBarItem *contactViewTabbarItem = [[UITabBarItem alloc] init];
    contactViewTabbarItem.tag = 4;
    [contactViewTabbarItem setFinishedSelectedImage:[UIImage imageNamed:@"iphone_ic_tab4_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iphone_ic_tab4_off.png"]];
    [contactViewTabbarItem setTitle:@"通讯录"];
    [contactViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                   nil] forState:UIControlStateNormal];
    [contactViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:19.0f/255.0f green:36.0f/255.0f blue:70.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                   nil] forState:UIControlStateSelected];
    contactViewCtl.tabBarItem = contactViewTabbarItem;
    contactViewCtl.tabbarDelegate = self;
    self.contactViewController = contactViewCtl;
    
    
    IPhone_MainMoreViewController *moreViewCtl = [[IPhone_MainMoreViewController alloc]init];
    UITabBarItem *moreViewTabbarItem = [[UITabBarItem alloc] init];
    moreViewTabbarItem.tag = 5;
    [moreViewTabbarItem setFinishedSelectedImage:[UIImage imageNamed:@"iphone_ic_tab5_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iphone_ic_tab5_off.png"]];
    [moreViewTabbarItem setTitle:@"更多"];
    [moreViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                   nil] forState:UIControlStateNormal];
    [moreViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:19.0f/255.0f green:36.0f/255.0f blue:70.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                   nil] forState:UIControlStateSelected];
    moreViewCtl.tabbarDelegate = self;
    moreViewCtl.tabBarItem = moreViewTabbarItem;
    [moreViewTabbarItem release];
    self.moreViewController = moreViewCtl;
    
    self.viewControllers = [NSArray arrayWithObjects:scheduleViewCtl,todoListViewCtl,userCenterViewCtl,contactViewCtl,moreViewCtl, nil];
    
    [scheduleViewCtl release];
    [scheduleViewTabbarItem release];
    [todoListViewCtl release];
    [todoListTabbarItem release];
    [userCenterViewCtl release];
    [ucenterViewTabbarItem release];
    [contactViewCtl release];
    [contactViewTabbarItem release];
    [moreViewCtl release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)viewDidAppear:(BOOL)animated{
    
    [self showTabbar:YES];
    [self reloadControllers:self.selectedIndex+1];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)dealloc{
    
    [todoListViewController release];
    [scheduleViewController release];
    [userCenterViewController release];
    [contactViewController release];
    [moreViewController release];
    [super dealloc];
}

#pragma mark - TabbarViewControllerDelegate
-(void)hiddenTabbar:(BOOL)animation{
    if (animation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6];
        [self.tabBar setFrame:CGRectMake(0, 480, 320, 49)];
        [UIView commitAnimations];
    }else{
        [self.tabBar setFrame:CGRectMake(0, 480, 320, 49)];
    }
}
-(void)showTabbar:(BOOL)animation{
    if (animation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6];
        [self.tabBar setFrame:CGRectMake(0, 431, 320, 49)];
        [UIView commitAnimations];
    }else{
        [self.tabBar setFrame:CGRectMake(0, 431, 320, 49)];
    }
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
  //  [self reloadControllers:item.tag];
}

-(void)reloadControllers:(int)index{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    switch (index) {
        case 1:
            [self.scheduleViewController viewWillAppear:YES];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.scheduleViewController viewDidAppear:YES];
            });
            break;
        case 2:
            [self.todoListViewController viewWillAppear:YES];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.todoListViewController viewDidAppear:YES];
            });
            break;
        case 3:
            [self.userCenterViewController viewWillAppear:YES];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.userCenterViewController viewDidAppear:YES];
            });
            break;
        case 4:
            [self.contactViewController viewWillAppear:YES];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.contactViewController viewDidAppear:YES];
            });
            break;
        case 5:
            [self.moreViewController viewWillAppear:YES];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.moreViewController viewDidAppear:YES];
            });
            break;
        default:
            break;
    }
}
@end
