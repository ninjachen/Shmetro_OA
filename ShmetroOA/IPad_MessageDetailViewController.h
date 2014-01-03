//
//  IPad_MessageDetailViewController.h
//  ShmetroOA
//
//  Created by gisteam on 6/17/13.
//
//

#import <UIKit/UIKit.h>
#import "MessageDetailInfo.h"

@interface IPad_MessageDetailViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,retain)MessageDetailInfo *messageDetailInfo;
@property(nonatomic,retain)IBOutlet UILabel* lblTitle;
@property(nonatomic,retain)IBOutlet UILabel* lblSourceDate;
@property(nonatomic,retain)IBOutlet UIWebView *webViewContent;
@property(nonatomic,retain)IBOutlet UIButton *btnGoBack;

-(id)init:(MessageDetailInfo *)messageDetailInfoObj;
-(IBAction)goBack:(id)sender;
@end
