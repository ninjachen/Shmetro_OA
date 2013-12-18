//
//  IPad_MeetingInfoViewController.h
//  ShmetroOA
//
//  Created by gisteam on 6/20/13.
//
//

#import <UIKit/UIKit.h>

@interface Weekday : NSObject

@property(nonatomic,retain)NSString *monDay;
@property(nonatomic,retain)NSString *tueDay;
@property(nonatomic,retain)NSString *wedDay;
@property(nonatomic,retain)NSString *thuDay;
@property(nonatomic,retain)NSString *friDay;
@property(nonatomic,retain)NSString *satDay;
@property(nonatomic,retain)NSString *sunDay;

@end


#import "MeetingInfo.h"
#import "IPad_MeetingDetailInfoViewController.h"
@interface IPad_MeetingInfoViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,
UITextViewDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate>
{
    
}

@property(retain,nonatomic)IPad_MeetingDetailInfoViewController *meetingDetailInfoViewController;
@property (retain,nonatomic) UIPopoverController *companyPopover;
@property(nonatomic,retain)UIPickerView *companyPickView;
@property(nonatomic,retain)IBOutlet UIView *view_meetingSchedule;
@property(nonatomic,retain)IBOutlet UIView *view_myMeeting;
@property(nonatomic,retain)IBOutlet UIView *view_meetingOccupation;
@property(nonatomic,assign)int currentViewTag;
@property(nonatomic,retain)IBOutlet UITableView *tableView_meetingSchedule;
@property(nonatomic,retain)IBOutlet UITableView *tableView_myMeeting;
@property(nonatomic,retain)IBOutlet UITableView *tableView_meetingOccupation;
@property(nonatomic,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblCompany;
@property(nonatomic,retain)IBOutlet UIButton *btnCompany;

@property(nonatomic,retain)IBOutlet UIButton *btn_curweek_schedule;
@property(nonatomic,retain)IBOutlet UIButton *btn_preweek_schedule;
@property(nonatomic,retain)IBOutlet UIButton *btn_nextweek_schedule;
@property(nonatomic,retain)IBOutlet UIButton *btn_curweek_mymeeting;
@property(nonatomic,retain)IBOutlet UIButton *btn_preweek_mymeeting;
@property(nonatomic,retain)IBOutlet UIButton *btn_nextweek_mymeeting;
@property(nonatomic,retain)IBOutlet UIButton *btn_curday_occupation;
@property(nonatomic,retain)IBOutlet UIButton *btn_preday_occupation;
@property(nonatomic,retain)IBOutlet UIButton *btn_nextday_occupation;


@property(nonatomic,retain)NSDictionary *companyArra;
@property(nonatomic,retain)NSString *currentCompany;
@property(nonatomic,retain)Weekday *schedule_currentWeekday;
@property(nonatomic,retain)Weekday *myMeeting_currentWeekday;
@property(nonatomic,retain)NSString *occupation_currentday;
#pragma mark - meeting schedule
@property(nonatomic,retain)NSArray *meetingRoomInfos;
@property(nonatomic,retain)NSMutableArray *meetingRoomScheduleList;

@property(nonatomic,retain)NSMutableArray *myMeetingRoomList;
@property(nonatomic,retain)NSMutableArray *meetingOccupationRoomList;

-(void)refreshMeetingListFromStartdate:(NSString *)startdate ToEnddate:(NSString *)enddate;
-(void)refreshMyMeetingList;

-(IBAction)menu_select:(id)sender;
-(IBAction)changeCompany:(id)sender;
-(IBAction)action_nextWeek:(id)sender;
-(IBAction)action_preWeek:(id)sender;
-(IBAction)action_currentWeek:(id)sender;
-(IBAction)action_day_select:(id)sender;
@end
