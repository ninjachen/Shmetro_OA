//
//  TodoListViewController.m
//  ShmetroOA
//
//  Created by caven shen on 10/10/12.
//
//

#import "TodoListViewController.h"
#import "UserAccountService.h"
#import "STOService.h"
#import "TodoInfo.h"
#import "TodoInfoDao.h"
#import "WorkflowInfo.h"
#import "WorkflowDao.h"
#import "TotoListTableViewCell.h"
#import "IPad_TodoDetailViewController.h"
#import "RefreshTableHeaderView.h"
#import "RefreshTableFooterView.h"
#import "AppDelegate.h"
@interface TodoListViewController (PrivateMethods)

-(void)initView;
@end

@implementation TodoListViewController
//@synthesize tableview;
@synthesize todoInfoArr;
@synthesize view_loading;
@synthesize mainViewDelegate;
@synthesize tabbarDelegate;
@synthesize iphoneDetailTabViewController;
@synthesize oldTodoId;
//NSString *oldTodoId;
//-(id)init{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self = [super initWithNibName:@"TodoListViewController_iPhone" bundle:nil];
//    } else {
//        self = [super initWithNibName:@"TodoListViewController_iPad" bundle:nil];
//    }
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
            [super initWithNibName:@"TodoListViewController_iPad" bundle:nil];
        }else{
            self = [super initWithNibName:@"TodoListViewController_iPhone" bundle:nil];
        }
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
}

-(void)viewDidAppear:(BOOL)animated{
//    [self loadTodoListWithType];
//    self.oldTodoId =nil;
}

- (void)viewDidLoad
{
      [super viewDidLoad];
    
    [self loadTodoListWithType];
    self.oldTodoId =nil;
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RefreshTableHeaderView" owner:self options:nil];
    RefreshTableHeaderView *refreshHeaderView = (RefreshTableHeaderView *)[nib objectAtIndex:0];
    self.headerView = refreshHeaderView;
    
    nib = [[NSBundle mainBundle]loadNibNamed:@"RefreshTableFooterView" owner:self options:nil];
    RefreshTableFooterView *refreshFooterView = (RefreshTableFooterView *)[nib objectAtIndex:0];
    self.footerView =  refreshFooterView;
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setFrame:CGRectMake(0, 96, 280, 652)];
   
    
    self.todoTypeArr = [NSArray arrayWithObjects:@"工作联系单", @"发文流程",nil];
    self.todoTypeParamArr = [NSArray arrayWithObjects:@"多级工作联系单", @"新发文流程",nil];
    
}

- (void)viewDidUnload
{
    [self setTypeBtn:nil];
    [self setTypeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)||(interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
}
-(void)refreshData:(BOOL)clearOld{
    if (clearOld) {
        self.oldTodoId = nil;
    }
    
    STOService *service = [[STOService alloc]init];
    [service reflashTodoList];
    self.todoInfoArr = [service searchAllTodoList];
    [service release];
    [self.tableView reloadData];
}

-(void)refreshData:(BOOL)clearOld WithType:(NSString *)typeName{
    if (clearOld) {
       self.oldTodoId = nil;
    }
    
    STOService *service = [[STOService alloc]init];
    [service refreshTodoListWithType:typeName];
    [service release];

    TodoInfoDao *dao = [[TodoInfoDao alloc]init];
    self.todoInfoArr = [dao searchTodoInfoListByTypename:typeName];
    [dao release];
    
   // [self.tableview reloadData];
    [self.tableView reloadData];
}

- (IBAction)action_iphone_back:(id)sender {
    if (tabbarDelegate) {
        [tabbarDelegate hiddenTabbar:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)action_iphone_search:(id)sender {
}

- (IBAction)changeTypeAction:(id)sender {
    if (self.typePickView == nil) {
        UIPickerView *typeView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 200, 180)];
        self.typePickView = typeView;
        [typeView release];
        self.typePickView.delegate = self;
        self.typePickView.dataSource = self;
        self.typePickView.showsSelectionIndicator= YES;
    }
    
    
    if (self.typePopoverController == nil) {
        UIViewController *popContent = [[UIViewController alloc]init];
        [popContent.view addSubview:self.typePickView];
        popContent.contentSizeForViewInPopover =CGSizeMake(210, 190);
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:popContent];
        
        [popContent release];
        self.typePopoverController = pop;
        [pop release];
    }
    
    [self.typePopoverController presentPopoverFromRect:self.typeBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

#pragma mark - private method implements


-(void)refreshTodoListWithType {

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        STOService *service  = [[STOService alloc]init];
        [service refreshTodoListWithType:[self.todoTypeParamArr objectAtIndex:self.currentTypeRow]];
        [service release];
//        TodoInfoDao *dao = [[TodoInfoDao alloc]init];
//        self.todoInfoArr = [dao searchTodoInfoListByTypename:[self.todoTypeParamArr objectAtIndex:self.currentTypeRow]];
//        [dao release];
        if (self.currentTypeRow == 0) {
            TodoInfoDao *dao = [[TodoInfoDao alloc]init];
            self.todoInfoArr = [dao searchTodoInfoListByTypename:[self.todoTypeParamArr objectAtIndex:self.currentTypeRow]];
            [dao release];
        }else if(self.currentTypeRow == 1){
            WorkflowDao *dao = [[WorkflowDao alloc]init];
            self.todoInfoArr = [dao queryWorkflowList];
            [dao release];
        }
        self.oldTodoId = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });        
}

-(void)loadTodoListWithType{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showLoadingWithText:@"正在载入..." inView: self.view];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        STOService *service  = [[STOService alloc]init];
        [service refreshTodoListWithType:[self.todoTypeParamArr objectAtIndex:self.currentTypeRow]];
        [service release];
        if (self.currentTypeRow == 0) {
            TodoInfoDao *dao = [[TodoInfoDao alloc]init];
            self.todoInfoArr = [dao searchTodoInfoListByTypename:[self.todoTypeParamArr objectAtIndex:self.currentTypeRow]];
            [dao release];
        }else if(self.currentTypeRow == 1){
            WorkflowDao *dao = [[WorkflowDao alloc]init];
            self.todoInfoArr = [dao queryWorkflowList];
            [dao release];
        }
//        TodoInfoDao *dao = [[TodoInfoDao alloc]init];
//        self.todoInfoArr = [dao searchTodoInfoListByTypename:[self.todoTypeParamArr objectAtIndex:self.currentTypeRow]];
//        [dao release];
        
        self.oldTodoId = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [appDelegate closeLoading];
        });
        
    });
}
- (void)dealloc {
 //  [tableview release];
    
    [view_loading release];
    [iphoneDetailTabViewController release];
    [_typeBtn release];
    [_todoTypeArr release];
    [_typeLabel release];
    [oldTodoId release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return todoInfoArr==nil?0:[todoInfoArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = @"IPad_TodoListCellIdentifier";
    
    TotoListTableViewCell *cell = (TotoListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TotoListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    switch (self.currentTypeRow) {
        case 0:
        {
            TodoInfo *todoInfo = [todoInfoArr objectAtIndex:row];
            [cell.labTitle setText:todoInfo.title];
            [cell.labSubTitle setText:[NSString stringWithFormat:@"发起时间：%@",todoInfo.occurTime]];
            break;
        }
            
        case 1:
        {
            WorkflowInfo *workflowInfo = [todoInfoArr objectAtIndex:row];
            [cell.labTitle setText:workflowInfo.docTitle];
            [cell.labSubTitle setText:[NSString stringWithFormat:@"发起时间：%@",workflowInfo.occurTime]];
            break;
        }
        default:
            break;
    }
//    TodoInfo *todoInfo = [todoInfoArr objectAtIndex:row];
//    [cell.labTitle setText:todoInfo.title];
//    [cell.labSubTitle setText:[NSString stringWithFormat:@"发起时间：%@",todoInfo.occurTime]];
    return cell;
    
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 85;
    } else {
        return 85;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      //  [view_loading setHidden:NO];
        
        double delayInSeconds = 0.1;
        __block TodoInfo *todoInfo = nil;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            STOService *service = [[STOService alloc]init];
            todoInfo = [[service getTodoInfoDetail:((TodoInfo *)[todoInfoArr objectAtIndex:row]).todoId] retain];
            [service release];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
          //  [view_loading setHidden:YES];
            [tabbarDelegate hiddenTabbar:YES];
            self.iphoneDetailTabViewController  = [[[IPhone_TodoDetailTabViewController alloc]init:todoInfo] autorelease];
            [self.navigationController pushViewController:iphoneDetailTabViewController animated:YES];
            iphoneDetailTabViewController.selectedIndex = 0;
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        });
       
        
    } else {
        if (self.currentTypeRow == 0) {
            TodoInfo *todoInfo = [todoInfoArr objectAtIndex:row];
            if (oldTodoId==nil||(oldTodoId!=nil&&![self.oldTodoId isEqualToString:todoInfo.todoId])) {
                self.oldTodoId = todoInfo.todoId;
                if (mainViewDelegate) {
                    [mainViewDelegate viewDetail_iPad:todoInfo];
                }
            }
        }else if(self.currentTypeRow == 1){
            WorkflowInfo *workflowInfo = [todoInfoArr objectAtIndex:row];
            if (oldTodoId==nil||(oldTodoId!=nil&&![self.oldTodoId isEqualToString:workflowInfo.pid])) {
                self.oldTodoId = workflowInfo.pid;
                if (mainViewDelegate) {
                    [mainViewDelegate viewDetail_iPad:workflowInfo];
                }
            }
        }
//        TodoInfo *todoInfo = [todoInfoArr objectAtIndex:row];
//        if (oldTodoId==nil||(oldTodoId!=nil&&![self.oldTodoId isEqualToString:todoInfo.todoId])) {
//           self.oldTodoId = todoInfo.todoId;
//            if (mainViewDelegate) {
//                [mainViewDelegate viewDetail_iPad:todoInfo];
//            }
//        }
    }
    
    
}

#pragma mark - UIPickView Delegate 
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.todoTypeArr objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
     [self.typePopoverController dismissPopoverAnimated:YES];
    if (row != self.currentTypeRow) {
        self.currentTypeRow = row;
        [self.typeLabel setText:[self.todoTypeArr objectAtIndex:row]];
        [self loadTodoListWithType];
        if (mainViewDelegate) {
            [mainViewDelegate closeViewDetail];
        }
    }
}

#pragma mark - Pull to Refresh

- (void)pinHeaderView {
    [super pinHeaderView];
    
    // do custom handling for the header view
    RefreshTableHeaderView *hv = (RefreshTableHeaderView *)self.headerView;
    [hv.activityIndicator startAnimating];
    hv.title.text = @"加载中...";
}

- (void)unpinHeaderView {
    [super unpinHeaderView];
    
    // do custom handling for the header view
    [[(RefreshTableHeaderView *)self.headerView activityIndicator] stopAnimating];
}

- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    RefreshTableHeaderView *hv = (RefreshTableHeaderView *)self.headerView;
    if (willRefreshOnRelease)
        hv.title.text = @"松开刷新...";
    else
        hv.title.text = @"下拉可以刷新...";
}

- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    
    // Do your async call here
    // This is just a dummy data loader:
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:2.0];
    // See -addItemsOnTop for more info on how to finish loading
    return YES;
}

- (void)refreshData {
    [self refreshTodoListWithType];
    [self refreshCompleted];
}


#pragma mark - Load More
- (void) willBeginLoadingMore
{
//    RefreshTableFooterView *fv = (RefreshTableFooterView *)self.footerView;
//    [fv.activityIndicator startAnimating];
}

- (void) loadMoreCompleted
{
//    [super loadMoreCompleted];
//    
//    RefreshTableFooterView *fv = (RefreshTableFooterView *)self.footerView;
//    [fv.activityIndicator stopAnimating];
//    
//    if (!self.canLoadMore) {
//        // Do something if there are no more items to load
//        
//        // We can hide the footerView by: [self setFooterViewVisibility:NO];
//        
//        // Just show a textual info that there are no more items to load
//        fv.infoLabel.hidden = NO;
//    }
}

- (BOOL) loadMore
{
//    if (![super loadMore])
//        return NO;
//    
//    // Do your async loading here
//    [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:2.0];
//    // See -addItemsOnBottom for more info on what to do after loading more items
//    
    return YES;
}

- (void)loadMoreData {
    
  //  [self.tableView reloadData];
    [self loadMoreCompleted];
}

@end
