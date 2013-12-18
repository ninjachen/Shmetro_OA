//
//  IPhone_TodoProcessViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/21/12.
//
//

#import "IPhone_TodoProcessViewController.h"
#import "TodoInfoDao.h"
#import "STOService.h"
#import "FileUploadContext.h"
@interface IPhone_TodoProcessViewController ()
- (void)startToRecord;
- (void)endRecord;
-(void)closeProcessView;
-(void)timerFire:(id)sender;
@end

@implementation IPhone_TodoProcessViewController
@synthesize todoInfo;
@synthesize lab_todoTitle;
@synthesize bt_recordDelete;
@synthesize bt_process_save;
@synthesize bt_process_cancel;
@synthesize bt_process_record;
@synthesize txt_content;
@synthesize bt_play_record;
@synthesize img_recording;
@synthesize img_playing1;
@synthesize img_playing2;
@synthesize img_playing3;
@synthesize playTimer;
@synthesize isplaying;
@synthesize recordPath;
@synthesize view_record;
@synthesize audioPlayer,m_isRecording;
int recordingCount;
int playCount;
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
    if ([self.todoInfo.steplabel isEqualToString:@"部门领导审核"]) {
        [self.bt_process_record setHidden:NO];
    }else{
        [self.bt_process_record setHidden:YES];
    }
    [lab_todoTitle setText:todoInfo.title];
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
    
    if (self.todoInfo.recordPath!=nil&&![self.todoInfo.recordPath isEqualToString:@""]) {
        self.recordPath = self.todoInfo.recordPath;
        [self.view_record setHidden:NO];
    }
    if (todoInfo.processText!=nil) {
        [self.txt_content setText:todoInfo.processText];
    }
}

- (void)viewDidUnload
{
    [self setTxt_content:nil];
    [self setImg_recording:nil];
    [self setView_record:nil];
    [self setImg_playing1:nil];
    [self setImg_playing2:nil];
    [self setImg_playing3:nil];
    [self setBt_play_record:nil];
    [self setBt_recordDelete:nil];
    [self setBt_process_save:nil];
    [self setBt_process_cancel:nil];
    [self setBt_process_record:nil];
    [self setLab_todoTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    [playTimer release];
    [todoInfo release];
    [txt_content release];
    [img_recording release];
    [view_record release];
    [img_playing1 release];
    [img_playing2 release];
    [img_playing3 release];
    [bt_play_record release];
    [bt_recordDelete release];
    [bt_process_save release];
    [bt_process_cancel release];
    [bt_process_record release];
    [lab_todoTitle release];
    [super dealloc];
}

-(id)init:(TodoInfo *)todoInfoObj{
    self = [super init];
    if (self) {
        self.todoInfo = todoInfoObj;
        self.recordPath = @"";
        self.isplaying = NO;
        playCount = 0;
        recordingCount=0;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private method
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
                [img_recording setImage:[UIImage imageNamed:@"iphone_ic_micphone_2.png"]];
                recordingCount++;
                break;
            case 1:
                [img_recording setImage:[UIImage imageNamed:@"iphone_ic_micphone_3.png"]];
                recordingCount++;
                break;
            case 2:
                [img_recording setImage:[UIImage imageNamed:@"iphone_ic_micphone_1.png"]];
                recordingCount=0;
                break;
            default:
                break;
        }
        
    }
}
#pragma mark - public mehtod

- (IBAction)action_cancel:(id)sender {
    self.todoInfo.recordPath = self.recordPath;
    self.todoInfo.processText = self.txt_content.text;
    TodoInfoDao *dao = [[TodoInfoDao alloc]init];
    [dao update:self.todoInfo];
    [dao release];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)action_submit:(id)sender {
    if (self.txt_content.text==nil||[self.txt_content.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请输入您的处理意见" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    self.todoInfo.recordPath = self.recordPath;
    self.todoInfo.processText = self.txt_content.text;
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
- (IBAction)action_playrecord:(UIButton *)sender{
    [self.bt_play_record setEnabled:NO];
    [self.bt_recordDelete setEnabled:NO];
    [self.bt_process_save setEnabled:NO];
    [self.bt_process_cancel setEnabled:NO];
    [self.bt_process_record setEnabled:NO];
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

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.view.center = CGPointMake(160,120);
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.view.center = CGPointMake(160,230);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.txt_content isFirstResponder] && [touch view] != self.txt_content) {
        [self.txt_content resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text] == YES){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.bt_play_record setEnabled:YES];
    [self.bt_recordDelete setEnabled:YES];
    [self.bt_process_save setEnabled:YES];
    [self.bt_process_cancel setEnabled:YES];
    [self.bt_process_record setEnabled:YES];
    isplaying = NO;
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:{
            [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:1] animated:YES];
            break;
        }
        default:
            break;
    }
}
@end
