//
//  IPad_MeetingInfoViewController.m
//  ShmetroOA
//
//  Created by gisteam on 6/20/13.
//
//

#import "IPad_MeetingInfoViewController.h"
#import "MeetingDao.h"
#import "MeetingInfo.h"
#import "MeetingRoom.h"
#import "MeetingRoomInfo.h"
#import "MeetingOccupationRoom.h"
#import "MeetingOccupationTableViewCell.h"
#import "MeetingScheduleTableViewCell.h"
#import "IPad_MeetingDetailInfoViewController.h"
#import "AppDelegate.h"
#import "MeetingHeadView.h"
#import "UserAccountContext.h"
#import "DateUtil.h"
#import "STOService.h"

#define ROW_HEIGHT 77
#define HEADER_HEIGHT 65
#define COLUMN_WIDTH 105
#define FONT_SIZE 11.0

@implementation Weekday
@synthesize monDay,tueDay,wedDay,thuDay,friDay,satDay,sunDay;

-(void)dealloc{
    [monDay release];
    [tueDay release];
    [wedDay release];
    [thuDay release];
    [friDay release];
    [satDay release];
    [sunDay release];
    [super dealloc];
}

@end

@interface IPad_MeetingInfoViewController ()

-(void)refreshMeetingListFromStartdate:(NSString *)startdate ToEnddate:(NSString *)enddate;
-(void)refreshMyMeetingListFromStartDate:(NSString *)startdate ToEndDate:(NSString *)enddate;

-(Weekday*)getCurrentWeek:(NSDate *)date;
-(Weekday *)getPreWeek:(Weekday *)currentWeek;
-(Weekday *)getNextWeek:(Weekday *)currentWeek;

-(CGFloat)heightForMeetingCell:(NSString *)meetTitle;
-(CGFloat)heightForRow:(NSInteger)row TableView:(NSInteger)tag;
-(CGFloat)heightForOccupationRow:(NSInteger)row;

-(NSString *)getMeetingStartTimeAndEndTime:(MeetingInfo *)meetingInfo;

-(void)reloadMeetingSchduleByOrg:(NSString *)org FromStartdate:(NSString*)startdate ToEnddate:(NSString*)enddate;
-(void)reloadMyMeetingByOrg:(NSString *)org FromStartdate:(NSString*)startdate ToEnddate:(NSString*)enddate;
-(void)reloadMeetingOccupationByOrg:(NSString *)org OnDate:(NSString*)date;

@end

@implementation IPad_MeetingInfoViewController
@synthesize meetingDetailInfoViewController;
@synthesize view_meetingOccupation,view_meetingSchedule,view_myMeeting;
@synthesize tableView_meetingSchedule,tableView_meetingOccupation,tableView_myMeeting;
@synthesize meetingRoomScheduleList,myMeetingRoomList,meetingOccupationRoomList,meetingRoomInfos;
@synthesize schedule_currentWeekday,myMeeting_currentWeekday,occupation_currentday;
@synthesize companyPopover,companyPickView,companyArra;
@synthesize btn_curday_occupation,btn_nextday_occupation,btn_preday_occupation;
@synthesize btn_curweek_mymeeting,btn_nextweek_mymeeting,btn_preweek_mymeeting;
@synthesize btn_curweek_schedule,btn_nextweek_schedule,btn_preweek_schedule;
@synthesize btnCompany;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.schedule_currentWeekday  = [self getCurrentWeek:[NSDate date]];
    self.myMeeting_currentWeekday  = [self getCurrentWeek:[NSDate date]];
    self.occupation_currentday = [DateUtil convertDateToString:[NSDate date]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STOService *service =[[STOService alloc]init];
        self.companyArra = [service getOrgs];
        [service release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.companyArra ==nil || self.companyArra.count < 1) {
                return ;
            }
            self.currentCompany = [[self.companyArra allKeys]objectAtIndex:0];
            self.lblCompany.text =[self.companyArra valueForKey:self.currentCompany];
            
            self.currentViewTag = 1;
            [self initView];
        });
    });


    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
        if ([self isViewLoaded] && [self.view window] == nil) {
            self.view = nil;
        }
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload{
    [self setTableView_meetingOccupation:nil];
    [self setTableView_meetingSchedule:nil];
    [self setTableView_myMeeting:nil];
    [self setBtn_curday_occupation:nil];
    [self setBtn_curweek_mymeeting:nil];
    [self setBtn_curweek_schedule:nil];
    [self setBtn_nextday_occupation:nil];
    [self setBtn_nextweek_mymeeting:nil];
    [self setBtn_nextweek_schedule:nil];
    [self setBtn_preday_occupation:nil];
    [self setBtn_preweek_mymeeting:nil];
    [self setBtn_preweek_schedule:nil];
    [self setBtnCompany:nil];
    [self setLblCompany:nil];
    [self setView_meetingOccupation:nil];
    [self setView_meetingSchedule:nil];
    [self setView_myMeeting:nil];
}
-(void)dealloc{
    [meetingRoomInfos release];
    [meetingRoomScheduleList release];
    [myMeetingRoomList release];
    [meetingOccupationRoomList release];
    
    [view_meetingOccupation release];
    [view_meetingSchedule release];
    [view_myMeeting release];
    [tableView_myMeeting release];
    [tableView_meetingSchedule release];
    [tableView_meetingOccupation release];
    
    [schedule_currentWeekday release];
    [myMeeting_currentWeekday release];
    [companyArra release];
    [companyPickView release];
    [companyPopover release];
    [btnCompany release];
    [btn_curday_occupation release];
    [btn_curweek_mymeeting release];
    [btn_curweek_schedule release];
    [btn_nextday_occupation release];
    [btn_nextweek_mymeeting release];
    [btn_nextweek_schedule release];
    [btn_preday_occupation release];
    [btn_preweek_mymeeting release];
    [btn_preweek_schedule release];
    [meetingDetailInfoViewController release];
    [super dealloc];
}

-(void)initView{
    switch (self.currentViewTag) {
        case 1:
            [self reloadMeetingSchduleByOrg:self.currentCompany FromStartdate:self.schedule_currentWeekday.monDay ToEnddate:self.schedule_currentWeekday.sunDay];
            break;
          
        case 2:
              [self reloadMyMeetingByOrg:self.currentCompany FromStartdate:self.myMeeting_currentWeekday.monDay ToEnddate:self.myMeeting_currentWeekday.sunDay];
            break;
            
        case 3:
             [self reloadMeetingOccupationByOrg:self.currentCompany OnDate:self.occupation_currentday];
            break;
            
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    int num = 1;
//    switch (tableView.tag) {
//        case 1:
//        case 2:{
//            num = 1;
//            break;
//        }
//            
//        default:
//            break;
//    }
//    return num;
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    int num = 0;
//    switch (tableView.tag) {
//        case 1:
//        case 2:
//        case 3:{
//            num = self.meetingRoomInfos==nil?0:self.meetingRoomInfos.count;
//            break;
//        }
//            
//        default:
//            break;
//    }
//    return num;
    return self.meetingRoomInfos==nil?0:self.meetingRoomInfos.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    int row = [indexPath row];
    static NSString *ScheduleCellIdentifier = @"scheduleMeetingCell";
    static NSString *MyMeetingCellIdentifier = @"mymeetingCell";
    static NSString *OccupationCellIdentifier = @"occupationMeetingCell";
    
    switch (tableView.tag) {
        case 1:
        case 2:{
            if (tableView.tag ==1) {
                cell =(MeetingScheduleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ScheduleCellIdentifier];
                if (cell == nil) {
                    cell = [[[MeetingScheduleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ScheduleCellIdentifier]autorelease];
                }
            }else{
                cell =(MeetingScheduleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MyMeetingCellIdentifier];
                if (cell == nil) {
                    cell = [[[MeetingScheduleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyMeetingCellIdentifier]autorelease];
                }
            }
            CGFloat  rowHeight = [self heightForRow:[indexPath row] TableView:tableView.tag];
            MeetingRoom *meetingRoom = nil;
            if (tableView.tag ==1) {
                meetingRoom = [self.meetingRoomScheduleList objectAtIndex:row];
            }else if(tableView.tag ==2){
                meetingRoom = [self.myMeetingRoomList objectAtIndex:row];
            }
            for (UIView *tmpView in ((MeetingScheduleTableViewCell*)cell).dynamicContentView.subviews){
                [tmpView removeFromSuperview];
                tmpView = nil;
            }
            [((MeetingScheduleTableViewCell*)cell).dynamicContentView setFrame:CGRectMake(0, 0, 0, 0)];
            [((MeetingScheduleTableViewCell*)cell) resetCell:rowHeight];
            
            ((MeetingScheduleTableViewCell*)cell).lblMeetingRoomName.text = [meetingRoom name];
            NSMutableArray *list = [[NSMutableArray alloc]initWithObjects:meetingRoom.monMeetinglist,meetingRoom.tueMeetinglist,meetingRoom.wedMeetinglist,meetingRoom.thuMeetinglist,meetingRoom.friMeetinglist,meetingRoom.satMeetinglist,meetingRoom.sunMeetinglist, nil];
            for (int i = 0 ; i <list.count;i++) {
                NSMutableArray *meetingList = [list objectAtIndex:i];
                CGFloat cellHeight = [indexPath row]==0?0:1.0;
                if (meetingList != nil && meetingList.count >0) {
                    for (int j=0; j<meetingList.count; j++) {
                        @autoreleasepool {
                        MeetingInfo *meetingInfo = [meetingList objectAtIndex:j];
                        CGFloat txtViewHight =  [self heightForMeetingCell:meetingInfo.title];
    
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        CGFloat btn_height = txtViewHight;
                        if (j==meetingList.count-1) {
                            btn_height= rowHeight-cellHeight;
                        }
                        [btn setFrame:CGRectMake(106*i, cellHeight,COLUMN_WIDTH, btn_height)];
                        btn.titleLabel.font = [UIFont boldSystemFontOfSize: FONT_SIZE];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        NSString *meetingTime = [self getMeetingStartTimeAndEndTime:meetingInfo];
                        [btn setTitle:[NSString stringWithFormat:@"%@\n%@\n主持人：%@",meetingInfo.title,meetingTime,meetingInfo.compere] forState:(UIControlStateNormal)];
                        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                        btn.contentEdgeInsets = UIEdgeInsetsMake(0,5, 0, 0);
                        btn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
                        btn.titleLabel.numberOfLines=0;
                        btn.tag=[meetingInfo.mId integerValue];
                        [btn addTarget:self action:@selector(action_meetingSelected:) forControlEvents:UIControlEventTouchUpInside];
                        if (j%2==1) {
                            [btn setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:216.0/255.0 blue:145.0/255.0 alpha:1]];
                            
                        }else{
                            [btn setBackgroundColor:[UIColor colorWithRed:166.0/255.0 green:210/255.0 blue:225/255.0 alpha:1]];
                        }
                        cellHeight = cellHeight + txtViewHight+1;
                        [((MeetingScheduleTableViewCell*)cell).dynamicContentView addSubview:btn];
                        btn = nil;
                    }
                    }
                }
            }
            [list release];
            break;
        }
            
        case 3:
            cell =(MeetingOccupationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:OccupationCellIdentifier];
            if (cell == nil) {
                cell = [[[MeetingOccupationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OccupationCellIdentifier]autorelease];
            }
            for (UIView *tmpView in ((MeetingOccupationTableViewCell*)cell).dynamicContentView.subviews){
                [tmpView removeFromSuperview];
            }
             CGFloat hegightRow = [self heightForOccupationRow:[indexPath row]];
            [((MeetingOccupationTableViewCell*)cell).dynamicContentView setFrame:CGRectMake(0, 0, 0, 0)];
            [((MeetingOccupationTableViewCell*)cell) resetCell:hegightRow];
            
            MeetingOccupationRoom *meetingOccupationRoom = [self.meetingOccupationRoomList objectAtIndex:[indexPath row]];
            NSArray *meetingList = meetingOccupationRoom.meetinglist;
            ((MeetingOccupationTableViewCell *)cell).lblMeetingRoomName.text = [meetingOccupationRoom name];
            if (meetingList !=nil && meetingList.count > 0) {
                for (int i = 0; i < meetingList.count; i++) {
                    MeetingInfo *meetingInfo = [meetingList objectAtIndex:i];

                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake(i*(COLUMN_WIDTH+1), 0,COLUMN_WIDTH, hegightRow)];
                    btn.titleLabel.font = [UIFont systemFontOfSize: FONT_SIZE];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    NSString *meetingTime = [self getMeetingStartTimeAndEndTime:meetingInfo];
                    [btn setTitle:[NSString stringWithFormat:@"%@\n%@\n主持人：%@",meetingInfo.title,meetingTime,meetingInfo.compere] forState:(UIControlStateNormal)];
                    btn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
                    btn.titleLabel.numberOfLines=0;
                    btn.tag=[meetingInfo.mId integerValue];
                    [btn addTarget:self action:@selector(action_meetingSelected:) forControlEvents:UIControlEventTouchUpInside];
                    if (i%2==1) {
                        [btn setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:216.0/255.0 blue:145.0/255.0 alpha:1]];
                    }else{
                        [btn setBackgroundColor:[UIColor colorWithRed:166.0/255.0 green:210/255.0 blue:225/255.0 alpha:1]];
                    }
                    [((MeetingScheduleTableViewCell*)cell).dynamicContentView addSubview:btn];
                    btn = nil;
                }
                
            }
            break;
    }
    return cell;
}


#pragma mark - UITableViewDelegate
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1:
        case 2:{
            NSArray *views =  [[NSBundle mainBundle]loadNibNamed:@"MeetingHeadView" owner:self options:nil];
            MeetingHeadView * view = [views objectAtIndex:0];
            view.lblMeeting.text=@"会议室";
            NSString *currentDay =  [DateUtil convertDateToString:[NSDate date]];
            
            Weekday *currentWeek = nil;
            switch (tableView.tag) {
                case 1:
                    currentWeek = self.schedule_currentWeekday;
                    break;
                    
                case 2:
                    currentWeek = self.myMeeting_currentWeekday;
                    break;
                    
                default:
                    break;
            }
            if (currentWeek!=nil) {
                if ([currentWeek.monDay isEqualToString:currentDay]) {
                    [view.view_background setHidden:NO];
                    [view.view_background setFrame:CGRectMake(112, 1, 103, 61)];
                }
                if ([currentWeek.tueDay isEqualToString:currentDay]) {
                    [view.view_background setHidden:NO];
                    [view.view_background setFrame:CGRectMake(218, 1, 103, 61)];
                }
                if ([currentWeek.wedDay isEqualToString:currentDay]) {
                    [view.view_background setHidden:NO];
                    [view.view_background setFrame:CGRectMake(324, 1, 103, 61)];
                }
                if ([currentWeek.thuDay isEqualToString:currentDay]) {
                    [view.view_background setHidden:NO];
                    [view.view_background setFrame:CGRectMake(430, 1, 103, 61)];
                }
                if ([currentWeek.friDay isEqualToString:currentDay]) {
                    [view.view_background setHidden:NO];
                    [view.view_background setFrame:CGRectMake(536, 1, 103, 61)];
                }
                if ([currentWeek.satDay isEqualToString:currentDay]) {
                    [view.view_background setHidden:NO];
                    [view.view_background setFrame:CGRectMake(642, 1, 103, 61)];
                }
                if ([currentWeek.sunDay isEqualToString:currentDay]) {
                    [view.view_background setHidden:NO];
                    [view.view_background setFrame:CGRectMake(748, 1, 103, 61)];
                }
                view.lblMon.text = currentWeek.monDay;
                view.lblTus.text = currentWeek.tueDay;
                view.lblWed.text = currentWeek.wedDay;
                view.lblThu.text = currentWeek.thuDay;
                view.lblFri.text = currentWeek.friDay;
                view.lblSat.text = currentWeek.satDay;
                view.lblSun.text = currentWeek.sunDay;
            }
            return view;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1:
        case 2:{
                return HEADER_HEIGHT;
            break;
        }
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = ROW_HEIGHT;
    switch (tableView.tag) {
        case 1:
        case 2:{
            height = [self heightForRow:[indexPath row] TableView:tableView.tag];
            break;
        }
        case 3:
            height = [self heightForOccupationRow:[indexPath row]];
            break;
        
        default:
            break;
    }
    
    return height;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  self.companyArra == nil?0:[self.companyArra count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[self.companyArra allValues]objectAtIndex:row];
}

#pragma mark - Selector Action
-(void)action_meetingSelected:(id)sender{
    UIButton *btn = sender;
    MeetingDao *dao = [[MeetingDao alloc]init];
    NSString *mrId =[NSString stringWithFormat: @"%d", btn.tag];
    MeetingInfo *meetingInfo = [dao getMeetingById:mrId];
    [dao release];
    if (meetingInfo !=nil) {
        IPad_MeetingDetailInfoViewController *tmpMeetingDetailInfoViewController = [[IPad_MeetingDetailInfoViewController alloc]init:meetingInfo];
        self.meetingDetailInfoViewController = tmpMeetingDetailInfoViewController;
        [tmpMeetingDetailInfoViewController release];
        [self.view addSubview:self.meetingDetailInfoViewController.view];
    }
}

-(void)action_companySelected:(id)sender{
    UIButton *button = sender;
    if (button.tag == 1) {
        self.currentCompany =  [[self.companyArra allKeys]objectAtIndex:[self.companyPickView selectedRowInComponent:0]];
        [self.lblCompany setText:[self.companyArra valueForKey:self.currentCompany]];
        [self initView];
    }
    
    [self.companyPopover dismissPopoverAnimated:YES];
}


#pragma mark -  Methods
-(void)refreshMeetingListFromStartdate:(NSString *)startdate ToEnddate:(NSString *)enddate{
    STOService *service = [[STOService alloc]init];
    [service refreshMeetingListFromStartDate:startdate ToEndDate:enddate];
    [service release];
}

-(void)refreshMyMeetingListFromStartDate:(NSString *)startdate ToEndDate:(NSString *)enddate{
    NSString *userName = [[[UserAccountContext singletonInstance]userAccountInfo]userName];
    
    STOService *service = [[STOService alloc]init];
    [service refreshMeetingListByUserName:userName FromStartDate:startdate ToEndDate:enddate];
    [service release];
}

- (Weekday*)getCurrentWeek:(NSDate *)date{
    if (date == nil) {
        date = [NSDate date];
    }
    Weekday *weekday = [[[Weekday alloc]init]autorelease];
    double interval = 0;
    NSDate *monDate = nil;
    NSDate *sunDate = nil;
    NSDate*tueDate = nil;
    NSDate*wedDate=nil;
    NSDate *thuDate=nil;
    NSDate *friDate=nil;
    NSDate*satDate=nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&monDate interval:&interval forDate:date];
    if (ok) {
        sunDate = [monDate dateByAddingTimeInterval:interval-1];
    }
    tueDate =[monDate dateByAddingTimeInterval:24*60*60 ];
    wedDate=[monDate dateByAddingTimeInterval:2*24*60*60];
    thuDate=[monDate dateByAddingTimeInterval:3*24*60*60];
    friDate=[monDate dateByAddingTimeInterval:4*24*60*60];
    satDate=[monDate dateByAddingTimeInterval:5*24*60*60];
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *monString = [myDateFormatter stringFromDate:monDate];
    NSString *tueString = [myDateFormatter stringFromDate:tueDate];
    NSString *wedString = [myDateFormatter stringFromDate:wedDate];
    NSString *thuString = [myDateFormatter stringFromDate:thuDate];
    NSString *friString = [myDateFormatter stringFromDate:friDate];
    NSString *satString = [myDateFormatter stringFromDate:satDate];
    NSString *sunString = [myDateFormatter stringFromDate:sunDate];
    weekday.monDay = monString;
    weekday.tueDay = tueString;
    weekday.wedDay = wedString;
    weekday.thuDay = thuString;
    weekday.friDay = friString;
    weekday.satDay = satString;
    weekday.sunDay = sunString;
    [myDateFormatter release];
    
    return weekday;
}

-(Weekday*)getNextWeek:(Weekday*)currentWeek{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:currentWeek.sunDay];
    [dateFormatter release];
    date = [date  dateByAddingTimeInterval:2*24*60*60];
    Weekday *nextWeek = [self getCurrentWeek:date];
    return nextWeek;
}

-(Weekday *)getPreWeek:(Weekday *)currentWeek{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:currentWeek.monDay];
    [dateFormatter release];
    date = [date  dateByAddingTimeInterval:(-2*24*60*60)];
    Weekday *preWeek = [self getCurrentWeek:date];
    return preWeek;
}
-(void)reloadMeetingSchduleByOrg:(NSString *)org FromStartdate:(NSString*)startdate ToEnddate:(NSString*)enddate{
    if (self.meetingRoomScheduleList ==nil) {
        NSMutableArray *tempMutableArray = [[NSMutableArray alloc]init];
        self.meetingRoomScheduleList = tempMutableArray;
        [tempMutableArray release];
    }else if(self.meetingRoomScheduleList.count>0){
        [self.meetingRoomScheduleList removeAllObjects];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STOService *service = [[STOService alloc]init];
        self.meetingRoomInfos =  [service searchMeetingRoomByOrg:org];
        [service release];
        
        if (self.meetingRoomInfos == nil || self.meetingRoomInfos.count <1) {
            return;
        }
        [self refreshMeetingListFromStartdate:startdate ToEnddate:enddate];
        @autoreleasepool {
            

        for (int i = 0; i < meetingRoomInfos.count; i++) {
            MeetingRoomInfo *meetingRoomInfo = [self.meetingRoomInfos objectAtIndex:i];
            MeetingRoom *meetingRoom = [self scheduleMeetingRoomByMeetingRoomInfo: meetingRoomInfo FromStartdate:[DateUtil convertStringToNumber:startdate] ToEnddate:[DateUtil convertStringToNumber:enddate]];
            [self.meetingRoomScheduleList addObject:meetingRoom];
        }
                    }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.meetingRoomScheduleList == nil || self.meetingRoomScheduleList.count < 1) {
                return;
            }
            
            [self.tableView_meetingSchedule reloadData];
            [appDelegate closeLoading];
        });
    });
}

-(void)reloadMyMeetingByOrg:(NSString *)org FromStartdate:(NSString*)startdate ToEnddate:(NSString*)enddate{
    if (self.myMeetingRoomList ==nil) {
        NSMutableArray *tempArr =  [[NSMutableArray alloc]init];
        self.myMeetingRoomList =tempArr;
        [tempArr release];
    }else if(self.myMeetingRoomList.count>0){
        [self.myMeetingRoomList removeAllObjects];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *userName = [[[UserAccountContext singletonInstance]userAccountInfo]userName];
        STOService *service =[[STOService alloc]init];
        self.meetingRoomInfos = [service searchMeetingRoomByOrg:org];
        [service release];
        
        [self refreshMyMeetingListFromStartDate:startdate ToEndDate:enddate];
        for (int i = 0; i < meetingRoomInfos.count; i++) {
            MeetingRoomInfo *meetingRoomInfo = [meetingRoomInfos objectAtIndex:i];
            MeetingRoom *meetingRoom =[self myMeetingRoomForName:userName MeetingRoomInfo:meetingRoomInfo FromStartdate:[DateUtil convertStringToNumber:startdate] ToEnddate:[DateUtil convertStringToNumber:enddate]];
            
            [self.myMeetingRoomList addObject:meetingRoom];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView_myMeeting reloadData];
            [appDelegate closeLoading];
        });
    });

    

}

-(void)reloadMeetingOccupationByOrg:(NSString *)org OnDate:(NSString*)date{
    if (self.meetingOccupationRoomList ==nil) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        self.meetingOccupationRoomList = tempArray;
        [tempArray release];
    }else if(self.meetingOccupationRoomList.count>0){
        [self.meetingOccupationRoomList removeAllObjects];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STOService *service = [[STOService alloc]init];
        self.meetingRoomInfos =  [service searchMeetingRoomByOrg:org];
        [service release];
        if (self.meetingRoomInfos == nil || self.meetingRoomInfos.count <1) {
            return;
        }
        
        [self refreshMeetingListFromStartdate:date ToEnddate:date];
        for (int i = 0; i < meetingRoomInfos.count; i++) {
            MeetingRoomInfo *meetingRoomInfo = [meetingRoomInfos objectAtIndex:i];
            MeetingOccupationRoom *meetingOccupationRoom = [self occupationMeetingRoomByMeetingRoomInfo:meetingRoomInfo OnDate:[DateUtil convertStringToNumber:date]];
            [self.meetingOccupationRoomList addObject:meetingOccupationRoom];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.meetingOccupationRoomList ==nil || self.meetingOccupationRoomList.count < 1) {
                return;
            }
            [self.tableView_meetingOccupation reloadData];
              [appDelegate closeLoading];
        });
    });
}


-(MeetingRoom *)scheduleMeetingRoomByMeetingRoomInfo:(MeetingRoomInfo *)meetingRoomInfo FromStartdate:(NSNumber *)startdate ToEnddate:(NSNumber *)enddate{
    MeetingRoom *meetingRoom = [[[MeetingRoom alloc]init]autorelease];
    meetingRoom.mrId = meetingRoomInfo.mrId;
    meetingRoom.name = meetingRoomInfo.name;
    MeetingDao *dao = [[MeetingDao alloc]init];

    NSMutableArray *meetingList =[dao queryMeetingListFromStartDate:startdate ToEndDate:enddate mrId:meetingRoomInfo.mrId];

    if (meetingList != nil && meetingList.count > 0){
        for (int i=0; i< meetingList.count; i++) {
            MeetingInfo *meetInfo = [meetingList objectAtIndex:i];
            if ([meetInfo.startDate isEqualToNumber:startdate]) {
                [meetingRoom.monMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:1 AppendDate:startdate]] ){
                [meetingRoom.tueMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:2 AppendDate:startdate]]) {
                [meetingRoom.wedMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:3 AppendDate:startdate]]) {
                [meetingRoom.thuMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:4 AppendDate:startdate]]) {
                [meetingRoom.friMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:5 AppendDate:startdate]]) {
                [meetingRoom.satMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:6 AppendDate:startdate]]) {
                [meetingRoom.sunMeetinglist addObject:meetInfo];
            }
        }
    }
    [dao release];
    return meetingRoom;
}

-(MeetingRoom *)myMeetingRoomForName:(NSString *)name MeetingRoomInfo:(MeetingRoomInfo *)meetingRoomInfo FromStartdate:(NSNumber *)startdate ToEnddate:(NSNumber *)enddate{
    MeetingRoom *meetingRoom = [[[MeetingRoom alloc]init]autorelease];
    meetingRoom.mrId = meetingRoomInfo.mrId;
    meetingRoom.name = meetingRoomInfo.name;
    MeetingDao *dao = [[[MeetingDao alloc]init]autorelease];
//    NSMutableArray *meetingList =[dao queryMeetingListForName:name FromStartDate:startdate ToEndDate:enddate mrId:meetingRoomInfo.mrId];
//    if (meetingList == nil || meetingList.count < 1) {

     NSMutableArray *meetingList =[dao queryMeetingListForName:name FromStartDate:startdate ToEndDate:enddate mrId:meetingRoomInfo.mrId];
//    }
    
    if (meetingList != nil && meetingList.count >0) {
        for (int i=0; i< meetingList.count; i++) {
            MeetingInfo *meetInfo = [meetingList objectAtIndex:i];
            if ([meetInfo.startDate isEqualToNumber:startdate]) {
                [meetingRoom.monMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:1 AppendDate:startdate]] ){
                [meetingRoom.tueMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:2 AppendDate:startdate]]) {
                [meetingRoom.wedMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:3 AppendDate:startdate]]) {
                [meetingRoom.thuMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:4 AppendDate:startdate]]) {
                [meetingRoom.friMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:5 AppendDate:startdate]]) {
                [meetingRoom.satMeetinglist addObject:meetInfo];
            }
            if ([meetInfo.startDate isEqualToNumber: [DateUtil addDay:6 AppendDate:startdate]]) {
                [meetingRoom.sunMeetinglist addObject:meetInfo];
            }
        }
    }
    return meetingRoom;
}

-(MeetingOccupationRoom *)occupationMeetingRoomByMeetingRoomInfo:(MeetingRoomInfo *)meetingRoomInfo OnDate:(NSNumber *)date{
    MeetingOccupationRoom *meetingOccupationRoom = [[[MeetingOccupationRoom alloc]init]autorelease];
    meetingOccupationRoom.mrId = meetingRoomInfo.mrId;
    meetingOccupationRoom.name = meetingRoomInfo.name;
    
    MeetingDao *dao = [[[MeetingDao alloc]init]autorelease];
    NSMutableArray *meetingList =[dao queryMeetingListFromStartDate:date ToEndDate:date mrId:meetingRoomInfo.mrId];
    meetingOccupationRoom.meetinglist = meetingList;
    return meetingOccupationRoom;
}

-(CGFloat)heightForMeetingCell:(NSString *)meetTitle{
    CGFloat height = ROW_HEIGHT;
    if (meetTitle !=nil && ![meetTitle isEqualToString:@""]) {
        CGSize size = [meetTitle sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(105.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
        height = size.height;
        height += 48;
    }
    
    return height;
}

-(CGFloat)heightForRow:(NSInteger)row TableView:(NSInteger)tag{
    CGFloat height = ROW_HEIGHT;
    MeetingRoom *meetingRoom = nil;
    int rowint = row;
    int tagint = tag;
    if (tagint == 1) {
        meetingRoom = [self.meetingRoomScheduleList objectAtIndex:rowint];
    }else if(tagint == 2){
        meetingRoom = [self.myMeetingRoomList objectAtIndex:rowint];
    }
    NSMutableArray *list = [[NSMutableArray alloc]initWithObjects:meetingRoom.monMeetinglist,meetingRoom.tueMeetinglist,meetingRoom.wedMeetinglist,meetingRoom.thuMeetinglist,meetingRoom.friMeetinglist,meetingRoom.satMeetinglist,meetingRoom.sunMeetinglist, nil];
    for (int i = 0 ; i <list.count;i++) {
        NSMutableArray *meetingList = [list objectAtIndex:i];
        CGFloat cellHeight =row==1?1.0:2.0;
        if (meetingList != nil && meetingList.count>0) {
            for (int j=0; j<meetingList.count; j++) {
                MeetingInfo *meetingInfo = [meetingList objectAtIndex:j];
                CGFloat txtViewHight =  [self heightForMeetingCell:meetingInfo.title];
                cellHeight = cellHeight + txtViewHight;
            }
        }
        if (cellHeight > height) {
            height = cellHeight;
        }
    }
    [list release];
    return  height;
}

-(CGFloat)heightForOccupationRow:(NSInteger)row{
    CGFloat height = ROW_HEIGHT;
    
    MeetingOccupationRoom * meetingOccupationRoom = [self.meetingOccupationRoomList objectAtIndex:row];
    NSArray *meetingList = meetingOccupationRoom.meetinglist;
    
    if (meetingList != nil && meetingList.count>0) {
        for (int j=0; j<meetingList.count; j++) {
            MeetingInfo *meetingInfo = [meetingList objectAtIndex:j];
            CGFloat cellHight =  [self heightForMeetingCell:meetingInfo.title];
            if (cellHight >height) {
                height = cellHight;
            }
        }
    }
    return  height;
}
-(NSString *)getMeetingStartTimeAndEndTime:(MeetingInfo *)meetingInfo{
    if (meetingInfo.startTime == nil || meetingInfo.endTime == nil) {
        return @"时间待定";
    }
    NSString *startTime = meetingInfo.startTime;
    NSString *endTime = meetingInfo.endTime;
    
    startTime = [startTime substringFromIndex:11];
    endTime = [endTime substringFromIndex:11];
    
    return [NSString stringWithFormat:@"%@ ~ %@",startTime,endTime];
}
#pragma mark - IBAction
-(IBAction)menu_select:(id)sender{
    UIButton *button = sender;
    switch (button.tag) {
        case 0:
            [self.view_meetingSchedule setHidden:NO];
            [self.view_meetingOccupation setHidden:YES];
            [self.view_myMeeting setHidden:YES];
            self.currentViewTag = 1;
            [self initView];
            [self.lblTitle setText:@"会议安排"];
            break;
            
        case 1:
            [self.view_myMeeting setHidden:NO];
            [self.view_meetingSchedule setHidden:YES];
            [self.view_meetingOccupation setHidden:YES];
            self.currentViewTag = 2;
            [self initView];
            [self.lblTitle setText:@"我的会议"];
            break;
            
        case 2:
            [self.view_meetingOccupation setHidden:NO];
            [self.view_meetingSchedule setHidden:YES];
            [self.view_myMeeting setHidden:YES];
            self.currentViewTag = 3;
            [self initView];
            [self.lblTitle setText:[NSString stringWithFormat:@"会议室占用情况 %@",self.occupation_currentday]];
            break;
            
        default:
            break;
    }
}

-(IBAction)changeCompany:(id)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STOService *service = [[[STOService alloc]init]autorelease];
        self.companyArra = [service getOrgs];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.companyPickView==nil) {
                UIPickerView *tmpPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
                self.companyPickView =tmpPickerView;
                [tmpPickerView release];
             
                self.companyPickView.delegate = self;
                self.companyPickView.dataSource = self;
                self.companyPickView.showsSelectionIndicator = YES;
            }
            
            if (self.companyPopover==nil) {
                
                UIViewController *companyViewController = [[UIViewController alloc] init];
//                [companyViewController.view setBackgroundColor:[UIColor blackColor]];
                [companyViewController.view addSubview:self.companyPickView];
                
                UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [btnOK setFrame:CGRectMake(20, 216, 120, 44)];
                [btnOK setTitle:@"确认" forState:UIControlStateNormal];
                btnOK.tag = 1;
                UIButton *btnNO = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [btnNO setFrame:CGRectMake(180, 216, 120, 44)];
                [btnNO setTitle:@"取消" forState:UIControlStateNormal];
                btnNO.tag = 2;
                [btnOK addTarget:self action:@selector(action_companySelected:) forControlEvents:UIControlEventTouchUpInside];
                [btnNO addTarget:self action:@selector(action_companySelected:) forControlEvents:UIControlEventTouchUpInside];
                [companyViewController.view addSubview:btnNO];
                [companyViewController.view addSubview:btnOK];
                
                companyViewController.contentSizeForViewInPopover = CGSizeMake(320, 260);
                UIPopoverController *tmpPopoverController = [[UIPopoverController alloc] initWithContentViewController:companyViewController];
                [companyViewController release];
                self.companyPopover = tmpPopoverController;
                [tmpPopoverController release];
            }
            [self.companyPopover presentPopoverFromRect:self.btnCompany.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        });
    });


 
}


-(IBAction)action_currentWeek:(id)sender{
    UIButton *button = sender;
    
    if (button.tag == 1) {
        self.schedule_currentWeekday = [self getCurrentWeek:[NSDate date]];
        [self reloadMeetingSchduleByOrg:self.currentCompany FromStartdate:self.schedule_currentWeekday.monDay ToEnddate:self.schedule_currentWeekday.sunDay];
    }else if (button.tag == 4){
        self.myMeeting_currentWeekday = [self getCurrentWeek:[NSDate date]];
        [self reloadMyMeetingByOrg:self.currentCompany FromStartdate:self.myMeeting_currentWeekday.monDay ToEnddate:self.myMeeting_currentWeekday.sunDay];
    }    
}

-(IBAction)action_nextWeek:(id)sender{
    UIButton *button = sender;

    if (button.tag==0) {
        self.schedule_currentWeekday = [self getNextWeek:self.schedule_currentWeekday];
        [self reloadMeetingSchduleByOrg:self.currentCompany FromStartdate:self.schedule_currentWeekday.monDay ToEnddate:self.schedule_currentWeekday.sunDay];
    }else if (button.tag == 3){
        self.myMeeting_currentWeekday = [self getNextWeek:self.myMeeting_currentWeekday];
        [self reloadMyMeetingByOrg:self.currentCompany FromStartdate:self.myMeeting_currentWeekday.monDay ToEnddate:self.myMeeting_currentWeekday.sunDay];
    }
}

-(IBAction)action_preWeek:(id)sender{
    UIButton *button = sender;
    
    if (button.tag==2) {
        self.schedule_currentWeekday = [self getPreWeek:self.schedule_currentWeekday];
        [self reloadMeetingSchduleByOrg:self.currentCompany FromStartdate:self.schedule_currentWeekday.monDay ToEnddate:self.schedule_currentWeekday.sunDay];
       // [self performSelector:@selector(gets) withObject:nil afterDelay:0.5];
    }else if (button.tag == 5){
        self.myMeeting_currentWeekday = [self getPreWeek:self.myMeeting_currentWeekday];
        [self reloadMyMeetingByOrg:self.currentCompany FromStartdate:self.myMeeting_currentWeekday.monDay ToEnddate:self.myMeeting_currentWeekday.sunDay];
    }
}

- (void) gets {
    self.schedule_currentWeekday = [self getPreWeek:self.schedule_currentWeekday];
    [self reloadMeetingSchduleByOrg:self.currentCompany FromStartdate:self.schedule_currentWeekday.monDay ToEnddate:self.schedule_currentWeekday.sunDay];
}

-(IBAction)action_day_select:(id)sender{
    UIButton *button = sender;
    switch (button.tag) {
        case 0:
           self.occupation_currentday = [DateUtil getPreDay:self.occupation_currentday];
            break;
            
        case 1:
            self.occupation_currentday = [DateUtil convertDateToString:[NSDate date]];
            break;
            
        case 2:
             self.occupation_currentday = [DateUtil getNextDay:self.occupation_currentday];
            break;
        default:
            break;
    }
    
    [self.lblTitle setText:[NSString stringWithFormat:@"会议室占用情况 %@",self.occupation_currentday]];
    [self reloadMeetingOccupationByOrg:self.currentCompany OnDate:self.occupation_currentday];
}
@end
