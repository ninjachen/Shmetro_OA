//
//  IPhone_TodoDetailTabViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
#import "TodoInfo.h"
#import "IPhone_TodoDetailInfoViewController.h"
#import "IPhone_TodoDetailAttachFileViewController.h"
#import "IPhone_TodoDetailApproveViewController.h"
#import "IPhone_TodoDetailMonitorViewController.h"

@interface IPhone_TodoDetailTabViewController : UITabBarController<TabbarViewControllerDelegate,DetailViewControllerDelegate>{
    
}
@property (nonatomic,retain) IPhone_TodoDetailInfoViewController *infoViewController;
@property (nonatomic,retain) IPhone_TodoDetailAttachFileViewController *attachFileViewController;
@property (nonatomic,retain) IPhone_TodoDetailApproveViewController *approveViewController;
@property (nonatomic,retain) IPhone_TodoDetailMonitorViewController *monitorViewController;
@property (nonatomic,assign) TodoInfo *todoInfo;
-(void)reloadControllers:(int)index;

-(id)init:(TodoInfo *)todoInfoObj;
@end
