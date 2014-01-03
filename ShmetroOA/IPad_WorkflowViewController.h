//
//  IPad_WorkflowViewController.h
//  ShmetroOA
//
//  Created by gisteam on 8/14/13.
//
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "WorkflowInfo.h"
#import "WFApprovedInfo.h"
#import "AttachFileInfo.h"


@interface IPad_WorkflowViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(retain,nonatomic)WorkflowInfo *workflowInfo;
@property(retain,nonatomic)NSArray *workflowDocumentArr;
@property(retain,nonatomic)NSArray *attachFileArr;
@property(retain,nonatomic)NSDictionary *wfApprovedInfoDict;
@property(retain,nonatomic)NSString *choice;

@property (retain, nonatomic) IBOutlet UIView *view_info;
@property (retain, nonatomic) IBOutlet UIView *view_file;
@property (retain, nonatomic) IBOutlet UIView *view_approve;

@property (retain, nonatomic) IBOutlet UITableView *tableview_info;
@property (retain, nonatomic) IBOutlet UITableView *tableview_approve;
@property (retain, nonatomic) IBOutlet UITableView *tableview_file;

@property (retain, nonatomic) IBOutlet UIImageView *imgview_bg;
@property (retain, nonatomic) IBOutlet UIButton *btn_full;
@property (retain, nonatomic) IBOutlet UIButton *btn_small;
@property (retain, nonatomic) IBOutlet UIButton *bt_notice;

@property (retain, nonatomic) IBOutlet UIButton *bt_1;
@property (retain, nonatomic) IBOutlet UIButton *bt_2;
@property (retain, nonatomic) IBOutlet UIButton *bt_3;

@property (retain, nonatomic) IBOutlet UIButton *bt_todoProcess;
@property (retain, nonatomic) IBOutlet UIView *view_process;
@property (retain, nonatomic) IBOutlet UITextView *txtview_process;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_save;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_cancel;
@property (retain, nonatomic) IBOutlet UIButton *bt_process_submmit;
@property (retain, nonatomic) IBOutlet UIButton *bt_agree;
@property (retain, nonatomic) IBOutlet UIButton *bt_disagree;
@property (retain, nonatomic) IBOutlet UIImageView *img_process_bg;
@property (retain, nonatomic) IBOutlet UIImageView *img_process_text_bg;

@property (nonatomic, assign) id<MainViewControllerDelegate> delegate;

-(id)init:(WorkflowInfo *)workflowInfoObj;

- (IBAction)action_changeScrren:(UIButton *)sender;
- (IBAction)action_processTodo:(id)sender;
- (IBAction)action_process_submit:(id)sender;
- (IBAction)action_process_save:(id)sender;
- (IBAction)action_process_cancel:(id)sender;
- (IBAction)menu_select:(id)sender;
-(IBAction)action_agree:(id)sender;
@end
