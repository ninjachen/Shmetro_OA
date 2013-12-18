//
//  TodoDetailViewController.h
//  ShmetroOA
//
//  Created by caven shen on 10/10/12.
//
//

#import <UIKit/UIKit.h>
#import "TodoInfo.h"
#import "ViewController.h"
#import "CL_VoiceEngine.h"
@class CL_AudioRecorder;

#define kRecorderDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Recorders"]

@interface IPad_TodoDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UITextViewDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate,DetailViewControllerDelegate>{
    CL_AudioRecorder* audioRecoder;
    BOOL              m_isRecording;
}
@property (retain, nonatomic) IBOutlet UILabel *lab_todoTitle;
@property (retain, nonatomic) IBOutlet UIButton *btn_screenChange;
@property (retain, nonatomic) IBOutlet UITableView *tableview_info;
@property (retain, nonatomic) IBOutlet UITableView *tableview_approve;
@property (retain, nonatomic) IBOutlet UITableView *tableview_file;
@property (nonatomic,retain) TodoInfo *todoInfo;
@property (nonatomic, assign) id<MainViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIImageView *imgview_bg;
@property (retain, nonatomic) IBOutlet UIButton *btn_full;
@property (retain, nonatomic) IBOutlet UIButton *btn_small;
@property (retain, nonatomic) IBOutlet UIButton *bt_notice;
@property (retain, nonatomic) IBOutlet UIButton *bt_1;
@property (retain, nonatomic) IBOutlet UIButton *bt_2;
@property (retain, nonatomic) IBOutlet UIButton *bt_3;
@property (retain, nonatomic) IBOutlet UIButton *bt_4;
@property (retain, nonatomic) IBOutlet UIButton *bt_todoProcess;
@property (retain, nonatomic) IBOutlet UIView *view_info;
@property (retain, nonatomic) IBOutlet UIView *view_file;
@property (retain, nonatomic) IBOutlet UIView *view_approve;
@property (retain, nonatomic) IBOutlet UIView *view_monitor;
@property (retain, nonatomic) IBOutlet UIWebView *webview_monitor;
@property (retain,nonatomic) NSArray *attachmentFileArr;
@property (retain, nonatomic) IBOutlet UIView *view_process;
@property (retain, nonatomic) IBOutlet UITextView *txtview_process;
@property (nonatomic) BOOL isLoadedWebview;
@property (nonatomic) BOOL m_isRecording;
@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) IBOutlet UIView *view_record;
@property (retain, nonatomic) IBOutlet UIImageView *img_recording;
@property (retain, nonatomic) IBOutlet UIImageView *img_process_bg;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_record;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_save;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_cancel;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_submmit;
@property (retain, nonatomic) IBOutlet UIImageView *img_playing1;
@property (retain, nonatomic) IBOutlet UIImageView *img_playing2;
@property (retain, nonatomic) IBOutlet UIImageView *img_playing3;
@property (retain,nonatomic) NSString *recordPath;
@property (retain, nonatomic) IBOutlet UIImageView *img_process_text_bg;
@property (retain, nonatomic) IBOutlet UIButton *bt_play_record;
@property (nonatomic,retain) NSTimer *playTimer;
@property (nonatomic) BOOL isplaying;
@property (retain, nonatomic) IBOutlet UIButton *bt_recordDelete;
@property (nonatomic,retain) UIPopoverController *popController;
@property (retain, nonatomic) IBOutlet UIButton *bt_record;
-(id)init:(TodoInfo *)todoInfoObj;
- (IBAction)action_memo:(id)sender;
- (IBAction)action_changeScrren:(id)sender;
- (IBAction)action_processTodo:(id)sender;
- (IBAction)action_todo:(UIButton *)sender;
- (IBAction)action_process_save:(id)sender;
- (IBAction)action_process_submit:(id)sender;
- (IBAction)action_cancel:(id)sender;
- (IBAction)action_process_record_start:(id)sender;
- (IBAction)action_deleterecord:(id)sender;
- (IBAction)action_process_record_end:(id)sender;
- (IBAction)action_playrecord:(UIButton *)sender;
@end
