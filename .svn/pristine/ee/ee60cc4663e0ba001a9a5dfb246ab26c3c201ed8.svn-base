//
//  IPhone_TodoDetailInfoViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import "IPhone_TodoDetailInfoViewController.h"
#import "TodoDetailTableviewCell.h"
@interface IPhone_TodoDetailInfoViewController ()
+(NSString *)reuseIdentifier;
@end

@implementation IPhone_TodoDetailInfoViewController
@synthesize tabbarDelegate;
@synthesize lab_todoName;
@synthesize tableview;
@synthesize todoInfo;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLab_todoName:nil];
    [self setTableview:nil];
    [self setLab_todoName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
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

- (IBAction)action_showNotice:(id)sender {
}

- (IBAction)action_process:(id)sender {
    if (detailViewControllerDelegate) {
        [detailViewControllerDelegate processTodo:self.todoInfo];
    }
}
- (void)dealloc {
    [lab_todoName release];
    [tableview release];
    [super dealloc];
}

#pragma mark - privte method
+(NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.todoInfo==nil?0:[[[self.todoInfo getTodoInfoDic] allKeys] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    int row = [indexPath row];
    cell = (TodoDetailTableviewCell *)[tableView dequeueReusableCellWithIdentifier:[IPhone_TodoDetailInfoViewController reuseIdentifier]];
    if (cell == nil) {
        cell = [[[TodoDetailTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[IPhone_TodoDetailInfoViewController reuseIdentifier]] autorelease];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    [((TodoDetailTableviewCell *)cell).lab_name setText:[[[self.todoInfo getTodoInfoDic] allKeys] objectAtIndex:row]];
    [((TodoDetailTableviewCell *)cell).lab_value setText:[[[self.todoInfo getTodoInfoDic] allValues] objectAtIndex:row]];return cell;
    
    return cell;
    
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat resp = 0.0;
    int row = [indexPath row];
    NSString *value = [[[self.todoInfo getTodoInfoDic] allValues] objectAtIndex:row];
    if (value==nil) {
        value = @" ";
    }
    CGSize theStringSize = [value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];    resp = 27+theStringSize.height;
    
    return resp;
}

@end
