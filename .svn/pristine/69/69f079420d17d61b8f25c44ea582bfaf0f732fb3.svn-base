//
//  IPhone_TodoDetailApproveViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import "IPhone_TodoDetailApproveViewController.h"
#import "ApproveTableviewCell.h"
#import "AttachFileInfo.h"
#import "STOService.h"
#import "IPhone_AttachFileViewController.h"
@interface IPhone_TodoDetailApproveViewController ()
+(NSString *)reuseIdentifier;
@end

@implementation IPhone_TodoDetailApproveViewController
@synthesize tabbarDelegate;
@synthesize detailViewControllerDelegate;
@synthesize todoInfo;
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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)action_process:(id)sender {
    if (detailViewControllerDelegate) {
        [detailViewControllerDelegate processTodo:self.todoInfo];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(id)init:(TodoInfo *)todoInfoObj{
    self = [super init];
    if (self) {
        self.todoInfo = todoInfoObj;
    }
    return self;
}

-(void)dealloc{
    [todoInfo release];
    [super release];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - privte method
+(NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}
#pragma mark - public method
- (IBAction)action_back:(id)sender {
    if (tabbarDelegate) {
        [tabbarDelegate hiddenTabbar:YES];
    }
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int resp = 0;
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
    return resp;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    int row = [indexPath row];
    cell = [tableView dequeueReusableCellWithIdentifier:[IPhone_TodoDetailApproveViewController reuseIdentifier]];
    if (cell==nil) {
        cell = [[ApproveTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[IPhone_TodoDetailApproveViewController reuseIdentifier]];
        ((ApproveTableviewCell *)cell).delegate =self;
    }
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
    [((ApproveTableviewCell *)cell) usePhone];
    return cell;
    
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat resp = 0.0;
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
    CGSize theStringSize = [value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
       resp = 70+theStringSize.height;
    
    
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

#pragma mark - DetailViewControllerDelegate

-(void)getAttachfileArr:(NSString *)fileGroupId UIButton:(UIButton *)btn{
    STOService *service = [[STOService alloc]init];
    NSArray *fileArr = [service searchAttachFileList:fileGroupId];
    [service release];
    IPhone_AttachFileViewController *attachFileController = [[[IPhone_AttachFileViewController alloc]init] autorelease];
    attachFileController.attachmentFileArr = fileArr;
    [self presentModalViewController:attachFileController animated:YES];
}
@end
