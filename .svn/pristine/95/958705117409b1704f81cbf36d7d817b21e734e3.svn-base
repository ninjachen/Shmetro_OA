//
//  IPhone_TodoProcessViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/21/12.
//
//

#import <UIKit/UIKit.h>
#import "TodoInfo.h"
#import "CL_VoiceEngine.h"
@class CL_AudioRecorder;

#define kRecorderDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Recorders"]
@interface IPhone_TodoProcessViewController : UIViewController<UITextViewDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate>{
    CL_AudioRecorder* audioRecoder;
    BOOL              m_isRecording;
}
@property (nonatomic,retain) TodoInfo *todoInfo;
@property (retain, nonatomic) IBOutlet UILabel *lab_todoTitle;
@property (retain, nonatomic) IBOutlet UIButton *bt_recordDelete;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_save;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_cancel;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_record;
@property (retain, nonatomic) IBOutlet UITextView *txt_content;
@property (retain, nonatomic) IBOutlet UIButton *bt_play_record;
@property (retain, nonatomic) IBOutlet UIImageView *img_recording;
@property (retain, nonatomic) IBOutlet UIImageView *img_playing1;
@property (retain, nonatomic) IBOutlet UIImageView *img_playing2;
@property (retain, nonatomic) IBOutlet UIImageView *img_playing3;
@property (nonatomic) BOOL m_isRecording;
@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (nonatomic,retain) NSTimer *playTimer;
@property (nonatomic) BOOL isplaying;
@property (retain,nonatomic) NSString *recordPath;
@property (retain, nonatomic) IBOutlet UIView *view_record;
-(id)init:(TodoInfo *)todoInfoObj;
- (IBAction)action_cancel:(id)sender;
- (IBAction)action_submit:(id)sender;
- (IBAction)action_cancel:(id)sender;
- (IBAction)action_process_record_start:(id)sender;
- (IBAction)action_deleterecord:(id)sender;
- (IBAction)action_process_record_end:(id)sender;
- (IBAction)action_playrecord:(UIButton *)sender;
@end
