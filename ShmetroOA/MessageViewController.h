//
//  MessageViewController.h
//  ShmetroOA
//
//  Created by gisteam on 6/17/13.
//
//

#import <UIKit/UIKit.h>
#import "ShmetroOADelegate.h"
#import "STableViewController.h"


@interface MessageViewController : STableViewController<UITableViewDataSource,UITableViewDelegate>{
}

@property (nonatomic, assign) id<MainViewControllerDelegate> mainViewDelegate;
@property(retain,nonatomic)NSMutableArray *messageArray;
@property(nonatomic) NSInteger pageNumber;

@end
