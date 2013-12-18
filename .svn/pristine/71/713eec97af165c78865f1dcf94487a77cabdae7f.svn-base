//
//  IPhone_TodoDetailMonitorViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
#import "TodoInfo.h"
@interface IPhone_TodoDetailMonitorViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, assign) id<TabbarViewControllerDelegate> tabbarDelegate;
@property (nonatomic, assign) id<DetailViewControllerDelegate> detailViewControllerDelegate;
@property (retain, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic,retain) TodoInfo *todoInfo;
- (IBAction)action_back:(id)sender;
- (IBAction)action_process:(id)sender;
-(id)init:(TodoInfo *)todoInfoObj;
@end
