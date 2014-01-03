//
//  FileReaderViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/7/12.
//
//

#import <UIKit/UIKit.h>
#import "AttachFileInfo.h"
#import "CL_VoiceEngine.h"
@interface FileReaderViewController : UIViewController<UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic,retain) AttachFileInfo *fileInfo;
@property (retain, nonatomic) IBOutlet UIProgressView *progressView;
@property (retain, nonatomic) IBOutlet UIView *view_download;
@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
- (IBAction)action_close:(id)sender;
-(id)init:(AttachFileInfo *)attachFileInfo;
@end
