//
//  ViewController.m
//  ShmetroOA
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "TodoListViewController.h"
#import "UserAccountContext.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "SettingViewController.h"
#import "ContactViewController.h"
#import "MessageViewController.h"
#import "IPad_TodoDetailViewController.h"
#import "IPad_ContactDetailViewController.h"
#import "IPad_MessageDetailViewController.h"
#import "IPad_UserInfoDetailViewController.h"
#import "IPad_MeetingInfoViewController.h"
#import "IPad_WorkflowViewController.h"
#import "FileReaderViewController.h"
#import "ContactInfo.h"
#import "MessageDetailInfo.h"
#import "STOService.h"
#import "UserInfoDao.h"

@interface ViewController (iPhonePrivateMethods)
-(void)initIPhoneView;
@end
@interface ViewController (iPadPrivateMethods)
-(void)initIPadView;
-(void)listViewReload;
-(void)menuSelectMove;
-(UserInfo *)refreshUserInfo;
@end

@implementation ViewController
#pragma mark - iphone synthesize
@synthesize iphoneTabListViewController;
#pragma mark - ipad synthesize
@synthesize view_menu;
@synthesize view_setting;
@synthesize view_listView;
@synthesize view_detailView;
@synthesize view_menuView;
@synthesize img_menuSelect;
@synthesize view_ipadMenu;
@synthesize detailViewController;
@synthesize currentListView;
@synthesize view_menuSelect;
int currentSelectMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        
    } else {
        [self initIPadView];
    }
}

- (void)viewDidUnload
{
    [self setView_listView:nil];
    [self setView_detailView:nil];
    [self setView_menuView:nil];
    [self setImg_menuSelect:nil];
    [self setView_ipadMenu:nil];
    [self setView_menuSelect:nil];
    [self setView_menu:nil];
    [self setView_setting:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self initIPhoneView];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft)&&(interfaceOrientation != UIInterfaceOrientationLandscapeRight);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
}

- (void)dealloc {
    [iphoneTabListViewController release];
    [detailViewController release];
    [view_listView release];
    [view_detailView release];
    [view_menuView release];
    [img_menuSelect release];
    [view_ipadMenu release];
    [view_menuSelect release];
    [view_menu release];
    [view_setting release];
    [super dealloc];
}
#pragma mark - iphoneAction
- (IBAction)action_menuselected_iphone:(UIButton *)sender {
    switch (sender.tag) {
        //1、日程安排
        //2、待办事项
        //3、个人中心
        //4、通讯录
        //5、更多
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:{
            if(!self.iphoneTabListViewController)
                self.iphoneTabListViewController  = [[[IPhone_TabViewController alloc]init] autorelease];
            [self.navigationController pushViewController:iphoneTabListViewController animated:YES];
            iphoneTabListViewController.selectedIndex = sender.tag;
            
            break;
        }
        //最新消息
        case 6:{
            
            break;
        }
        //设置
        case 7:{
            SettingViewController *settingViewController = [[[SettingViewController alloc]init]autorelease];
            [self.navigationController pushViewController:settingViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - ipadActon
- (IBAction)action_menuSelected:(id)sender {
    if (![[UserAccountContext singletonInstance] isSign]) {
        
        return;
    }
    int btnTag = ((UIButton *)sender).tag;
    if (currentListView!=nil&&currentListView.view.tag==btnTag) {
        
        return;
    }else{
        if (detailViewController!=nil) {
            [detailViewController.view removeFromSuperview];
            [detailViewController release];
            detailViewController = nil;
        }
        if (currentListView!=nil) {
            [currentListView.view removeFromSuperview];
            [currentListView release];
            currentListView = nil;
        }
        
    }
    
    
    currentSelectMenu = btnTag;
    switch (btnTag) {
        
        //搜索
        case 1:{
            if (currentListView==nil) {
                [self largeMenuView];
                SearchViewController *tmpSearchViewController = [[SearchViewController alloc]init];
                tmpSearchViewController.mainViewDelegate = self;
                self.currentListView = tmpSearchViewController;
                [view_listView addSubview:currentListView.view];
                [tmpSearchViewController release];
            }
            break;
        }
        //待办事项
        case 2:{
            if (currentListView==nil) {
                [self largeMenuView];
                TodoListViewController *tmpTotoListViewController  = [[TodoListViewController alloc]init];
                tmpTotoListViewController.mainViewDelegate = self;
                self.currentListView = tmpTotoListViewController;
                [view_listView addSubview:currentListView.view];
                [tmpTotoListViewController release];
            }
            break;
        }
        //日程管理
        case 3:{
            if (self.detailViewController!=nil) {
                [detailViewController.view removeFromSuperview];
            }
            [self largeDetailView];
            [self smallMenuView];
            IPad_MeetingInfoViewController *tmpMeetingInfoViewController = [[IPad_MeetingInfoViewController alloc]init];
            self.detailViewController = tmpMeetingInfoViewController;
            [view_detailView addSubview:self.detailViewController.view];
            [tmpMeetingInfoViewController release];
            
            break;
        }
        //通讯录
        case 4:{
            if (currentListView==nil) {
                [self largeMenuView];
                ContactViewController *tmpContactViewController = [[ContactViewController alloc]init];
                tmpContactViewController.mainViewDelegate=self;
                self.currentListView = tmpContactViewController;
                
                [view_listView addSubview:currentListView.view];
                [tmpContactViewController release];
            }
            
            break;
        }
        //消息中心
        case 5:{
            if (currentListView==nil) {
                [self largeMenuView];
                MessageViewController *tmpMessageViewController = [[MessageViewController alloc]init];
                tmpMessageViewController.mainViewDelegate=self;
                self.currentListView = tmpMessageViewController;
                [view_listView addSubview:currentListView.view];
                [tmpMessageViewController release];
            }
            
            break;
        }
        //个人中心
        case 6:{   
            if (self.detailViewController!=nil) {
                [detailViewController.view removeFromSuperview];
            }
            [self largeDetailView];
            [self smallMenuView];
            IPad_UserInfoDetailViewController *tmpUserInfoViewController =[[IPad_UserInfoDetailViewController alloc]init];
            self.detailViewController = tmpUserInfoViewController;
            [view_detailView addSubview:self.detailViewController.view];
            [tmpUserInfoViewController release];
            
            break;
        }
        //更多
        case 7:{
            
            break;
        }
        //设置
        case 8:{
            if (currentListView==nil) {
                [self largeMenuView];
                SettingViewController *tmpSettingViewController  = [[[SettingViewController alloc]init] autorelease];
                UINavigationController *navController = [[[UINavigationController alloc]initWithRootViewController:tmpSettingViewController] autorelease];
                [navController.view setFrame:CGRectMake(0, 0, 289, 748)];
                [navController setNavigationBarHidden:YES];
                self.currentListView = navController;
                [view_listView addSubview:navController.view];
            }
            break;
        }
        default:
            break;
    }
    currentListView.view.tag = btnTag;
    [self listViewReload];
}

#pragma mark - iPhonePrivateMethod Implements
-(void)initIPhoneView{
    

}
#pragma mark - iPadPrivateMethod Implements
-(void)initIPadView{
    currentSelectMenu = 0;
}
-(void)listViewReload{
    [self.view_listView setFrame:CGRectMake(-338, 0, 289, 748)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [self.view_listView setFrame:CGRectMake(65, 0, 289, 748)];
    [UIView commitAnimations];
    [self menuSelectMove];
}

-(void)menuSelectMove{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view_menuSelect setFrame:CGRectMake(0, 65*(currentSelectMenu - 1), 65, 65)];
    [UIView commitAnimations];
    switch (currentSelectMenu) {
        case 1:
            [self.img_menuSelect setImage:[UIImage imageNamed:@"bg_left_arrow_on_2.png"]];
            break;
        case 2:
        case 8:
            [self.img_menuSelect setImage:[UIImage imageNamed:@"bg_left_arrow_on_1.png"]];
            break;
        default:
            [self.img_menuSelect setImage:[UIImage imageNamed:@"bg_left_arrow_on_3.png"]];
            break;
    }
    
}

#pragma mark - MainViewControllerDelegate
-(void)viewDetail_iPad:(id)obj{
    if ([obj isKindOfClass:[TodoInfo class]]) {
        if (self.detailViewController!=nil) {
            [detailViewController.view removeFromSuperview];
        }
        [self smallDetailView];
        IPad_TodoDetailViewController *tmpTodoDetailViewController = [[IPad_TodoDetailViewController alloc]init:obj];
      //  IPad_WorkflowViewController *tmpTodoDetailViewController = [[IPad_WorkflowViewController alloc]init];
        tmpTodoDetailViewController.delegate = self;
        self.detailViewController = tmpTodoDetailViewController;
        [self.view_detailView addSubview:self.detailViewController.view];
        [tmpTodoDetailViewController release];
        
    }else if([obj isKindOfClass:[WorkflowInfo class]]){
        if (self.detailViewController!=nil) {
            [detailViewController.view removeFromSuperview];
        }
        [self smallDetailView];
        IPad_WorkflowViewController *tmpWorkflowDetailViewController = [[IPad_WorkflowViewController alloc]init:obj];
        tmpWorkflowDetailViewController.delegate = self;
        self.detailViewController = tmpWorkflowDetailViewController;
        [self.view_detailView addSubview:self.detailViewController.view];
        [tmpWorkflowDetailViewController release];
        
    }else if([obj isKindOfClass:[ContactInfo class]]){
        if (self.detailViewController!=nil) {
            [detailViewController.view removeFromSuperview];
        }
        [self smallDetailView];
        IPad_ContactDetailViewController *tmpContactDetailViewController = [[IPad_ContactDetailViewController alloc]init:obj];
        tmpContactDetailViewController.delegate=self;
        self.detailViewController=tmpContactDetailViewController;
        [self.view_detailView addSubview:self.detailViewController.view];
        [tmpContactDetailViewController release];
        
    }else if([obj isKindOfClass:[MessageDetailInfo class]]){
        if (self.detailViewController!=nil) {
            [detailViewController.view removeFromSuperview];
        }
        [self smallDetailView];
        IPad_MessageDetailViewController *tmpMessageDetailViewController = [[IPad_MessageDetailViewController alloc]init:obj];
        //tmpMessageDetailViewController.delegate=self;
        self.detailViewController=tmpMessageDetailViewController;
        [self.view_detailView addSubview:self.detailViewController.view];
        [tmpMessageDetailViewController release];
        
    }else{
        UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *tmpStr = obj;
        tmpBtn.tag = [tmpStr intValue];
        [self action_menuSelected:tmpBtn];
    }
    
//    [detailViewController release];
}

-(void)smallDetailView{
   [self.view_detailView setFrame:CGRectMake(345, 0, 678, 748)];
}
-(void)largeDetailView{
    [self.view_detailView setFrame:CGRectMake(64, 0, 970, 748)];
}

-(void)smallMenuView{
    [view_ipadMenu setFrame:CGRectMake(0, 0, 65, 748) ];
}
-(void)largeMenuView{
    [view_ipadMenu setFrame:CGRectMake(0, 0, 354, 748) ];
}
-(void)fullView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [self.view_ipadMenu setFrame:CGRectMake(-354, 0, 354, 748)];
    [self.view_detailView setFrame:CGRectMake(0, 0, 1024, 748)];
    [UIView commitAnimations];
}
-(void)smallView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [self.view_ipadMenu setFrame:CGRectMake(0, 0, 354, 748)];
    [self.view_detailView setFrame:CGRectMake(345, 0, 678, 748)];
    [UIView commitAnimations];
}

//-(UserInfo*)refreshUserInfo{
////    STOService *service = [[STOService alloc]init];
////    [service refreshUserInfo];
////    [service release];
//    UserInfoDao *dao = [[UserInfoDao alloc]init];
//    UserInfo * userInfo = [dao getUserInfoById:@"4763"];
//    [dao release];
//    return  userInfo;
//}
-(void)refresh{
    if (self.detailViewController) {
        [self.detailViewController.view removeFromSuperview];
        self.detailViewController = nil;
    }
    if ([self.currentListView isKindOfClass:[TodoListViewController class]]) {
        TodoListViewController *todoListViewController = (TodoListViewController *)self.currentListView;
      //  [todoListViewController refreshData:YES];
        [todoListViewController refreshTodoListWithType];
    }
}

-(void)closeViewDetail{
    if (self.detailViewController) {
        [self.detailViewController.view removeFromSuperview];
        self.detailViewController = nil;
    }
}
-(void)openAttachmentFile:(AttachFileInfo *)attachFileInfo{
    FileReaderViewController *fileReaderController = [[FileReaderViewController alloc]init:attachFileInfo];
    fileReaderController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:fileReaderController animated:YES];
    [fileReaderController release];
}

@end
