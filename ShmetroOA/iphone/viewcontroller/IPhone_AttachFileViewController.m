//
//  IPhone_AttachFileViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/20/12.
//
//

#import "IPhone_AttachFileViewController.h"
#import "FileReaderViewController.h"
#import "STOService.h"
@interface IPhone_AttachFileViewController ()
+(NSString *)reuseIdentifier;
@end

@implementation IPhone_AttachFileViewController
@synthesize attachmentFileArr;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [attachmentFileArr release];
    [super dealloc];
}
- (IBAction)action_close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - PrivateMethod
+(NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attachmentFileArr==nil?0:[self.attachmentFileArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[IPhone_AttachFileViewController reuseIdentifier]];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[IPhone_AttachFileViewController reuseIdentifier]] autorelease];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.textLabel setMinimumFontSize:16];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.detailTextLabel setMinimumFontSize:12];
    }
    AttachFileInfo *attachFileInfo = [self.attachmentFileArr objectAtIndex:[indexPath row]];
    [cell.textLabel setText:attachFileInfo.fileName];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@文件 %@",attachFileInfo.fileExtName,attachFileInfo.uploadDate]];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttachFileInfo *attachFileInfo = [self.attachmentFileArr objectAtIndex:[indexPath row]];
    STOService *service = [[STOService alloc]init];
    AttachFileInfo *respFileInfo = [service getAttachFileDietail:attachFileInfo];
    [service release];
    if (respFileInfo!=nil) {
        FileReaderViewController *fileReaderController = [[FileReaderViewController alloc]init:respFileInfo];
        [self presentModalViewController:fileReaderController animated:YES];
        [fileReaderController release];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"文件获取失败，请稍后再试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
