//
//  SearchViewController.m
//  ShmetroOA
//
//  Created by caven shen on 10/30/12.
//
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
@interface SearchViewController ()
+(NSString *)reuseIdentifier;
@end

@implementation SearchViewController
@synthesize mainViewDelegate;
@synthesize tableview;
@synthesize ipad_textFieldSearch;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self = [super initWithNibName:@"SearchViewController_iPhone" bundle:nil];
    } else {
        self = [super initWithNibName:@"SearchViewController_iPad" bundle:nil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
    } else {
        [self.tableview setScrollEnabled:NO];
        
    }
}

- (void)viewDidUnload
{
    [self setTableview:nil];
    [self setIpad_textFieldSearch:nil];
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
#pragma mark - PrivateMethod
+(NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - MainViewControllerDelegate
-(void)viewDetail_iPad:(id)obj{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
    }else{
        if(mainViewDelegate){
            [mainViewDelegate viewDetail_iPad:obj];
        }
    }
}
- (void)dealloc {
    [tableview release];
    [ipad_textFieldSearch release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 0;
    } else {
        return 7;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return nil;
    } else {
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchViewController reuseIdentifier]];
        if (cell==nil) {
            cell = [[[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SearchViewController reuseIdentifier]]autorelease];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        [cell.img_title setImage:[UIImage imageNamed:[NSString stringWithFormat:@"zi0%d.png",[indexPath row]+1]]];
        return cell;
    }
    
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 40;
    } else {
        return 65;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
    } else {
        if (self.mainViewDelegate) {
            NSString *indexStr = [[NSString alloc]initWithFormat:@"%d",[indexPath row]+2];
            [mainViewDelegate viewDetail_iPad:indexStr];
            [indexStr release];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string] == YES){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    self.view.center = CGPointMake(160,120);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    self.view.center = CGPointMake(160,230);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.ipad_textFieldSearch isFirstResponder] && [touch view] != self.ipad_textFieldSearch) {
        [self.ipad_textFieldSearch resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}
@end
