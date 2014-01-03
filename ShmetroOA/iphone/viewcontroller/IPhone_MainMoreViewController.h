//
//  IPhone_MainMoreViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
@interface IPhone_MainMoreViewController : UIViewController
@property (nonatomic, assign) id<TabbarViewControllerDelegate> tabbarDelegate;
- (IBAction)action_back:(id)sender;
@end
