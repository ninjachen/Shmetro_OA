//
//  IPhone_TodoDetailMonitorViewController.m
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import "IPhone_TodoDetailMonitorViewController.h"
#import "ApiConfig.h"
@interface IPhone_TodoDetailMonitorViewController ()

@end

@implementation IPhone_TodoDetailMonitorViewController
@synthesize tabbarDelegate;
@synthesize webview;
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
- (IBAction)action_process:(id)sender {
    if (detailViewControllerDelegate) {
        [detailViewControllerDelegate processTodo:self.todoInfo];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [webview loadRequest:[NSURLRequest requestWithURL:[ApiConfig getApproveMonitorUrl:self.todoInfo.instanceId]]];
}

-(id)init:(TodoInfo *)todoInfoObj{
    self = [super init];
    if (self) {
        self.todoInfo = todoInfoObj;
    }
    return self;
}

- (void)viewDidUnload
{
    [self setWebview:nil];
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
    [webview release];
    [super dealloc];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
@end
