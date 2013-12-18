//
//  IPad_WorkflowViewController.m
//  ShmetroOA
//
//  Created by gisteam on 8/14/13.
//
//

#import "IPad_WorkflowViewController.h"
#import "STOService.h"
#import "AppDelegate.h"
#import "UIViewUtil.h"
#import "WorkflowDao.h"
#import "ApproveTableviewCell.h"
#import "TodoDetailTableviewCell.h"
#import "AttachFileInfoDao.h"

@interface IPad_WorkflowViewController ()

-(void)reloadBasicData;
-(void)reloadAttachmentFile;
-(void)reloadApprovedFile;
-(void)showDetailContent:(int)tag;
-(void)closeProcessView;
@end

@implementation IPad_WorkflowViewController
@synthesize view_file,view_approve,view_info;
@synthesize tableview_approve,tableview_file,tableview_info;
@synthesize btn_full,btn_small,bt_notice;
@synthesize bt_1,bt_2,bt_3;
@synthesize bt_todoProcess;
@synthesize view_process,txtview_process;
@synthesize bt_process_submmit,bt_process_save,bt_process_cancel,bt_agree,bt_disagree,img_process_bg,img_process_text_bg;
@synthesize workflowInfo,workflowDocumentArr,wfApprovedInfoDict,attachFileArr,choice;
@synthesize delegate;

int oldTag;
BOOL isFullScrren;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init:(WorkflowInfo *)workflowInfoObj{
    self = [super init];
    if (self) {
        self.workflowInfo = workflowInfoObj;
        oldTag = 1;
        isFullScrren = NO;
        self.choice=@"1";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   [self reloadBasicData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action_changeScrren:(UIButton *)sender {
    switch (oldTag) {
        case 1:{
            [view_info setHidden:NO];
            [view_file setHidden:YES];
            [view_approve setHidden:YES];
            [self.tableview_info reloadData];
            break;
        }
        case 2:{
            [view_info setHidden:YES];
            [view_file setHidden:NO];
            [view_approve setHidden:YES];
            [self.tableview_file reloadData];
            break;
        }
        case 3:{
            [view_info setHidden:YES];
            [view_file setHidden:YES];
            [view_approve setHidden:NO];
            [self.tableview_approve reloadData];
            break;
        }
        case 4:{
            [view_info setHidden:YES];
            [view_file setHidden:YES];
            [view_approve setHidden:YES];
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
            [self.bt_1 setFrame:CGRectMake(973, 351, 45, 148)];
            [self.bt_2 setFrame:CGRectMake(973, 451, 45, 148)];
            [self.bt_3 setFrame:CGRectMake(973, 551, 45, 148)];
            [self.bt_todoProcess setFrame:CGRectMake(400, 652, 170, 40)];
            [self.imgview_bg setImage:[UIImage imageNamed:@"img_note.png"]];
            [self.view_info setFrame:CGRectMake(32, 114, 920, 522)];
            [self.view_file setFrame:CGRectMake(32, 114, 920, 522)];
            [self.view_approve setFrame:CGRectMake(15, 114, 953, 522)];
            [self.tableview_info setFrame:CGRectMake(0, 0, 920, 522)];
            [self.tableview_file setFrame:CGRectMake(0, 0, 920, 522)];
            [self.tableview_approve setFrame:CGRectMake(0, 0, 953, 522)];
            
            [self.view_process setFrame:CGRectMake(self.view_process.frame.origin.x, self.view_process.frame.origin.y, 1024, 323)];
            [self.img_process_bg setFrame:CGRectMake(self.img_process_bg.frame.origin.x, self.img_process_bg.frame.origin.y, 1024, self.img_process_bg.frame.size.height)];
            [self.img_process_bg setImage:[UIImage imageNamed:@"bg_blue_big.png"]];
            
            [self.img_process_text_bg setFrame:CGRectMake(self.img_process_text_bg.frame.origin.x, self.img_process_text_bg.frame.origin.y, 936, self.img_process_text_bg.frame.size.height)];
            [self.img_process_text_bg setImage:[UIImage imageNamed:@"bg_input_big.png"]];
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
            [self.bt_1 setFrame:CGRectMake(628, 351, 45, 148)];
            [self.bt_2 setFrame:CGRectMake(628, 451, 45, 148)];
            [self.bt_3 setFrame:CGRectMake(628, 551, 45, 148)];
            [self.bt_todoProcess setFrame:CGRectMake(254, 652, 170, 40)];
            [self.imgview_bg setImage:[UIImage imageNamed:@"img_note_small.png"]];
            [self.view_info setFrame:CGRectMake(32, 114, 580, 522)];
            [self.view_file setFrame:CGRectMake(32, 114, 580, 522)];
            [self.view_approve setFrame:CGRectMake(15, 114, 613, 522)];
            [self.tableview_info setFrame:CGRectMake(0, 0, 580, 522)];
            [self.tableview_file setFrame:CGRectMake(0, 0, 580, 522)];
            [self.tableview_approve setFrame:CGRectMake(0, 0, 613, 522)];
            
            [self.view_process setFrame:CGRectMake(self.view_process.frame.origin.x, self.view_process.frame.origin.y, 679, 323)];
            [self.img_process_bg setFrame:CGRectMake(self.img_process_bg.frame.origin.x, self.img_process_bg.frame.origin.y, 679, self.img_process_bg.frame.size.height)];
            [self.img_process_bg setImage:[UIImage imageNamed:@"bg_16done.png"]];
            
            [self.img_process_text_bg setFrame:CGRectMake(self.img_process_text_bg.frame.origin.x, self.img_process_text_bg.frame.origin.y, 589, self.img_process_text_bg.frame.size.height)];
            [self.img_process_text_bg setImage:[UIImage imageNamed:@"bg_17input.png"]];
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

- (IBAction)action_processTodo:(id)sender{
    [self.view bringSubviewToFront:self.view_process];
    
    if (workflowInfo.processText!=nil) {
        [self.txtview_process setText:[NSString stringWithFormat:@"%@\n",workflowInfo.processText]];
        [self.txtview_process setText:workflowInfo.processText];
    }else{
        [self.txtview_process setText:@"\n"];
        [self.txtview_process setText:@""];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [self.view_process setFrame:CGRectMake(0, 425, self.view_process.frame.size.width, self.view_process.frame.size.height)];
    
    [UIView commitAnimations];
}

- (IBAction)action_process_submit:(id)sender{
    STOService *service = [[STOService alloc]init];
    BOOL result = [service docSendLeaderDealWithPid:self.workflowInfo.pid Choice:self.choice Suggest:self.txtview_process.text];

    [service release];
    [self closeProcessView];
}

- (IBAction)action_process_save:(id)sender{
    self.workflowInfo.processText = self.txtview_process.text;
    WorkflowDao *dao = [[WorkflowDao alloc]init];
    [dao update:self.workflowInfo];
    [dao release];
    [self closeProcessView];
}

- (IBAction)action_process_cancel:(id)sender{
    [self.txtview_process setText:@""];
    [self closeProcessView];
}

-(IBAction)action_agree:(id)sender{
    UIButton *btn = sender;
    switch (btn.tag) {
        case 0:
            self.choice=@"1";
            [self.bt_disagree setImage:[UIImage imageNamed:@"disagree.png"] forState:UIControlStateNormal];
            [self.bt_agree setImage:[UIImage imageNamed:@"agree.png"] forState:UIControlStateNormal];
            break;
            
        case 1:
            self.choice=@"2";
            [self.bt_disagree setImage:[UIImage imageNamed:@"agree.png"] forState:UIControlStateNormal];
            [self.bt_agree setImage:[UIImage imageNamed:@"disagree.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

-(IBAction)menu_select:(id)sender{
    UIButton *button = sender;
    switch (button.tag) {
        case 1:{
            [self.view bringSubviewToFront:self.bt_3];
            [self.view bringSubviewToFront:self.bt_2];
            break;
        }
        case 2:{
            [self.view bringSubviewToFront:self.bt_3];
            [self.view bringSubviewToFront:self.bt_1];
            break;
        }
        case 3:{
            [self.view bringSubviewToFront:self.bt_1];
            [self.view bringSubviewToFront:self.bt_2];
            break;
        }
        default:
            break;
    }
    [self.view bringSubviewToFront:sender];
    [self showDetailContent:button.tag];
}

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
            default:
                break;
        }
        switch (tag) {
            case 1:
                destView = self.view_info;
                [self reloadBasicData];
                break;
            case 2:
                destView = self.view_file;
                [self reloadAttachmentFile];
                break;
            case 3:
                destView = self.view_approve;
                [self reloadApprovedFile];
              //  [self.tableview_approve reloadData];
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
                    break;
                }
                case 2:{
                    [view_info setHidden:YES];
                    [view_file setHidden:NO];
                    [view_approve setHidden:YES];
                    
                    break;
                }
                case 3:{
                    [view_info setHidden:YES];
                    [view_file setHidden:YES];
                    [view_approve setHidden:NO];
                    break;
                }
                case 4:{
                    [view_info setHidden:YES];
                    [view_file setHidden:YES];
                    [view_approve setHidden:YES];
                    break;
                }
                default:
                    break;
            }
            
        });
    }    
}

-(void)closeProcessView{
    [self.txtview_process resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [self.view_process setFrame:CGRectMake(0, 748, self.view_process.frame.size.width, self.view_process.frame.size.height)];
    [UIView commitAnimations];
}

-(void)reloadBasicData{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
    NSString  *pid = self.workflowInfo.pid;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STOService *service = [[STOService alloc]init];
        self.workflowInfo = [service getWorkflowInfoDetail:pid];
        [service release];
        
        AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
        self.workflowDocumentArr =[dao searchDocumentList:pid];
        [dao release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate closeLoading];
            [self.tableview_info reloadData];
        });
    });
}

-(void)reloadAttachmentFile{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
    NSString  *pid = self.workflowInfo.pid;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STOService *service = [[STOService alloc]init];
        self.attachFileArr = [service searchDocSendAttachFileList:pid];
        [service release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate closeLoading];
            [self.tableview_file reloadData];
        });
    });
}
-(void)reloadApprovedFile{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showLoadingWithText:@"正在载入..." inView:self.view];
    NSString  *pid = self.workflowInfo.pid;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STOService *service = [[STOService alloc]init];
        self.wfApprovedInfoDict = [service searchDocSendApproveInfoList:pid];
        [service release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate closeLoading];
            [self.tableview_approve reloadData];
        });
    });
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int num = 1;
    switch (tableView.tag) {
        case 1:
            num = 2;
            break;
            
        case 3:
            num = 6;
            break;
            
        default:
            break;
    }
    
    return num;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num = 0;
    switch (tableView.tag) {
        case 1:
            switch (section) {
                case 0:
                    num = 10;
                    break;
                    
                case 1:
                    num = self.workflowDocumentArr.count;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            num = self.attachFileArr==nil?0:self.attachFileArr.count;
            break;
            
        case 3:
            switch (section) {
                case 5:
                    num = 2;
                    break;
                    
                default:
                    num = 1;
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    int section = [indexPath section];
    UITableViewCell *cell = nil;
    switch (tableView.tag) {
        case 1:{
            switch (section) {
                case 0:
                    cell = (TodoDetailTableviewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_basicFileIdentifier"];
                    if (cell == nil) {
                        cell = [[[TodoDetailTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_basicFileIdentifier"] autorelease];
                        [cell.contentView setBackgroundColor:[UIColor clearColor]];
                    }
                    NSString *fieldName = @"";
                    NSString *fieldValue = @"";
                    switch (row) {
                        case 0:
                            fieldName = @"标题";
                            fieldValue=self.workflowInfo.docTitle;
                            break;
                           
                        case 1:
                            fieldName = @"发文字号";
                            fieldValue=self.workflowInfo.sendId;
                            break;
                            
                        case 2:
                            fieldName = @"文别";
                            fieldValue=self.workflowInfo.docClass;
                            break;
                            
                        case 3:
                            fieldName = @"密别";
                            fieldValue=self.workflowInfo.secretClass;
                            break;
                            
                        case 4:
                            fieldName = @"缓急";
                            fieldValue=self.workflowInfo.hj;
                            break;
                            
                        case 5:
                            fieldName = @"文件类型";
                            fieldValue=self.workflowInfo.fileType;
                            break;
                            
                        case 6:
                            fieldName = @"保密期限";
                            fieldValue=self.workflowInfo.secretLimit==nil?@" ":[NSString stringWithFormat:@"%@年",self.workflowInfo.secretLimit];
                            break;
                            
                        case 7:
                            fieldName = @"主送单位";
                            fieldValue=self.workflowInfo.sendMain;
                            break;
                            
                        case 8:
                            fieldName = @"抄送单位";
                            fieldValue=self.workflowInfo.sendCopy;
                            break;
                            
                        case 9:
                            fieldName = @"内发";
                            fieldValue=self.workflowInfo.sendInside;
                            break;
                        default:
                            break;
                    }
                    fieldValue = fieldValue==nil?@" ":fieldValue;
                    [((TodoDetailTableviewCell *)cell).lab_name setText:fieldName];
                    [((TodoDetailTableviewCell *)cell).lab_value setText:fieldValue];
                     if (isFullScrren) {
                        [((TodoDetailTableviewCell *)cell) useLong];
                    }else{
                        [((TodoDetailTableviewCell *)cell) useSmall];
                    }
                    break;
                    
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell_attachFileIdentifier"];
                    if (cell==nil) {
                        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_attachFileIdentifier"]autorelease];
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
                    AttachFileInfo *attachFileInfo = [self.workflowDocumentArr objectAtIndex:row];
                    [cell.textLabel setText:attachFileInfo.fileName];
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@文件  大小:%@K   上传人:%@  上传时间:%@        备注:%@",attachFileInfo.fileExtName, attachFileInfo.fileSize,attachFileInfo.uploader,attachFileInfo.uploadDate,attachFileInfo.memo]];
                    break;
                default:
                    break;
            }
                       
            break;
        }
            
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_attachFileIdentifier"];
            if (cell==nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_attachFileIdentifier"]autorelease];
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
            AttachFileInfo *attachFileInfo = [self.attachFileArr objectAtIndex:row];
            [cell.textLabel setText:attachFileInfo.fileName];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@文件  大小:%@K   上传人:%@  上传时间:%@        备注:%@",attachFileInfo.fileExtName, attachFileInfo.fileSize,attachFileInfo.uploader,attachFileInfo.uploadDate,attachFileInfo.memo]];
            break;
          
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_approvedFileIdentifier"];
            if (cell==nil) {
                cell = [[[ApproveTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_approvedFileIdentifier"]autorelease];
            }
          
            int row = [indexPath row];
            WFApprovedInfo *fileInfo = nil;
            switch ([indexPath section]) {
                case 0:
                {
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"签发"];
                    ((ApproveTableviewCell *)cell).lab_companyName.text = @"签发：";
                    break;
                }
                case 1:
                {
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"会签"];
                    ((ApproveTableviewCell *)cell).lab_companyName.text = @"会签：";
                    break;
                }
                case 2:
                {
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"拟稿"];
                    ((ApproveTableviewCell *)cell).lab_companyName.text = @"拟稿人：";
                    break;
                }
                    
                case 3:
                {
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"核搞"];
                    ((ApproveTableviewCell *)cell).lab_companyName.text = @"核搞人：";
                    break;
                }
                    
                case 4:
                {
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"校对"];
                    ((ApproveTableviewCell *)cell).lab_companyName.text = @"校对：";
                    break;
                }
                    
                case 5:
                {
                    switch (row) {
                        case 0:
                        {
                            fileInfo = [self.wfApprovedInfoDict valueForKey:@"套头意见"];
                            ((ApproveTableviewCell *)cell).lab_companyName.text = @"套头意见：";
                            break;
                        }
                        case 1:
                        {
                            fileInfo = [self.wfApprovedInfoDict valueForKey:@"办结人意见"];
                            ((ApproveTableviewCell *)cell).lab_companyName.text = @"办结人意见：";
                            break;
                        }
                            
                        default:
                            break;
                    }
                  
                    break;
                }
                    
                    
                default:
                    break;
            }
            [((ApproveTableviewCell *)cell).btn_file setHidden:YES];
            ((ApproveTableviewCell *)cell).lab_content.text = fileInfo.remark ==nil?@" ":fileInfo.remark;
            NSString *userFullName = fileInfo.userFullName==nil?@"":fileInfo.userFullName;
            NSString *upddateStr = fileInfo.upddateStr==nil?@"":fileInfo.upddateStr;
            ((ApproveTableviewCell *)cell).lab_date.text = [NSString stringWithFormat:@"%@  %@",userFullName,upddateStr];
            
            if (isFullScrren) {
                [((ApproveTableviewCell *)cell) useLong];
            }else{
                [((ApproveTableviewCell *)cell) useSmall];
            }
            break;
            
        default:
            break;
    }

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    switch (tableView.tag) {
        case 1:
            if (section == 1) {
                title = [NSString stringWithFormat:@"正式文件  (印制份数:%@    印发日期:%@)",self.workflowInfo.docCount,self.workflowInfo.sendDate];
            }
//            else if(section == 0){
//                title = @"基本信息";
//            }
            break;
            
        case 3:
            switch (section) {
//                case 0:
//                    title = @"签发";
//                    break;
//                    
//                case 1:
//                    title = @"会签";
//                    break;
                    
                case 2:
                    title = @"拟稿部门";
                    break;
                    
                case 3:
                    title = @"核稿部门";
                    break;
                    
//                case 4:
//                    title = @"校对";
//                    break;
                    
                case 5:
                    title = @"办理情况";
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return title;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat resp = 0.0;
    switch (tableView.tag) {
        case 1:{
            switch ([indexPath section]) {
                case 0:
                {
                    int row = [indexPath row];
                    NSString *value = @"";
                    switch (row) {
                        case 0:
                            value = self.workflowInfo.docTitle;
                            break;
                        case 1:
                            value = self.workflowInfo.sendId;
                            break;
                        case 2:
                            value = self.workflowInfo.docClass;
                            break;
                        case 3:
                            value = self.workflowInfo.secretClass;
                            break;
                        case 4:
                            value = self.workflowInfo.hj;
                            break;
                        case 5:
                            value = self.workflowInfo.fileType;
                            break;
                        case 6:
                            value = self.workflowInfo.secretLimit;
                            break;
                        case 7:
                            value = self.workflowInfo.sendMain;
                            break;
                        case 8:
                            value = self.workflowInfo.sendCopy;
                            break;
                        case 9:
                            value = self.workflowInfo.sendInside;
                            break;
                            
                        default:
                            break;
                    }
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
                  
                case 1:
                    resp = 50;
                    break;
                    
                default:
                    break;
            }
            
            break;
      }
        case 2:{
            resp = 50;
            break;
        }
        case 3:{
            int row = [indexPath row];
            NSString *value =@"";
            WFApprovedInfo *fileInfo = nil;
            switch ([indexPath section]) {
                case 0:
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"签发"];
                    break;
                case 1:
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"会签"];
                    break;
                case 2:
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"拟稿"];
                    break;
                case 3:
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"核搞"];
                    break;
                case 4:
                    fileInfo = [self.wfApprovedInfoDict valueForKey:@"校对"];
                    break;
                case 5:
                {
                    switch (row) {
                        case 0:
                            fileInfo = [self.wfApprovedInfoDict valueForKey:@"套头意见"];
                            break;
                            
                        case 1:
                            fileInfo = [self.wfApprovedInfoDict valueForKey:@"办结人意见"];
                            break;
                            
                        default:
                            break;
                    }
                }
                default:
                    break;
            }
            value = fileInfo.remark;
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    switch (tableView.tag) {
        case 1:{
            AttachFileInfo *attachFileInfo = [self.workflowDocumentArr objectAtIndex:row];
            if (attachFileInfo.fileId !=nil && ![attachFileInfo.fileId isEqualToString: @""]) {
                AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
                attachFileInfo.downloadUrl = [NSString stringWithFormat:@"http://10.1.40.40:8088/downloadFile.action?fileId=%@",attachFileInfo.fileId];
                [dao updateDocument:attachFileInfo];
                [dao release];
            }
          
            if (delegate) {
                [delegate openAttachmentFile:attachFileInfo];
            }
           
            break;
        }
        case 2:{
            AttachFileInfo *attachFileInfo = [self.attachFileArr objectAtIndex:row];
            if (attachFileInfo.fileId !=nil && ![attachFileInfo.fileId isEqualToString: @""]) {
                AttachFileInfoDao *dao = [[AttachFileInfoDao alloc]init];
              
               attachFileInfo.downloadUrl = [NSString stringWithFormat:@"http://10.1.40.40:8088/downloadFile.action?fileId=%@",attachFileInfo.fileId];
                [dao updateDocument:attachFileInfo];
                [dao release];
            }
            if (delegate) {
                [delegate openAttachmentFile:attachFileInfo];
            }
            break;
        }
        default:
            break;
    }
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

@end
