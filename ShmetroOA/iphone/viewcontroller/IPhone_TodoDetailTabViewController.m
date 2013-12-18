//
//  IPhone_TodoDetailTabViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import "IPhone_TodoDetailTabViewController.h"
#import "IPhone_TodoProcessViewController.h"
@interface IPhone_TodoDetailTabViewController ()

@end

@implementation IPhone_TodoDetailTabViewController
@synthesize todoInfo;
@synthesize infoViewController,attachFileViewController,approveViewController,monitorViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init:(TodoInfo *)todoInfoObj{
    self = [super init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (self) {
        self.todoInfo = todoInfoObj;
        
        [self hiddenTabbar:NO];
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"iphone_bg_tab.png"]];
        
        IPhone_TodoDetailInfoViewController *infoViewCtl = [[IPhone_TodoDetailInfoViewController alloc]init:self.todoInfo];
        UITabBarItem *infoViewTabbarItem = [[UITabBarItem alloc] init];
        infoViewTabbarItem.tag = 1;
        
        [infoViewTabbarItem setFinishedSelectedImage:[UIImage imageNamed:@"iphone_ic_tab8_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iphone_ic_tab8_off.png"]];
        [infoViewTabbarItem setTitle:@"基本信息"];
        [infoViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor whiteColor], UITextAttributeTextColor,
                                                    nil] forState:UIControlStateNormal];
        [infoViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor colorWithRed:19.0f/255.0f green:36.0f/255.0f blue:70.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                    nil] forState:UIControlStateSelected];
        infoViewCtl.tabbarDelegate = self;
        infoViewCtl.detailViewControllerDelegate = self;
        infoViewCtl.tabBarItem = infoViewTabbarItem;
        self.infoViewController = infoViewCtl;
        
        
        IPhone_TodoDetailAttachFileViewController *attachFileViewCtl = [[IPhone_TodoDetailAttachFileViewController alloc]init:todoInfo];
        UITabBarItem *attachFileViewTabbarItem = [[UITabBarItem alloc] init];
        attachFileViewTabbarItem.tag = 2;
        [attachFileViewTabbarItem setFinishedSelectedImage:[UIImage imageNamed:@"iphone_ic_tab7_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iphone_ic_tab7_off.png"]];
        [attachFileViewTabbarItem setTitle:@"附件列表"];
        [attachFileViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], UITextAttributeTextColor,
                                                          nil] forState:UIControlStateNormal];
        [attachFileViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:19.0f/255.0f green:36.0f/255.0f blue:70.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                          nil] forState:UIControlStateSelected];
        attachFileViewCtl.tabBarItem = attachFileViewTabbarItem;
        attachFileViewCtl.tabbarDelegate = self;
        attachFileViewCtl.detailViewControllerDelegate = self;
        self.attachFileViewController = attachFileViewCtl;
        
        
        IPhone_TodoDetailApproveViewController *approveViewCtl = [[IPhone_TodoDetailApproveViewController alloc]init:todoInfo];
        UITabBarItem *approveViewTabbarItem = [[UITabBarItem alloc] init];
        approveViewTabbarItem.tag = 3;
        [approveViewTabbarItem setFinishedSelectedImage:[UIImage imageNamed:@"iphone_ic_tab6_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iphone_ic_tab6_off.png"]];
        [approveViewTabbarItem setTitle:@"流转意见"];
        [approveViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
        [approveViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:19.0f/255.0f green:36.0f/255.0f blue:70.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
        approveViewCtl.tabbarDelegate = self;
        approveViewCtl.detailViewControllerDelegate = self;
        approveViewCtl.tabBarItem = approveViewTabbarItem;
        self.approveViewController = approveViewCtl;
        
        
        IPhone_TodoDetailMonitorViewController *monitorViewCtl = [[IPhone_TodoDetailMonitorViewController alloc]init:todoInfo];
        UITabBarItem *monitorViewTabbarItem = [[UITabBarItem alloc] init];
        monitorViewTabbarItem.tag = 4;
        [monitorViewTabbarItem setFinishedSelectedImage:[UIImage imageNamed:@"iphone_ic_tab9_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iphone_ic_tab9_off.png"]];
        [monitorViewTabbarItem setTitle:@"业务监控"];
        [monitorViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
        [monitorViewTabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:19.0f/255.0f green:36.0f/255.0f blue:70.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
        monitorViewCtl.tabBarItem = monitorViewTabbarItem;
        [monitorViewTabbarItem release];
        monitorViewCtl.tabbarDelegate = self;
        monitorViewCtl.detailViewControllerDelegate = self;
        self.monitorViewController = monitorViewCtl;
        
        self.viewControllers = [NSArray arrayWithObjects:infoViewCtl,attachFileViewCtl,approveViewCtl,monitorViewCtl, nil];
        
        [infoViewCtl release];
        [infoViewTabbarItem release];
        [attachFileViewCtl release];
        [attachFileViewTabbarItem release];
        [approveViewCtl release];
        [approveViewTabbarItem release];
        [monitorViewCtl release];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	

    
    
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
    [infoViewController release];
    [attachFileViewController release];
    [approveViewController release];
    [monitorViewController release];
//    [self.infoViewController release];
//    [self.attachFileViewController release];
//    [self.approveViewController release];
//    [self.monitorViewController release];
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

#pragma mark - DetailViewControllerDelegate
-(void)processTodo:(TodoInfo *)todoObj{
    IPhone_TodoProcessViewController *todoProcessConroller = [[[IPhone_TodoProcessViewController alloc]init:todoObj] autorelease];
    [self.navigationController pushViewController:todoProcessConroller animated:YES];
}

#pragma mark - public method
-(void)reloadControllers:(int)index{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    switch (index) {
        case 1:
            [self.infoViewController viewWillAppear:YES];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.infoViewController viewDidAppear:YES];
            });
            break;
        case 2:
            [self.attachFileViewController viewWillAppear:YES];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.attachFileViewController viewDidAppear:YES];
            });
            break;
        case 3:
            [self.approveViewController viewWillAppear:YES];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.approveViewController viewDidAppear:YES];
            });
            break;
        case 4:
            [self.monitorViewController viewWillAppear:YES];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.monitorViewController viewDidAppear:YES];
            });
            break;
        default:
            break;
    }
}


@end
