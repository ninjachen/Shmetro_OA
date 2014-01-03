//
//  IPhone_MainContactViewController.h
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
@interface IPhone_MainContactViewController : UIViewController
@property (nonatomic, assign) id<TabbarViewControllerDelegate> tabbarDelegate;
- (IBAction)action_back:(id)sender;
@end
