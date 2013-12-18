//
//  AttachFileArrayViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/6/12.
//
//

#import "AttachFileArrayViewController.h"
#import "AttachFileInfo.h"
#import "FileReaderViewController.h"
#import "STOService.h"

@interface AttachFileArrayViewController ()
+(NSString *)reuseIdentifier;
@end

@implementation AttachFileArrayViewController
@synthesize attachmentFileArr;
@synthesize detailViewControllerDelegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


-(void)dealloc{
    [attachmentFileArr release];
    [detailViewControllerDelegate release];
    [super dealloc];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AttachFileArrayViewController reuseIdentifier]];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[AttachFileArrayViewController reuseIdentifier]] autorelease];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    if (detailViewControllerDelegate) {
        [detailViewControllerDelegate closePopoverViewController];
    }
}

@end
