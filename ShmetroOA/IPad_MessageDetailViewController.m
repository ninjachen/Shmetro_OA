//
//  IPad_MessageDetailViewController.m
//  ShmetroOA
//
//  Created by gisteam on 6/17/13.
//
//

#import "IPad_MessageDetailViewController.h"
#import "STOService.h"
#import "AppDelegate.h"

@interface IPad_MessageDetailViewController ()

@end

BOOL isOrgLoad = YES;

@implementation IPad_MessageDetailViewController
@synthesize messageDetailInfo,lblSourceDate,lblTitle,webViewContent,btnGoBack;


-(id)init:(MessageDetailInfo *)messageDetailInfoObj{
    self = [super init];
    
    if (self) {
        self.messageDetailInfo = messageDetailInfoObj;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
//    STOService *service = [[STOService alloc]init];
//    self.messageDetailInfo = [[service getMessageDetail:self.messageDetailInfo.mid] retain];
//    [service release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [((AppDelegate*)[[UIApplication sharedApplication]delegate])showLoadingWithText:@"正在载入..." inView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STOService *service = [[STOService alloc]init];
       self.messageDetailInfo = [service getMessageDetail:messageDetailInfo.mid App:messageDetailInfo.app];
        [service release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lblTitle.text = self.messageDetailInfo.title;
            NSString *pubDate = self.messageDetailInfo.pubDate;
            NSString *source = self.messageDetailInfo.source;
            self.lblSourceDate.text = [NSString stringWithFormat:@"发布时间：%@     来源：%@",pubDate,source];
            NSData* aData = [self.messageDetailInfo.content dataUsingEncoding: NSUTF8StringEncoding];
            [self.webViewContent loadData:aData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
            [self.view setBackgroundColor:[UIColor clearColor]];
            
        });
    });

    

    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidUnload{
    [self setBtnGoBack:nil];
    [self setMessageDetailInfo:nil];
    [self setLblTitle:nil];
    [self setLblSourceDate:nil];
    [self setWebViewContent:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [btnGoBack release];
    [messageDetailInfo release];
    [lblSourceDate release];
    [lblTitle release];
    [webViewContent release];
    [super dealloc];
}
-(IBAction)goBack:(id)sender{
    NSData* aData = [self.messageDetailInfo.content dataUsingEncoding: NSUTF8StringEncoding];
    [self.webViewContent loadData:aData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
    [self.btnGoBack setHidden:YES];
}

#pragma mark -UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request mainDocumentURL];
        NSError **error = NULL;
        if (![url checkResourceIsReachableAndReturnError:error]) {
            return NO;
        }else{
            NSString *fileExtName = [[url absoluteString]pathExtension];
            if ([[fileExtName lowercaseString] isEqualToString:@"txt"] || [[fileExtName lowercaseString] isEqualToString:@"log"]) {
                [self.webViewContent loadData:[NSData dataWithContentsOfURL:url] MIMEType:@"text/plain" textEncodingName:@"GB2312" baseURL:nil];
                [self.btnGoBack setHidden:NO];
                return YES;
            }
            [self.btnGoBack setHidden:NO];
            [((AppDelegate*)[[UIApplication sharedApplication]delegate])showLoadingWithText:@"正在载入..." inView:self.view];
        }
    }
    return  YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
      [((AppDelegate*)[[UIApplication sharedApplication]delegate])closeLoading];
}
@end
