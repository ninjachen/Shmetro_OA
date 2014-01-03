//
//  TodoDetailViewController.m
//  ShmetroOA
//
//  Created by caven shen on 10/10/12.
//
//

#import "IPad_TodoDetailViewController.h"
#import "UIViewUtil.h"
#import "TodoDetailTableviewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "STOService.h"
#import "AttachFileInfo.h"
#import "ApproveTableviewCell.h"
#import "ApprovedInfo.h"
#import "ApiConfig.h"
#import "TodoInfoDao.h"
#import "AttachFileArrayViewController.h"
#import "FileUploadContext.h"
#import "AppDelegate.h"
@interface IPad_TodoDetailViewController ()
-(void)showDetailContent:(int)tag;
+(NSString *)reuseIdentifier;
+(NSString *)reuseIdentifier_attachmentFile;
+(NSString *)reuseIdentifier_approve;
- (void)startToRecord;
- (void)endRecord;
-(void)closeProcessView;
-(void)timerFire:(id)sender;
@end

@implementation IPad_TodoDetailViewController
@synthesize view_file;
@synthesize view_approve;
@synthesize view_monitor;
@synthesize webview_monitor;
@synthesize lab_todoTitle;
@synthesize btn_screenChange;
@synthesize tableview_info;
@synthesize tableview_approve;
@synthesize tableview_file;
@synthesize todoInfo;
@synthesize delegate;
@synthesize imgview_bg;
@synthesize btn_full;
@synthesize btn_small;
@synthesize bt_notice;
@synthesize bt_1;
@synthesize bt_2;
@synthesize bt_3;
@synthesize bt_4;
@synthesize bt_todoProcess;
@synthesize view_info,attachmentFileArr;
@synthesize view_process;
@synthesize txtview_process;
@synthesize isLoadedWebview;
@synthesize audioPlayer;
@synthesize view_record;
@synthesize img_recording;
@synthesize img_process_bg;
@synthesize bt_process_record;
@synthesize bt_process_submmit;
@synthesize bt_process_save;
@synthesize bt_process_cancel;
@synthesize img_playing1;
@synthesize img_playing2;
@synthesize img_playing3;
@synthesize recordPath;
@synthesize img_process_text_bg;
@synthesize bt_play_record;
@synthesize m_isRecording;
@synthesize playTimer;
@synthesize isplaying;
@synthesize bt_recordDelete;
@synthesize popController;
@synthesize bt_record;
int oldTag;
BOOL isFullScrren;
int playCount;
int recordingCount;
-(id)init:(TodoInfo *)todoInfoObj{
    self = [super init];
    if (self) {
        self.todoInfo = todoInfoObj;
        oldTag = 1;
        isFullScrren = NO;
        isLoadedWebview = NO;
        if (self.todoInfo.recordPath!=nil&&![self.todoInfo.recordPath isEqualToString:@""]) {
            self.recordPath = self.todoInfo.recordPath;
        }
        self.recordPath = @"";
        self.isplaying = NO;
        playCount = 0;
        recordingCount=0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.todoInfo.steplabel isEqualToString:@"部门领导审核"]) {
        [self.bt_process_record setHidden:NO];
    }else{
        [self.bt_process_record setHidden:YES];
    }
    if (self.todoInfo.recordPath!=nil&&![self.todoInfo.recordPath isEqualToString:@""]) {
        [self.view_record setHidden:NO];
    }
    if (todoInfo.processText!=nil) {
        [self.txtview_process setText:todoInfo.processText];
    }
    m_isRecording = NO;
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(timerFire:)
                                   userInfo:nil
                                    repeats:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone || UIUserInterfaceIdiomPad)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error;
        if ([audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
        {
            if ([audioSession setActive:YES error:&error])
            {
                //        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            }
            else
            {
                NSLog(@"Failed to set audio session category: %@", error);
            }
        }
        else
        {
            NSLog(@"Failed to set audio session category: %@", error);
        }
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof(audioRouteOverride),&audioRouteOverride);
    }
    audioRecoder = [[CL_AudioRecorder alloc] initWithFinishRecordingBlock:^(CL_AudioRecorder *recorder, BOOL success) {
        //NSLog(@"%@,%@",success?@"YES":@"NO",recorder.recorderingPath);
    } encodeErrorRecordingBlock:^(CL_AudioRecorder *recorder, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    } receivedRecordingBlock:^(CL_AudioRecorder *recorder, float peakPower, float averagePower, float currentTime) {
        NSLog(@"%f,%f,%f",peakPower,averagePower,currentTime);
    }];
    
    
    [self.tableview_approve setBackgroundView:nil];
    [self.tableview_approve setBackgroundView:[[[UIView alloc] init] autorelease]];
}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
//    double delayInSeconds = 1.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//        STOService *service = [[STOService alloc]init];
//        self.todoInfo = [service getTodoInfoDetail:self.todoInfo.todoId];
//        [self.tableview_info setSeparatorColor:[UIColor brownColor]];
//        [service release];
//    });
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [appDelegate closeLoading];
//       
//    });
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    STOService *service = [[STOService alloc]init];
    self.todoInfo = [service getTodoInfoDetail:self.todoInfo.todoId];
    [self.tableview_info setSeparatorColor:[UIColor brownColor]];
    [service release];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate closeLoading];
        [self.tableview_info reloadData];
    });
});
    
}

-(void)viewDidAppear:(BOOL)animated
{
   }

- (void)viewDidUnload
{
    [self setLab_todoTitle:nil];
    [self setBtn_screenChange:nil];
    [self setTableview_info:nil];
    [self setImgview_bg:nil];
    [self setBtn_full:nil];
    [self setBtn_small:nil];
    [self setBt_notice:nil];
    [self setBt_1:nil];
    [self setBt_2:nil];
    [self setBt_3:nil];
    [self setBt_4:nil];
    [self setBt_todoProcess:nil];
    [self setView_info:nil];
    [self setView_file:nil];
    [self setView_approve:nil];
    [self setView_monitor:nil];
    [self setTableview_approve:nil];
    [self setTableview_file:nil];
    [self setWebview_monitor:nil];
    [self setView_process:nil];
    [self setTxtview_process:nil];
    [self setView_record:nil];
    [self setImg_recording:nil];
    [self setImg_process_bg:nil];
    [self setImg_process_text_bg:nil];
    [self setBt_process_record:nil];
    [self setImg_playing1:nil];
    [self setImg_playing2:nil];
    [self setImg_playing3:nil];
    [self setBt_play_record:nil];
    [self setBt_recordDelete:nil];
    [self setBt_process_save:nil];
    [self setBt_process_cancel:nil];
    [self setBt_process_submmit:nil];
    [self setBt_record:nil];
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
    [todoInfo release];
    [playTimer release];
    [recordPath release];
    [attachmentFileArr release];
    [lab_todoTitle release];
    [btn_screenChange release];
    [tableview_info release];
    [imgview_bg release];
    [btn_full release];
    [btn_small release];
    [bt_notice release];
    [bt_1 release];
    [bt_2 release];
    [bt_3 release];
    [bt_4 release];
    [bt_todoProcess release];
    [view_info release];
    [view_file release];
    [view_approve release];
    [view_monitor release];
    [tableview_approve release];
    [tableview_file release];
    [webview_monitor release];
    [view_process release];
    [txtview_process release];
    [audioPlayer release];
    [view_record release];
    [img_recording release];
    [img_process_bg release];
    [img_process_text_bg release];
    [bt_process_record release];
    [img_playing1 release];
    [img_playing2 release];
    [img_playing3 release];
    [bt_play_record release];
    [bt_recordDelete release];
    [bt_process_save release];
    [bt_process_cancel release];
    [bt_process_submmit release];
    [popController release];
    [bt_record release];
    [super dealloc];
}
- (IBAction)action_memo:(id)sender {
}

- (IBAction)action_changeScrren:(UIButton *)sender {
    switch (oldTag) {
        case 1:{
            [view_info setHidden:NO];
            [view_file setHidden:YES];
            [view_approve setHidden:YES];
            [view_monitor setHidden:YES];
            [self.tableview_info reloadData];
            break;
        }
        case 2:{
            [view_info setHidden:YES];
            [view_file setHidden:NO];
            [view_approve setHidden:YES];
            [view_monitor setHidden:YES];
            self.attachmentFileArr = [self.todoInfo getContentAttachmentFileArr];
            [self.tableview_file reloadData];
            break;
        }
        case 3:{
            [view_info setHidden:YES];
            [view_file setHidden:YES];
            [view_approve setHidden:NO];
            [view_monitor setHidden:YES];
            [self.tableview_approve reloadData];
            break;
        }
        case 4:{
            [view_info setHidden:YES];
            [view_file setHidden:YES];
            [view_approve setHidden:YES];
            [view_monitor setHidden:NO];
            break;
        }
        default:
            break;
    }
    
    
    switch (sender.tag) {
        case 1:{
            if (self.delegate) {
                [self.delegate fullView];
            }
            [btn_full setHidden:YES];
            [btn_small setHidden:NO];
            [self.view setFrame:CGRectMake(0, 0, 1024, 748)];
            [self.imgview_bg setFrame:CGRectMake(0, 0, 1024, 748)];
            [self.bt_notice setFrame:CGRectMake(890, 52, 30, 30)];
            [self.btn_full setFrame:CGRectMake(928, 52, 30, 30)];
            [self.btn_small setFrame:CGRectMake(928, 52, 30, 30)];
            [self.bt_1 setFrame:CGRectMake(973, 256, 45, 148)];
            [self.bt_2 setFrame:CGRectMake(973, 346, 45, 148)];
            [self.bt_3 setFrame:CGRectMake(973, 434, 45, 148)];
            [self.bt_4 setFrame:CGRectMake(973, 527, 45, 148)];
            [self.bt_todoProcess setFrame:CGRectMake(400, 652, 170, 40)];
            [self.imgview_bg setImage:[UIImage imageNamed:@"img_note.png"]];
            [self.view_info setFrame:CGRectMake(32, 114, 920, 522)];
            [self.view_file setFrame:CGRectMake(32, 114, 920, 522)];
            [self.view_approve setFrame:CGRectMake(15, 114, 953, 522)];
            [self.view_monitor setFrame:CGRectMake(32, 114, 920, 522)];
            [self.tableview_info setFrame:CGRectMake(0, 0, 920, 522)];
            [self.tableview_file setFrame:CGRectMake(0, 0, 920, 522)];
            [self.tableview_approve setFrame:CGRectMake(0, 0, 953, 522)];
            [self.webview_monitor setFrame:CGRectMake(0, 0, 920, 522)];
            
            [self.view_process setFrame:CGRectMake(self.view_process.frame.origin.x, self.view_process.frame.origin.y, 1024, 323)];
            [self.img_process_bg setFrame:CGRectMake(self.img_process_bg.frame.origin.x, self.img_process_bg.frame.origin.y, 1024, self.img_process_bg.frame.size.height)];
            [self.img_process_bg setImage:[UIImage imageNamed:@"bg_blue_big.png"]];
            
            [self.img_process_text_bg setFrame:CGRectMake(self.img_process_text_bg.frame.origin.x, self.img_process_text_bg.frame.origin.y, 936, self.img_process_text_bg.frame.size.height)];
            [self.img_process_text_bg setImage:[UIImage imageNamed:@"bg_input_big.png"]];
            [self.bt_process_record setFrame:CGRectMake(700, self.bt_process_record.frame.origin.y, self.bt_process_record.frame.size.width, self.bt_process_record.frame.size.height)];
            [self.txtview_process setFrame:CGRectMake(self.txtview_process.frame.origin.x, self.txtview_process.frame.origin.y, 924, self.txtview_process.frame.size.height)];
            isFullScrren = YES;
            
            
            break;
        }
        case 2:{
            if (self.delegate) {
                [self.delegate smallView];
            }
            [btn_full setHidden:NO];
            [btn_small setHidden:YES];
            [self.view setFrame:CGRectMake(0, 0, 678, 748)];
            [self.imgview_bg setFrame:CGRectMake(0, 0, 678, 748)];
            [self.bt_notice setFrame:CGRectMake(534, 52, 30, 30)];
            [self.btn_small setFrame:CGRectMake(572, 52, 30, 30)];
            [self.btn_full setFrame:CGRectMake(572, 52, 30, 30)];
            [self.bt_1 setFrame:CGRectMake(628, 256, 45, 148)];
            [self.bt_2 setFrame:CGRectMake(628, 346, 45, 148)];
            [self.bt_3 setFrame:CGRectMake(628, 434, 45, 148)];
            [self.bt_4 setFrame:CGRectMake(628, 527, 45, 148)];
            [self.bt_todoProcess setFrame:CGRectMake(254, 652, 170, 40)];
            [self.imgview_bg setImage:[UIImage imageNamed:@"img_note_small.png"]];
            [self.view_info setFrame:CGRectMake(32, 114, 580, 522)];
            [self.view_file setFrame:CGRectMake(32, 114, 580, 522)];
            [self.view_approve setFrame:CGRectMake(15, 114, 613, 522)];
            [self.view_monitor setFrame:CGRectMake(32, 114, 580, 522)];
            [self.webview_monitor setFrame:CGRectMake(0, 0, 580, 522)];
            [self.tableview_info setFrame:CGRectMake(0, 0, 580, 522)];
            [self.tableview_file setFrame:CGRectMake(0, 0, 580, 522)];
            [self.tableview_approve setFrame:CGRectMake(0, 0, 613, 522)];
            
            
            [self.view_process setFrame:CGRectMake(self.view_process.frame.origin.x, self.view_process.frame.origin.y, 679, 323)];
            [self.img_process_bg setFrame:CGRectMake(self.img_process_bg.frame.origin.x, self.img_process_bg.frame.origin.y, 679, self.img_process_bg.frame.size.height)];
            [self.img_process_bg setImage:[UIImage imageNamed:@"bg_16done.png"]];
            
            [self.img_process_text_bg setFrame:CGRectMake(self.img_process_text_bg.frame.origin.x, self.img_process_text_bg.frame.origin.y, 589, self.img_process_text_bg.frame.size.height)];
            [self.img_process_text_bg setImage:[UIImage imageNamed:@"bg_17input.png"]];
            [self.bt_process_record setFrame:CGRectMake(354, self.bt_process_record.frame.origin.y, self.bt_process_record.frame.size.width, self.bt_process_record.frame.size.height)];
            [self.txtview_process setFrame:CGRectMake(self.txtview_process.frame.origin.x, self.txtview_process.frame.origin.y, 575, self.txtview_process.frame.size.height)];
            isFullScrren = NO;
            break;
        }
        default:
            break;
    }
    [self.tableview_info reloadData];
    [self.tableview_file reloadData];
    [self.tableview_approve reloadData];
}

- (IBAction)action_processTodo:(id)sender {
    [self.view bringSubviewToFront:self.view_process];
    if (self.recordPath==nil||[self.recordPath isEqualToString:@""]) {
        [self.view_record setHidden:YES];
    }

    if (todoInfo.processText!=nil) {
        [self.txtview_process setText:[NSString stringWithFormat:@"%@\n",todoInfo.processText]];
        [self.txtview_process setText:todoInfo.processText];
    }else{
        [self.txtview_process setText:@"\n"];
        [self.txtview_process setText:@""];
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [self.view_process setFrame:CGRectMake(0, 425, self.view_process.frame.size.width, self.view_process.frame.size.height)];
    
    [UIView commitAnimations];
}

- (IBAction)action_todo:(UIButton *)sender {
    switch (sender.tag) {
        case 1:{
            [self.view bringSubviewToFront:self.bt_4];
            [self.view bringSubviewToFront:self.bt_3];
            [self.view bringSubviewToFront:self.bt_2];
            break;
        }
        case 2:{
            [self.view bringSubviewToFront:self.bt_4];
            [self.view bringSubviewToFront:self.bt_3];
            [self.view bringSubviewToFront:self.bt_1];
            break;
        }
        case 3:{
            [self.view bringSubviewToFront:self.bt_1];
            [self.view bringSubviewToFront:self.bt_2];
            [self.view bringSubviewToFront:self.bt_4];
            break;
        }
        case 4:{
            [self.view bringSubviewToFront:self.bt_1];
            [self.view bringSubviewToFront:self.bt_2];
            [self.view bringSubviewToFront:self.bt_3];
            break;
        }
        default:
            break;
    }
    [self.view bringSubviewToFront:sender];
    [self showDetailContent:sender.tag];
}

- (IBAction)action_process_save:(id)sender {
    self.todoInfo.recordPath = self.recordPath;
    self.todoInfo.processText = self.txtview_process.text;
    TodoInfoDao *dao = [[TodoInfoDao alloc]init];
    [dao update:self.todoInfo];
    [dao release];
    [self closeProcessView];
}

- (IBAction)action_process_submit:(id)sender {
    if (self.txtview_process.text==nil||[[self.txtview_process.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请输入您的处理意见" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    self.todoInfo.recordPath = self.recordPath;
    self.todoInfo.processText = self.txtview_process.text;
    if (self.recordPath==nil||[self.recordPath isEqualToString:@""]) {
        
        STOService *service = [[STOService alloc]init];
        
        NSDictionary *processDic = [service processTodo:self.todoInfo];
        [service release];
        if (processDic!=nil) {
            self.todoInfo.processFlag = @"1";
            TodoInfoDao *dao = [[TodoInfoDao alloc]init];
            [dao update:self.todoInfo];
            [dao release];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"待办事项请求已提交，请等待处理" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];
            [alert release];
        }else{
            self.todoInfo.processFlag = @"0";
            TodoInfoDao *dao = [[TodoInfoDao alloc]init];
            [dao update:self.todoInfo];
            [dao release];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"提交失败，请稍后再试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }else{
        self.todoInfo.processFlag = @"2";
        TodoInfoDao *dao = [[TodoInfoDao alloc]init];
        [dao update:self.todoInfo];
        [dao release];
         dispatch_async(dispatch_get_main_queue(), ^{
             [[FileUploadContext singletonInstance]putLocalFile:self.recordPath TodoId:self.todoInfo.todoId];
         });
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"待办事项请求已提交，请等待处理" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
        [alert release];
    }
   
}

- (IBAction)action_cancel:(id)sender {
    self.recordPath = @"";
    [self.txtview_process setText:@""];
    [self closeProcessView];
}

- (IBAction)action_process_record_start:(id)sender {
    [self.img_recording setHidden:NO];
    double delayInSeconds = 0.001;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self startToRecord];
    });
}

- (IBAction)action_deleterecord:(id)sender {
    self.recordPath = @"";
    if(self.todoInfo.recordPath!=nil&&![self.todoInfo.recordPath isEqualToString:@""]){
        self.todoInfo.recordPath = @"";
        TodoInfoDao *dao = [[TodoInfoDao alloc]init];
        [dao update:self.todoInfo];
        [dao release];
    }
    [self.view_record setHidden:YES];
}

- (IBAction)action_process_record_end:(id)sender {
    [self.img_recording setHidden:YES];
    [self endRecord];
}

- (IBAction)action_playrecord:(UIButton *)sender {
    [self.bt_play_record setEnabled:NO];
    [self.bt_recordDelete setEnabled:NO];
    [self.bt_process_save setEnabled:NO];
    [self.bt_process_cancel setEnabled:NO];
    [self.bt_process_record setEnabled:NO];
    [self.bt_process_submmit setEnabled:NO];
    NSError *error;
    self.audioPlayer= [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.recordPath] error:&error] autorelease];
    audioPlayer.volume = 1.0;
    audioPlayer.numberOfLoops= 0;
    audioPlayer.delegate = self;
    if(audioPlayer== nil)
        NSLog(@"Error: %@", [error description]);
    else
    {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        [audioPlayer play];
        isplaying = YES;
        playCount =0;
    }
    
}

#pragma mark - PrivateMethod
-(void)showDetailContent:(int)tag{
    if (oldTag!=tag) {
        UIView *srcView=nil ;
        UIView *destView=nil;
        switch (oldTag) {
            case 1:
                srcView = self.view_info;
                break;
            case 2:
                srcView = self.view_file;
                break;
            case 3:
                srcView = self.view_approve;
                break;
            case 4:
                srcView = self.view_monitor;
                break;
            default:
                break;
        }
        switch (tag) {
            case 1:
                destView = self.view_info;
                [self.tableview_info reloadData];
                break;
            case 2:
                destView = self.view_file;
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                [appDelegate showLoadingWithText:@"正在载入..." inView:self.view_file];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  self.attachmentFileArr = [self.todoInfo getContentAttachmentFileArr];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableview_file reloadData];
                        [appDelegate closeLoading];
                    });
                });
//                self.attachmentFileArr = [self.todoInfo getContentAttachmentFileArr];
//                [self.tableview_file reloadData];
                break;
            case 3:
                destView = self.view_approve;
                [self.tableview_approve reloadData];
                break;
            case 4:
                destView = self.view_monitor;
                if (!isLoadedWebview) {
                    [webview_monitor loadRequest:[NSURLRequest requestWithURL:[ApiConfig getApproveMonitorUrl:self.todoInfo.instanceId]]];
                }
                
                break;
            default:
                break;
        }
        if (oldTag>tag) {
            [UIViewUtil uiviewChange:(UIViewAnimationTransition *)UIViewAnimationTransitionCurlDown SourceView:srcView DestView:destView];
        }else{
            [UIViewUtil uiviewChange:(UIViewAnimationTransition *)UIViewAnimationTransitionCurlUp SourceView:srcView DestView:destView];
        }
        
        oldTag = tag;
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            switch (tag) {
                case 1:{
                    [view_info setHidden:NO];
                    [view_file setHidden:YES];
                    [view_approve setHidden:YES];
                    [view_monitor setHidden:YES];
                    break;
                }
                case 2:{
                    [view_info setHidden:YES];
                    [view_file setHidden:NO];
                    [view_approve setHidden:YES];
                    [view_monitor setHidden:YES];
                    
                    break;
                }
                case 3:{
                    [view_info setHidden:YES];
                    [view_file setHidden:YES];
                    [view_approve setHidden:NO];
                    [view_monitor setHidden:YES];
                    break;
                }
                case 4:{
                    [view_info setHidden:YES];
                    [view_file setHidden:YES];
                    [view_approve setHidden:YES];
                    [view_monitor setHidden:NO];
                    break;
                }
                default:
                    break;
            }
            
        });
        
    }
    
    
}

+(NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+(NSString *)reuseIdentifier_attachmentFile {
    return [NSString stringWithFormat:@"%@_attachmentFile",NSStringFromClass([self class])];
}

+(NSString *)reuseIdentifier_approve {
    return [NSString stringWithFormat:@"%@_approve",NSStringFromClass([self class])];
}

- (void)startToRecord
{
    if (m_isRecording == NO)
    {
        m_isRecording = YES;
        recordingCount =0;
        NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:
                                         [NSString stringWithFormat:@"%@.aac",self.todoInfo.todoId]];
        NSLock* tempLock = [[[NSLock alloc]init]autorelease];
        [tempLock lock];
        if ([[NSFileManager defaultManager] fileExistsAtPath:recordAudioFullPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:recordAudioFullPath error:nil];
        }
        [tempLock unlock];
        #if  TARGET_IPHONE_SIMULATOR
            NSString *fullPath = [kRecorderDirectory stringByAppendingPathComponent:
                                                 [NSString stringWithFormat:@"%@.caf",self.todoInfo.todoId]];
        #else
            NSString *fullPath = [kRecorderDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@.aac",self.todoInfo.todoId]];
        #endif
        self.recordPath = fullPath;
        [audioRecoder startRecord:fullPath];
    }
}

- (void)endRecord
{
    m_isRecording = NO;
    dispatch_queue_t stopQueue;
    stopQueue = dispatch_queue_create("stopQueue", NULL);
    dispatch_async(stopQueue, ^(void){
        //run in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [audioRecoder stopRecord];
        });
    });
    dispatch_release(stopQueue);
    [view_record setHidden:NO];
}

-(void)closeProcessView{
    [self.txtview_process resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [self.view_process setFrame:CGRectMake(0, 748, self.view_process.frame.size.width, self.view_process.frame.size.height)];
    [UIView commitAnimations];
}

-(void)timerFire:(id)sender{
    if (isplaying) {
        switch (playCount) {
            case 0:{
                [self.img_playing1 setHidden:YES];
                [self.img_playing2 setHidden:YES];
                [self.img_playing3 setHidden:YES];
                playCount ++;
                break;
            }
            case 1:{
                [self.img_playing1 setHidden:NO];
                [self.img_playing2 setHidden:YES];
                [self.img_playing3 setHidden:YES];
                playCount ++;
                break;
            }
            case 2:{
                [self.img_playing1 setHidden:NO];
                [self.img_playing2 setHidden:NO];
                [self.img_playing3 setHidden:YES];
                playCount++;
                break;
            }
            case 3:{
                [self.img_playing1 setHidden:NO];
                [self.img_playing2 setHidden:NO];
                [self.img_playing3 setHidden:NO];
                playCount=0;
                break;
            }
            default:
                break;
        }
    }else{
        [self.img_playing1 setHidden:NO];
        [self.img_playing2 setHidden:NO];
        [self.img_playing3 setHidden:NO];
    }
    
    if (m_isRecording) {
        switch (recordingCount) {
            case 0:
                [img_recording setImage:[UIImage imageNamed:@"ic_recorading_2.png"]];
                recordingCount++;
                break;
            case 1:
                [img_recording setImage:[UIImage imageNamed:@"ic_recorading_3.png"]];
                recordingCount++;
                break;
            case 2:
                [img_recording setImage:[UIImage imageNamed:@"ic_recorading_1.png"]];
                recordingCount=0;
                break;
            default:
                break;
        }
        
    }
}
#pragma mark -DetailViewControllerDelegate
-(void)getAttachfileArr:(NSString *)fileGroupId UIButton:(UIButton *)btn{
    STOService *service = [[STOService alloc]init];
    NSArray *fileArr = [service searchAttachFileList:fileGroupId];
    [service release];
    CGRect popoverRect = [self.view convertRect:btn.frame
                                       fromView:[btn superview]];
    AttachFileArrayViewController *fileArrController = [[AttachFileArrayViewController alloc]init];
    fileArrController.detailViewControllerDelegate = self;
    fileArrController.attachmentFileArr = fileArr;
    self.popController = [[[UIPopoverController alloc]initWithContentViewController:fileArrController] autorelease];
    [popController setPopoverContentSize:CGSizeMake(320, 400)];
    [popController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    [fileArrController release];
}

-(void)closePopoverViewController{
//    [self.popController dismissPopoverAnimated:NO];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:{
            [self closeProcessView];
            [self.delegate refresh];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int resp = 1;
    switch (tableView.tag) {
        case 1:
        case 2:
        case 4:{
            
            break;
        }
        case 3:
            resp = 3;
            break;
        
            
        default:
            break;
    }
    return resp;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int resp = 0;
    switch (tableView.tag) {
        case 1:{
            resp = self.todoInfo==nil?0:[[[self.todoInfo getTodoInfoDic] allKeys] count];
            break;
        }
        case 2:{
            resp = self.attachmentFileArr==nil?0:[self.attachmentFileArr count];
            break;
        }
        case 3:{
            switch (section) {
                case 0:
                    resp = (self.todoInfo==nil||(self.todoInfo!=nil&&self.todoInfo.applyApprovedArr==nil))?0:[self.todoInfo.applyApprovedArr count];
                    break;
                case 1:
                    resp = (self.todoInfo==nil||(self.todoInfo!=nil&&self.todoInfo.subApprovedArr==nil))?0:[self.todoInfo.subApprovedArr count];
                    break;
                case 2:
                    resp = (self.todoInfo==nil||(self.todoInfo!=nil&&self.todoInfo.backApplyApprovedArr==nil))?0:[self.todoInfo.backApplyApprovedArr count];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            
            break;
    }
    return resp;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    int row = [indexPath row];
    switch (tableView.tag) {
        case 1:{
            cell = (TodoDetailTableviewCell *)[tableView dequeueReusableCellWithIdentifier:[IPad_TodoDetailViewController reuseIdentifier]];
            if (cell == nil) {
                cell = [[[TodoDetailTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[IPad_TodoDetailViewController reuseIdentifier]] autorelease];
                [cell.contentView setBackgroundColor:[UIColor clearColor]];
            }
            
            [((TodoDetailTableviewCell *)cell).lab_name setText:[[[self.todoInfo getTodoInfoDic] allKeys] objectAtIndex:row]];
            [((TodoDetailTableviewCell *)cell).lab_value setText:[[[self.todoInfo getTodoInfoDic] allValues] objectAtIndex:row]];
            if (isFullScrren) {
                [((TodoDetailTableviewCell *)cell) useLong];
            }else{
                [((TodoDetailTableviewCell *)cell) useSmall];
            }
            break;
        }
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:[IPad_TodoDetailViewController reuseIdentifier_attachmentFile]];
            if (cell==nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[IPad_TodoDetailViewController reuseIdentifier_attachmentFile]]autorelease];
                [cell.contentView setBackgroundColor:[UIColor clearColor]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
                [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
                [cell.textLabel setMinimumFontSize:16];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.detailTextLabel setMinimumFontSize:12];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 49, 920, 2)];
                [imageView setImage:[UIImage imageNamed:@"bg_15linelong.png"]];
                [cell.contentView addSubview:imageView];
                [imageView release];
            }
            AttachFileInfo *attachFileInfo = [self.attachmentFileArr objectAtIndex:row];
            [cell.textLabel setText:attachFileInfo.fileName];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@文件  大小:%@K   上传时间:%@",attachFileInfo.fileExtName, attachFileInfo.fileSize,attachFileInfo.uploadDate]];
          
            break;
        }
        case 3:{
            cell = [tableView dequeueReusableCellWithIdentifier:[IPad_TodoDetailViewController reuseIdentifier_approve]];
            if (cell==nil) {
                cell = [[[ApproveTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[IPad_TodoDetailViewController reuseIdentifier_approve]]autorelease];
                ((ApproveTableviewCell *)cell).delegate =self;
            }
            int row = [indexPath row];
            switch ([indexPath section]) {
                case 0:
                    [((ApproveTableviewCell *)cell) setApprovedInfo:[self.todoInfo.applyApprovedArr objectAtIndex:row]];
                    break;
                case 1:
                    [((ApproveTableviewCell *)cell) setApprovedInfo:[self.todoInfo.subApprovedArr objectAtIndex:row]];
                    break;
                case 2:
                    [((ApproveTableviewCell *)cell) setApprovedInfo:[self.todoInfo.backApplyApprovedArr objectAtIndex:row]];
                    break;
                default:
                    break;
            }
            if (isFullScrren) {
                [((ApproveTableviewCell *)cell) useLong];
            }else{
                [((ApproveTableviewCell *)cell) useSmall];
            }
        }
        default:
            break;
    }
    return cell;
    
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat resp = 0.0;
    switch (tableView.tag) {
        case 1:{
            int row = [indexPath row];
            NSString *value = [[[self.todoInfo getTodoInfoDic] allValues] objectAtIndex:row];
            if (value==nil) {
                value = @" ";
            }
            CGSize theStringSize;
            if (isFullScrren) {
                theStringSize = [value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(753.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
            }else{
                theStringSize = [value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(409.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
            }
            resp = 27+theStringSize.height;
            break;
        }
        case 2:{
            resp = 50;
            break;
        }
        case 3:{
            int row = [indexPath row];
             NSString *value =@"";
            ApprovedInfo *approvedInfo = nil;
            switch ([indexPath section]) {
                case 0:
                    approvedInfo = [self.todoInfo.applyApprovedArr objectAtIndex:row];
                    break;
                case 1:
                    approvedInfo = [self.todoInfo.subApprovedArr objectAtIndex:row];
                    break;
                case 2:
                    approvedInfo = [self.todoInfo.backApplyApprovedArr objectAtIndex:row];
                    break;
                default:
                    break;
            }
            value = approvedInfo.remark;
            if (value==nil) {
                value = @" ";
            }
            CGSize theStringSize;
            if (isFullScrren) {
                theStringSize = [value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(845.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
            }else{
                theStringSize = [value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(523.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
            }
            resp = 70+theStringSize.height;
            break;
        }
        default:
            break;
    }
    
    
    return resp;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *resp =@"";
    switch (tableView.tag) {
        case 3:
            switch (section) {
                case 0:{
                    if (self.todoInfo.applyApprovedArr!=nil&&[self.todoInfo.applyApprovedArr count]>0) {
                        resp=@"部门内流转意见";
                    }
                    break;
                }
                case 1:{
                    if (self.todoInfo.subApprovedArr!=nil&&[self.todoInfo.subApprovedArr count]>0) {
                        resp=@"送达部门流转意见";
                    }
                    break;
                }
                case 2:{
                    if (self.todoInfo.backApplyApprovedArr!=nil&&[self.todoInfo.backApplyApprovedArr count]>0) {
                        resp=@"提交部门流转意见";
                    }
                    break;
                }
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return  resp;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 2:{
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    switch (tableView.tag) {
        case 2:{
            AttachFileInfo *attachFileInfo = [self.attachmentFileArr objectAtIndex:row];
            STOService *service = [[STOService alloc]init];
            AttachFileInfo *respFileInfo = [service getAttachFileDietail:attachFileInfo];
            [service release];
            if (respFileInfo!=nil) {
                if (delegate) {
                    [delegate openAttachmentFile:attachFileInfo];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"文件获取失败，请稍后再试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            
            break;
        }
        default:
            break;
    }
}


#pragma mark - UIWebviewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    isLoadedWebview = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    isLoadedWebview = NO;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view_process setFrame:CGRectMake(0, 105, self.view_process.frame.size.width, self.view_process.frame.size.height)];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view_process setFrame:CGRectMake(0, 425, self.view_process.frame.size.width, self.view_process.frame.size.height)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.txtview_process isFirstResponder] && [touch view] != self.txtview_process) {
        [self.txtview_process resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}



#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.bt_play_record setEnabled:YES];
    [self.bt_recordDelete setEnabled:YES];
    [self.bt_process_save setEnabled:YES];
    [self.bt_process_cancel setEnabled:YES];
    [self.bt_process_record setEnabled:YES];
    [self.bt_process_submmit setEnabled:YES];
    isplaying = NO;
    
}
@end
