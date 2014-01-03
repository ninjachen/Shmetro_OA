//
//  IPhone_TodoDetailAttachFileViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import "IPhone_TodoDetailAttachFileViewController.h"
#import "AttachFileInfo.h"
#import "STOService.h"
#import "FileReaderViewController.h"
@interface IPhone_TodoDetailAttachFileViewController ()
+(NSString *)reuseIdentifier;
@end

@implementation IPhone_TodoDetailAttachFileViewController
@synthesize tabbarDelegate;
@synthesize tableview;
@synthesize todoInfo;
@synthesize attachmentFileArr;
@synthesize detailViewControllerDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init:(TodoInfo *)todoInfoObj{
    self = [super init];
    if (self) {
        self.todoInfo = todoInfoObj;
    }
    return self;
}

- (IBAction)action_process:(id)sender {
    if (detailViewControllerDelegate) {
        [detailViewControllerDelegate processTodo:self.todoInfo];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.attachmentFileArr = [self.todoInfo getContentAttachmentFileArr];
}

- (void)viewDidUnload
{
    [self setTableview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
- (void)dealloc {
    [attachmentFileArr release];
    [tableview release];
    [todoInfo release];
    [super dealloc];
}
#pragma mark - privte method
+(NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.attachmentFileArr==nil?0:[self.attachmentFileArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    int row = [indexPath row];

            cell = [tableView dequeueReusableCellWithIdentifier:[IPhone_TodoDetailAttachFileViewController reuseIdentifier]];
            if (cell==nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[IPhone_TodoDetailAttachFileViewController reuseIdentifier]]autorelease];
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
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@文件 %@",attachFileInfo.fileExtName,attachFileInfo.uploadDate]];

        return cell;
    
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    AttachFileInfo *attachFileInfo = [self.attachmentFileArr objectAtIndex:row];
    STOService *service = [[STOService alloc]init];
    AttachFileInfo *respFileInfo = [service getAttachFileDietail:attachFileInfo];
    [service release];
    if (respFileInfo!=nil) {
        FileReaderViewController *fileReaderViewController = [[[FileReaderViewController alloc]init:respFileInfo] autorelease];
        [self presentModalViewController:fileReaderViewController animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"文件获取失败，请稍后再试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
@end
